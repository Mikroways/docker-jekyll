#!/bin/bash

set -e

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
