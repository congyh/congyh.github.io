---
title: 使用REST API操作MongoDB(一)
tags: [REST,MongoDB,Express]
categories: [MongoDB,Express]
---

使用REST API, 我们能够通过HTTP请求来对MongoDB进行CRUD操作. REST API对于我们的应用来说就是一个无状态的接口, 对于MEAN技术栈来讲, REST API的地位是创建一个暴露一个操作数据库的无状态接口, 供其他应用操作数据库的数据.

![REST-in-MEAN](http://ohrpyryjo.bkt.clouddn.com/16-12-11/46599607-file_1481433994795_b81.png)

## 设计REST API的请求处理部分
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

### 使用REST API操作子文档
以上介绍都是REST API操作父文档, 如果想操作子文档, 首先需要获取到父文档, 也就是如上表中的http://example/api/locations/123这样的路径, 现在假定每个`location`文档中还内嵌了名为`reviews`的子文档, 那么它所对应的操作如下

|动作|HTTP请求类型|URL路径|路径参数|例子|
|---|---|---|---|---|
|创建一个新记录|POST|/locations/locationId/reviews|locationId|http://example/api/locations/123/reviews|
|读取指定的记录|GET|/locations/locationId/reviews|locationId<br/>reviewId|http://example/api/locations/123/reviews/abc|
|更新指定记录|PUT|/locations/locationId/reviews|locationId<br/>reviewId|http://example/api/locations/123/reviews/abc|
|删除指定记录|DELETE|/locations/locationId/reviews|locationId<br/>reviewId|http://example/api/locations/123/reviews/abc|

注意, 子文档的操作并没有一个读取list的操作, 因为这个操作可以通过对父文档操作进行实现.

## 设计REST API响应(Response)和状态码
REST API的另一部分就是响应的设计, 响应一般来说包含两个部分:
- 返回数据
- HTTP状态码

对于返回数据, 通常是JSON或者XML类型的, 这里我们选择JSON类型, 因为它比XML数据更加紧凑, 并且天然适应MEAN技术栈. 对于每个请求, 返回数据都应该有三种类型:
- 包含正确返回的被请求数据的JSON对象
- 包含错误信息的JSON对象
- null响应

### 常用的HTTP状态码
> HTTP状态码通常是用来和响应一同返回的, 用于表明HTTP请求的执行情况.

常用的HTTP状态码共有10种

|状态码|名称|适用场景|
|---|---|---|
|200|OK|`GET`或者`PUT`请求成功|
|201|Created|`POST`请求成功|
|204|No content|`DELETE`请求成功|
|400|Bad request|`GET`, `PUT`或者`POST`请求由于内容不符合标准而失败|
|401|Unauthorized|身份验证未通过|
|403|Forbidden|不允许的请求|
|404|Not found|请求的URL没有资源或者参数错误|
|405|Method not allowed|指定的URL不允许此种请求类型|
|409|Conflict|`POST`失败, 试图插入重复数据|
|500|Internal server error|服务器或数据库故障|

### 在Express中建立响应API
使REST API不与应用的其他处理逻辑混杂, 所以这里我们单独对其进行管理.

首先, 在应用的根目录新建一个`app_api`目录, 这个目录将会包含`routes`, `controllers`, `models`(注意并没有`views`)

> #### 创建REST API路由

首先创建根路由, 也就是`index.js`, 并将其加载到`app.js`中,

```javascript
var index = require('./app_server/routes/index');
// 以下是新增的路由
var apiIndex = require('./app_api/routes/index');

app.use('/', index);
// 以下是新增的路由
app.use('/api', apiIndex);
```
