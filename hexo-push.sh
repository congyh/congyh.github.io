#!/bin/sh

cp -a ../_config.yml ./_config.yml
cp -a ../themes/next/_config.yml ./next_config.yml
cp -a ../package.json ./package.json
cp -a ../themes/next/source/css/_variables/custom.styl ./custom.styl
cp -a ../themes/next/source/css/_common/components/highlight/highlight.styl ./highlight.styl
cp -a ../themes/next/layout/_partials/duoshuo-hot-articles.swig ./duoshuo-hot-articles.swig
git add . -A
git commit -m "hexo backup"
git push -f origin hexo
# 不删掉运行hexo g会出现错误
rm -f ./highlight.styl
exit 0
