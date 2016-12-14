---
title: mongoose使用
tags: [mongoose,MongoDB,Node.js]
categories: [MongoDB]
---

## Mongoose查询方法
- `find` 基本的查询语句
- `findById` 根据指定ID进行查询
- `findOne` 根据查询语句返回第一个结果
- `geoNear` 查找指定经纬度附近的地点
- `getSearch` 在`geoNear`的基础上添加查询条件

## 限制返回的查询结果的字段
使用`select`子句
