#!/bin/sh

git pull origin hexo
cp -a hexo_config.yml ../
rm -f ../_config.yml
mv ../hexo_config.yml ../_config.yml
rm -f ../themes/next/_config.yml
cp -a _config.yml ../themes/next/
exit 0