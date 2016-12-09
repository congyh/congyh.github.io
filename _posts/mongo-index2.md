---
title: MongoDB索引--高级篇
tags:
  - NoSQL
  - MongoDB
  - 索引
categories: MongoDB
date: 2016-12-08 14:13:07
---



## 固定集合
MongoDB中默认的集合是动态创建的, 可以自动增长以容纳更多的数据, 而固定集合类似于循环队列, 当集合满时会自动将最老的文档删除. 固定集合的数据被写入磁盘上的固定空间, 所以**写入速度非常快**.

### 固定集合的创建
下述指令创建一个10w字节的固定集合

```javascript
> db.createCollection("collection_name", {"capped": true, "size": 100000})
```

## TTL索引
对于固定集合来讲, 如果需要超时自动移除文档, 那么可以使用TTL索引

```javascript
> db.foo.ensureIndex({"lastUpdated": 1}, {"expireAfterSecs": 60*60*24})
```

以上代码设置了超时时间为1天.

## 地理空间索引
MongoDB支持几种类型的地理空间索引. 其中最常用的是`2dsphere`索引(用于地球表面类型的地图)和2d索引(用于平面地图和时间连续的数据).

### 2d索引
对于非球面的地图(游戏地图, 时间连续的数据等), 可以使用2d索引代替`2dsphere`.

一个符合2d索引的文档

```javascript
{
  "name": "Water Temple",
  "title": [32, 22]
}
```

查询`[20, 21]`点附近的对象

```javascript
> db.hyrule.find({"title": {"$near": [20, 21]}})
```

以`[12,25]`为圆心, 5为半径, 查询出某个圆形范围内的点

```javascript
> db.hyrule.find({"title": {"$within": {"$center": [[12, 25], 5]}}})
```

## 使用GridFS存储文件
GridFS是MongoDB的一种存储机制, 通常用来**存储不经常改变但是经常需要连续访问的大型二进制文件**.
