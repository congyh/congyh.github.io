---
title: MongoDB聚合操作
tags:
  - MongoDB
  - NoSQL
categories: MongoDB
date: 2016-12-08 17:15:20
---


前面都是查询操作, 本文设计的是MongoDB的数据分析与利用. 内容主要包括:
- 聚合框架;
- MapReduce;
- 简单的聚合命令: `count`, `distinct`和`group`.

<!--more-->

## 管道操作符
### \$match
\$match用于对文档集合进行筛选, 通常**放置在管道的靠前的位置**

例如: 下面指定了只有`state`字段为`OR`的文档符合条件:

```javascript
{"$match": {"state": "OR"}}
```

### \$project
投射操作, 用于提取文档中的指定字段, 例如:

```javascript
> db.articles.aggregate({"$project": {"author": 1}})
```

需要的字段需要显式指定为1.

也可以在投影的同时重命名字段:

```javascript
> db.articles.aggregate({"$project": {"author": "$_id", "_id": 0}})
```

上述操作将`_id`字段赋值给了`author`字段, 然后去除了`_id`字段, 相当于最后`author`代替了`_id`字段.

## 管道的使用原则
将`$project`, `$group`或者`$unwind`操作安排在管道的开始阶段.

## MapReduce
