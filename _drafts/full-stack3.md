---
title: Mongoose+Mongo+Express
tags: [MongoDB,Mongoose,Express]
categories: [MongoDB]
---

Mongoose是在Express应用与MongoDB之间, 负责两者的连接与数据交换. 使用Mongoose我们可以方便的定义数据结构.

Mongoose的地位如下图所示

![mongoose-in-mean-stack](http://ohrpyryjo.bkt.clouddn.com/public/16-12-10/36603593.jpg)

### 添加Mongoose到应用中
Mongoose是一个npm模块, 可以像其他模块一样添加到程序中, 并写入依赖

```bash
$ npm install --save mongoose
```
### 配置Mongoose到应用范围内
在Express应用范围导入mongoose连接, 应在工程根目录的`app.js`中进行引入, 这里由于我们使用的是MVC架构, 所以应该将数据库部分的管理归类在models文件夹中. 我们在目录结构如下

```bash
app.js
app_server
├── controllers
├── models
    └──db.js
├── routes
└── views
    └── _includes
    index.js
```

我们在db.js中添加如下

```javascript
var mongoose = require('mongoose')
```

然后在`app.js`中新增如下配置

```javascript
require('./app_server/models/db')
```

由于我们不需要从`db.js`模块暴露方法, 不需要为`require`操作指定变量.

### 使用Mongoose指定连接
连接格式如下

![mongoose-connection-string](http://ohrpyryjo.bkt.clouddn.com/public/16-12-10/44969620.jpg)

如果我们是连接到本地mongo实例, 那么`username`, `password`, `port`字段都是可以省略的.

继续向`db.js`模块添加如下语句, 完成到本地mongo实例的连接

```javascript
var dbURI = 'mongodb://localhost/Loc8r';
mongoose.connect(dbURI);
```

注: 关于如何启动本地mongo实例, 请见我的文章:[MongoDB基础知识][1]

### 监控mongoose连接事件
现在我们想监控连接成功, 连接失败, 连接断开三个事件, 只需要向`db.js`追加如下代码

```javascript
mongoose.connection.on('connected', function() {
    console.log('Mongoose connected to ' + dbURI);
});
mongoose.connection.on('error', function(err) {
    console.log('Mongoose connection error: ' + err);
});
mongoose.connection.on('disconnected', function() {
    console.log('Mongoose disconnected');
});
```

### 关闭Mongoose连接
由于node应用停止时, mongo实例的连接池不会自动关闭, 下面我们将编写代码, 在Node应用退出的时候, 自动关闭mongo连接池.

Node应用退出前, 根据你启动应用的方式不同, 会释放出不同的信号, 如果我们想在任何场景都使Node应用退出时自动关闭连接, 则需要捕获所有的信号类型.

为此, 我们首先要定义一个通用的关闭连接的函数, 在里面完成`mongoose`连接的关闭.

```javascript
/**
 * 关闭mongoose连接
 * <p>
 * 这里定义了一个闭包, 外层的作用是为里层的函数提供'环境', 这里也就是msg参数.
 * 否则mongoose.connection.close本身是不接收带参数的回调函数的
 * @param msg 触发关闭的事件类型
 * @param callback 负责进行Node应用的关闭
 */
var gracefulShutdown = function (msg, callback) {
    mongoose.connection.close(function () {
        console.log('Mongoose disconnected through' + msg);
        callback();
    });
};

```

> **类型1: SIGINT**

此种信号产生在使用`npm start`指令启动的node应用停止前, 现在我们要在应用捕获到这个信号的时候先执行`mongoose`的关闭逻辑.

```javascript
process.on('SIGINT', function () {
    gracefulShutdown('app termination', function () {
        process.exit(0);
    })
});
```

> **类型2: SIGTERM**

此种信号产生在Heroku关闭应用进程前, 同样, 我们要在捕获到这个信号的时候先关闭`mongoose`连接.

```javascript
process.on('SIGTERM', function () {
    gracefulShutdown('Heroku app shutdown', function () {
        process.exit(0);
    })
});
```

> **类型3: SIGUSR2**

此种信号产生是用来通知`nodemon`进程来重启node应用的, 由于`nodemon`进程本身也依赖这个信号来进行node应用的重启逻辑, 所以我们不应该完全截断, 而是应该在捕获信号, 完成关闭`mongoose`逻辑之后再手动发出一个同样的信号, 通知`nodemon`完成应用的重启. **并且仅捕获此信号一次**, 防止第二次手动释放的信号又被应用进程截获.

```javascript
// 注意, 这里与上面的程序有两点不同, 一个是只捕获一次信号
// 另一点是这里用的是kill, 要求立即结束程序, 并要重新释放同样的信号
// 供nodemon使用
process.once('SIGUSR2', function () {
    gracefulShutdown('nodemon restart', function () {
        process.kill(process.pid, 'SIGUSR2');
    })
});
```






[1]: https://congyh.github.io/2016/12/08/mongo-basic/
