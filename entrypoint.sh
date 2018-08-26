#!/bin/bash

set -e

function startup {
  # If SECRET is not set, generate random string to be used for posts requests.
  : ${SECRET=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-64};echo;`}
  echo "Secret to send posts with: $SECRET"

  # Replaces REPO_URL for the one passed as an environment variable.
  sed -i 's|REPO_URL|'"$REPO_URL"'|g' /bin/generate-html.sh
  # Replaces SECRET expected in posts requests for the randomly generated one.
  sed -i 's|__SECRET|'"$SECRET"'|g' /bin/generate-html.sh

  echo "www-data ALL=(root) NOPASSWD: /bin/generate-html.sh" >> /etc/sudoers
  htpasswd -bc /etc/nginx/.htpasswd $HTTP_USER $HTTP_PASS
  /bin/generate-html.sh $SECRET
}

# The following line executes startup function the first time the
# container is started.
grep -q REPO_URL /bin/generate-html.sh && startup

/usr/sbin/nginx -g "daemon off; error_log /dev/stdout;"
