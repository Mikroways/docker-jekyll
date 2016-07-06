#!/bin/bash

set -e

cd /tmp
git clone $REPO_URL jekyll_site
cd jekyll_site
bundle install
bundle exec jekyll build
rm -Rf /data/* && mv _site/* /data/
