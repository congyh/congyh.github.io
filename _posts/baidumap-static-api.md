---
title: 百度地图静态图API使用指南
tags:
  - 百度地图API
categories:
  - 教程
date: 2016-12-10 23:27:08
---


本文的目的是根据经纬度获取一张指定大小的静态地图, 用于内嵌在网页中.

> **步骤1: 申请百度开发者账号**

这部没什么好讲的, 和申请百度账号相仿

> **步骤2: 申请一个密钥**

点击`API控制台`->`开发`->`静态图API`

![staticmap-api](http://ohrpyryjo.bkt.clouddn.com/16-12-10/57596357-file_1481382723758_3961.png)

点击`获取密钥`, 勾选全部权限, 然后设置访问网址为`0.0.0.0/0`.

点击`API控制台`, 这里可以看见先前生成的密钥

![baidumap-ak](http://ohrpyryjo.bkt.clouddn.com/16-12-10/90398887-file_1481382976290_1def.png)

> **步骤3: 在应用中嵌入图片, url指定为符合静态图API的网址**

这里举一个示例网址

`http://api.map.baidu.com/staticimage/v2?ak=这里是你自己的ak&mcode=666666&center=116.403874,39.914888&width=400&height=350&zoom=11&markers=116.403874,39.914888`

嵌在程序中会达到以下效果

![baidumap-staticmap](http://ohrpyryjo.bkt.clouddn.com/16-12-10/60860268-file_1481383464963_17e3b.png)

其中
- `ak`是刚才的密钥
- `center`是经纬度
- `markers`是地图标注的经纬度
