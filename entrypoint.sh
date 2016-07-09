#!/bin/bash

set -e

# Generate aleatory secret to be used for posts requests.
SECRET=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-64};echo;`
echo "Secret to send posts with: $SECRET"

# Replaces REPO_URL for the one passed as an environment variable.
sed -i 's@REPO_URL@'"$REPO_URL"'@g' /bin/generate-html.sh
# Replaces SECRET expected in posts requests for the randomly generated one.
sed -i 's@SECRET@'"$SECRET"'@g' /bin/generate-html.sh

echo "www-data ALL=(root) NOPASSWD: /bin/generate-html.sh" >> /etc/sudoers
htpasswd -bc /etc/nginx/.htpasswd $HTTP_USER $HTTP_PASS
/usr/sbin/nginx -g "daemon off; error_log /dev/stdout;"
