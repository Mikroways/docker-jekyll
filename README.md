# Docker Jekyll

A Docker container that listens for HTTP posts and generates a Jekyll website
in an automated manner. With this container you could self-host a Jekyll website
and add support to auto-deploy it when a push is made on Github or Bitbucket.

## Build

```
docker build -t mikroways/jekyll .
```

## Running

To run the container just execute the following command (in this example, it
will clone and serve Mikroways' website).

```
docker run -p 8080:80 -d -e "HTTP_USER=mikroways" -e "HTTP_PASS=password" -e
"REPO_URL=https://github.com/Mikroways/mikroways.net.git" mikroways/jekyll
```

After starting, the container will deploy the website for the first time and set
up basic authentication for automated deployments.

As you can see, you need to define three environment variables (which are
required):

* **HTTP_USER**: username for HTTP authentication.
* **HTTP_PASS**: password for HTTP authentication.
* **REPO_URL**: git repository URL to clone from. In case you're using a private
  GitHub repository, you can specify the GitHub username and password like this:
  `https://username:password@github.com/username/repository`

## Automated deployment

Automated deployment works executing the following actions:

* The repository will be cloned (or updated) in /tmp directory.
* bundle install and bundle exec jekyll build commands will be executed.
* The resulting HTML generated files in _site directory will be moved to /data
  directory, replacing existing files.

The first time the deployment is run can take some time (depending on repository
size, internet connection, etc.). Following deployments should be much quicker,
as it will just download changes and install only new gems.

Note that /data directory can be mounted from a volume, but that is not a
requirement.

To use automated deploy you can choose between a simple method with basic HTTP
authentication and a more complex one which uses both basic HTTP authentication
and a secret in the requirement's body.

### Using basic authentication

By default, the container supports basic authentication, using the username and
password defined with the environment variables HTTP_USER and HTTP_PASS, so no
further action is needed to use this method.

To see how to force the deployment, please refer to the Test section of this
README.

### Using basic authentication and a secret

This requires defining two additional environment variables:

* **USE_SECRET**: this variable must be set to 'yes' (lowercase).
* **SECRET (optional)**: the secret you want to use. Please do not use the `|`
  character in the secret.

In case you do not specify a secret, it will be automatically generated. In that
case, you'll need to check the container logs and look for the string "Secret to
send posts with" to get the secret:

```
Secret to send posts with:
5se7xfS2waUwwD9Nw4c0k4tvIuqGHUTDuALkeOk8W1Tflxn8xIJcA-O0Ay3S366Z
```

## Test

To test everything works OK follow the steps below.

1. Access the website: after the first deploy has finished you should see the
  website online.
2. Force deployment:

If you chose to use just basic authentication:

```
curl -X POST http://mikroways:password@hostname/deploy-with-basic-auth
```

If you chose to also use a secret:

```
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d
'secret=5se7xfS2waUwwD9Nw4c0k4tvIuqGHUTDuALkeOk8W1Tflxn8xIJcA-O0Ay3S366Z'
http://mikroways:password@hostname/deploy-with-secret
```

If it worked OK you will see in the container logs that the deployment process
has started. If anything was changed in the remote repository, you will see
changes applied after deployment finishes.

## Automation with Github

Github only works with the basic authentication method. To set it up you need to
go to Settings -> Webhooks & services -> Create webhook.

* **Payload URL**: http://HTTP_USER:HTTP_PASS@hostname/deploy-with-basic-auth
* **Content type**: any.
* **Secret**: leave it empty.
* **Events**: Push

## License

The MIT License (MIT)

Copyright (c) 2016 Leandro Di Tommaso

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Authors

* Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)
