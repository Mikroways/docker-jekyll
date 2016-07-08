# Docker Jekyll

A Docker container that listens for HTTP posts and generates a Jekyll website
in an automated manner. With this container you could self-host a Jekyll website
and add support to auto-deploy it when a push is made on Github or Bitbucket.

## Build

```
docker build -t mikroways/jekyll .
```

# Usage

This container listens on port 80 and serves static content located on /data
directory. Content in that directory can be mounted from a volume or just
deployed through auto-deployment built-in capability.

## Automated deployment

In order to use automated deployment, this container requires three environment
variables to work:

* **HTTP_USER**: username for HTTP authentication.
* **HTTP_PASS**: password for HTTP authentication.
* **REPO_URL**: git repository URL to clone from.

Once the container is up and running, you need to access
http://hostname/deploy and provide the correct username and password when
prompted. That will trigger the deployment, which will be done in the following
manner:

* The repository will be cloned (or updated) in /tmp directory.
* bundle install and bundle exec jekyll build commands will be executed.
* The resulting HTML generated files in _site directory will be moved to /data,
  replacing existing files.

Note that /data directory can be mounted from a volume, but that is not a
requirement.

## Running

To run the container just execute the following command (in this example, it
will clone and serve Mikroways' website).

```
docker run -p 8080:80 -d -e "HTTP_USER=mikroways" -e "HTTP_PASS=password" -e
"REPO_URL=https://github.com/Mikroways/mikroways.net.git" mikroways/jekyll
```

## Automation with Github

Github configuration requires to go to Settings -> Webhooks & services -> Create
webhook.

* Payload URL enter: http://HTTP_USER:HTTP_PASS@hostname/deploy
* Content type: any
* Events: Push

## To Do

* Add a secret (maybe using POST to increase security). It's important to
  implement SSL in that case.
* Restrict location /deploy to be accesed only from Github IP addresses.

## Authors

* Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)
