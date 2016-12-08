#!/bin/sh

cp -a ../_config.yml ./
mv _config.yml hexo_config.yml
cp -a ../themes/next/_config.yml .
git add .
git commit -m "hexo backup"
git push origin hexo
exit 0
