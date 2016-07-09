#!/bin/bash

set -e

# If secret got from HTTP request does not match the expected
# finish execution with an error.
! [ "SECRET" == "$1" ] && exit 1

cd /tmp
if [ -d jekyll_site ]; then
  cd jekyll_site
  git pull origin master
else
  git clone REPO_URL jekyll_site
  cd jekyll_site
fi
bundle install
bundle exec jekyll build
rm -Rf /data/* && mv _site/* /data/
