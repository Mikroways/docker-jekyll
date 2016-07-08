#!/bin/bash

set -e

sed -i 's@REPO_URL@'"$REPO_URL"'@g' /bin/generate-html.sh
echo "www-data ALL=(root) NOPASSWD: /bin/generate-html.sh" >> /etc/sudoers
htpasswd -bc /etc/nginx/.htpasswd $HTTP_USER $HTTP_PASS
#/usr/sbin/nginx -g "daemon off; error_log /dev/stdout info;"
