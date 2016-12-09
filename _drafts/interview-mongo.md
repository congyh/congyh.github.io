---
title: MongoDB知识点汇总
tags:
  - MongoDB
  - NoSQL
  - 面试
categories: 面试题
date: 2016-12-08 17:39:29
---


## MongoDB适用场景
- **日志** 每个应用环境都有不同的日志信息, 文档型数据库没有固定的模式, 很适合用来存储日志.
- (TODO 待补充)

## MongoDB的特点
### 无模式
降低在OOP中使用的阻力, 适用于保存对象. 因为一个对象只需要串行化成一个JSON就可以传递给MongoDB了, 不需要进行属性映射或者类型映射.

### 受限集合与TTL索引
受限集合在达到存储上限的时候, 旧文档会自动清除. 还可以通过`tail`一个受限集合, 来获取最新的数据.

如果想让数据过期, 可以通过创建TTL索引, 来显式指定一个数据的过期时间.

### 地理空间查询
MongoDB支持2d索引, 可以方便的保存geoJSON或者x和y坐标到文档, 通过`$near`或者`$within`操作来进行附近或者区域数据.

### 事务
MongoDB不支持事务(TODO 待补充)

### 如何理解MongoDB集群的高可用性
详见:[MongoDB高可用性](/2016/12/08/mongo-high-availability)

## MongoDB和mysql的优劣势对比
1. MySQL适合于传统的对关联要求高的方面, 而对于MongoDB来说, 关联一般做成内联的.
