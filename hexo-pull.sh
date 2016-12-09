#!/bin/sh

git pull origin hexo
cp -a _config.yml ../_config.yml
cp -a next_config.yml ../themes/next/_config.yml
cp -a custom.styl ../themes/next/source/css/_variables/custom.styl
cp -a highlight.styl ../themes/next/source/css/_common/components/highlight/highlight.styl
cp -a duoshuo-hot-articles.swig ../themes/next/layout/_partials/duoshuo-hot-articles.swig
cp -a package.json ../package.json
# 不删掉运行hexo g会出现错误
rm -f ./highlight.styl
exit 0
