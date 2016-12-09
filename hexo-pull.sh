#!/bin/sh

git pull origin hexo
cp -a _config.yml ../
cp -a next_config.yml ../themes/next/_config.yml
exit 0
