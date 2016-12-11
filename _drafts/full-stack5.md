---
title: 使用REST API操作MongoDB
tags: [REST,MongoDB,Express]
categories: [MongoDB,Express]
---

使用REST API, 我们能够通过HTTP请求来对MongoDB进行CRUD操作. REST API对于我们的应用来说就是一个无状态的接口, 对于MEAN技术栈来讲, REST API的地位是创建一个暴露一个操作数据库的无状态接口, 供其他应用操作数据库的数据.

![REST-in-MEAN](http://ohrpyryjo.bkt.clouddn.com/16-12-11/46599607-file_1481433994795_b81.png)

### REST API功能
通常, 我们希望借助REST API完成以下操作
- 创建一个新记录
- 读取一个list的记录
- 读取指定的记录
- 更新指定记录
- 删除指定记录

假如我们现在要创建的是地址记录, 假定我们要使用的URL路径是`/locations`, 那么各个操作对应到`URL`路径之后如下表所示

|动作|URL路径|路径参数|例子|
|---|---|---|---|
|创建一个新记录|/locations||http://example/api/locations|
|读取一个list的记录|/locations||http://example/api/locations|
|读取指定的记录|/locations|locationId|http://example/api/locations/123|
|更新指定记录|/locations|locationId|http://example/api/locations/123|
|删除指定记录|/locations|locationId|http://example/api/locations/123|

通过上表可以看出, 多个不同的动作可能对应的是相同的URL路径, 那么如何进行动作的区分呢? 答案是通过HTTP请求类型来判断.

### HTTP请求类型
通常, REST API使用到四种HTTP请求, 它们的用途和相应如下所示

|HTTP请求类型|用途|响应|
|---|---|---|
|POST|创建新记录|数据库中插入新记录|
|GET|读取记录|从数据库返回指定记录|
|PUT|更新记录|更新数据库中的指定记录|
|DELETE|删除记录|数据库中指定记录被删除|

### 结合HTTP请求类型和URL路径确定唯一的操作
|动作|HTTP请求类型|URL路径|路径参数|例子|
|---|---|---|---|---|
|创建一个新记录|POST|/locations||http://example/api/locations|
|读取一个list的记录|GET|/locations||http://example/api/locations|
|读取指定的记录|GET|/locations|locationId|http://example/api/locations/123|
|更新指定记录|PUT|/locations|locationId|http://example/api/locations/123|
|删除指定记录|DELETE|/locations|locationId|http://example/api/locations/123|
