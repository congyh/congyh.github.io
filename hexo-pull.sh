#!/bin/sh

git pull origin hexo
cp -a _config.yml ../
cp -a next_config.yml ../themes/next/_config.yml
cp -a package.json ../package.json
exit 0
