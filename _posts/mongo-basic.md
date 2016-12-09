---
title: MongoDB基础知识
tags:
  - NoSQL
  - MongoDB
categories: MongoDB
date: 2016-12-08 14:41:57
---

## 文档
文档就是键值对的一个有序集, **相当于传统关系型数据库的一行**. 比如map, hash或者dict(在JavaScript里表示为对象). 其中键是字符串类型的, 值可以是任意类型的.

文档中的**键值对是有序的**.

## 集合
集合就是一组文档, 相当于一张**表**. 虽然集合里面可以放置任何类型的文档, 但是还是建议分开存储(后面解释).

集合可以拥有子集合, 使用"."来界定命名空间. 例如: 一个拥有博客功能的应用可能包含两个集合, 分别是`blog.posts`和`blog.authors`. 很多mongodb工具都使用了子集合, 因为使用它来组织数据非常高效(后面介绍), 值得推荐.

## 数据库
多个集合组成数据库. 将数据库的名字添加到集合的名字前, 可以得到集合的全限定名. 例如`cms.blog.post`表示cms数据库中的`blog.posts`集合.

## MongoDB启动与监控
首先创建默认的数据存储目录

```bash
$ mkdir -p /data/db
```

通过以下命令启动(需要保证mongodb在环境变量中)

```bash
$ mongod
```

当服务器运行后, 会监听在27017端口. 同时还会启动一个基本的http服务器, 可以通过`http://localhost:28017`来访问数据库的管理信息.

## MongoDB shell
首先要保证MongoDB实例已启动, 然后通过以下命令进行连接

```bash
$ mongo
```

MongoDB shell是一个完整的JavaScript解释器, 也就是可以运行任意的JavaScript指令. 它也是一个独立的MongoDB客户端, 在启动时会连到test数据库, 并且将数据库的连接赋值为全局变量`db`, 可以通过`db`来访问MongoDB中的数据库. 如果需要切换数据库, 只需要运行如下指令:

```bash
> use foobar
switched to db foobar
```

### 连接远程数据库
```bash
$ mongo <host-ip/host-name>:<port>/<dbname>
```

### 不连接数据库进行启动
```bash
$ mongo --nodb
```

如果后面需要重新连接到数据库的话, 使用如下指令:

```javascript
> conn = new Mongo("some-host:port")
> db = conn.getDB("dbname")
```
