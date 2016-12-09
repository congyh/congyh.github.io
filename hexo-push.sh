#!/bin/sh

cp -a ../_config.yml ./_config.yml
cp -a ../themes/next/_config.yml ./next_config.yml
git add . -A
git commit -m "hexo backup"
git push origin hexo
exit 0
