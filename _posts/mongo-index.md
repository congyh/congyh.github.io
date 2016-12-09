---
title: MongoDB索引-初级篇
tags:
  - NoSQL
  - MongoDB
  - 索引
categories: MongoDB
date: 2016-12-8 14:16:50
---



## 为什么要使用索引
下面以一个例子来说明: 假设我们现在有一个100w条的文档数据, 每个文档数据都包含一个`username`字段, 其值从`user1`到`user1000000`, 假定我们希望通过`username`进行查询.

```javascript
> db.user.find({username: "user101"})
```

我们可以在查询的同时开启操作的监控:

```javascript
> db.user.find({username: "user101"}).explain()
{
  ...
  "nscanned": 1000000,
  "nscannedObjects": 1000000,
  "millis": 721,
  ...
}
```
我们可以看到集合中的所有的文档都会被扫描, 因为**无法确定集合中的`username`字段是唯一的**.

如果不使用索引的话, 我们可以通过限制查询结果数量来强制mongo找到符合条件的结果即返回.

```javascript
> db.user.find({username: "user101"}).explain()
{
  ...
  "nscanned": 102,
  "nscannedObjects": 102,
  "millis": 2,
  ...
}
```

虽然上面的查询扫描数量减少了, 但是如果要查找的是user999999就还是需要整体扫描一遍.

## 创建索引
如下是按照`username`字段正序(指定为1)创建索引.

```javascript
> db.user.ensureIndex({"username": 1})
```

由于创建索引比较费时, 可以通过在另一个shell中执行`db.currentOp()`或者是检查mongod的日志来 查看索引创建进度. 当索引创建完成后, 再次执行最初的查询.

```javascript
> db.user.find({"username": "user101"}).explain()
{
  ...
  "nscanned": 1,
  "nscannedObjects": 1,
  "millis": 3,
  ...
}
```

使用了索引之后查询几乎可以瞬间完成, **但是每次写操作(包括插入, 更新和删除)将会耗费更多时间**. 因为要同时更新文档和索引. 所以**实际使用中, 不应该拥有两个以上的索引**.

## 复合索引
就是在多个字段上创建一个索引, 注意**索引间是有顺序的**, 例如:

```javascript
> db.user.ensureIndex({"age": 1, "username": 1})
```

实际创建的索引会先按照`age`字段排序, 然后按照`username`字段排序. 这个索引主要有以下三种使用方法:

### 点查询
```javascript
> db.user.find({"age": 21}).sort({"username": -1})
```

由于之前我们创建了符合索引, 所以首先可以直接定位到`age`为21的记录, 然后由于这些记录是按照`username`正序排列好的, 所以可以直接用`sort()`方法指定逆序输出, **不需要额外的时间开销**.

### 多值查询
```javascript
> db.user.find({"age": {"$gte": 21, $"lte": 30}}).sort({"username": 1})
```
由于这个查询跨了多个`age`值, **虽然在每个`age`值内`username`是有序的, 但是整体来看是无序的, 所以需要在内存中先对结果进行排序, 然后才能返回.** 所以说这个查询通常会较为低效.

### 隐式索引
我们现在创建了一个`{"age": 1, "username": 1}`的索引, 实际上我们同时也获得了一个`{"age": 1}`索引, 也就是说:
> 如果我们有一个N个键的索引, 那么想到哪关于我们同时获得了这N个键的前缀组成的索引.

### 复合索引创建的准则
> 用于精确匹配的字段, 放在索引的前面;用于范围匹配的字段放在最后.

假设现在要使用`{"age": 1, "username": 1}`的索引进行查询, 构造以下查询:

```javascript
> db.user.find({"age": 47, "username": {"$gt": "user5", "$lt": "user8"}}).explain()
```

> 在基数比较高的键上建立索引, 至少要把基数高的键放在复合索引的前面

因为一个字段的基数(也就是取值的可能值)越高, 这个键上的索引就越有用. 举个例子, 比如我们在`gender`字段上创建索引, 那么只能将搜索空间缩小到50%左右; 而如果我们在`name`字段上创建索引, 那么结果集就会非常小, 查询时间大大缩短.

## 何时不应该使用索引
通常来说, 当查询返回较小的结果集时, 索引会非常高效. **结果集在原集合中所占比例越大, 索引的速度就越慢**. 因为索引需要进行两次查找, 一次是查找索引条目, 一次是根据索引去查找文档. 一般来说, 当结果集占原集合30%左右时, 就需要考虑是否直接进行全表扫描来代替索引.

## 索引类型
### 唯一索引
可以在单个字段上或者符合字段上创建唯一索引, 被唯一索引标识的字段在集合中不能重复.

```javascript
> db.user.ensureIndex({"username": 1}, {"unique": true})
```

### 稀疏索引
唯一索引会对该字段上所有的取值进行索引, 也就是说`null`也会被视为有值, 所以并不适合于在有缺失值的字段上使用, 而稀疏索引会忽略掉缺失值, 只对该字段存在值的部分文档进行索引.

```javascript
> db.ensureIndex({"email": 1}, {"sparse": true})
```

当然, 可以与唯一索引结合使用

```javascript
> db.ensureIndex({"email": 1}, {"unique": true, "sparse": true})
```
