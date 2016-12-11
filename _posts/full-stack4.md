---
title: Heroku连接云端MongoDB的方法
tags:
  - MongoDB
  - Heroku
  - Mongolab
categories:
  - MongoDB
  - Heroku
date: 2016-12-11 13:13:26
---


之前我们已经简单的在Heroku上部署了正在开发的web应用, 现在我们的应用要使用MongoDB数据库, 如何在云端部署一个MongoDB连接呢?

再进一步, 最终我们的目的是生产和开发环境连接不同数据库. 本文将完整叙述整个流程.

### 注册MongoLab账号
我们这里将使用MongoLab, 首先需要注册账号, 相关文档请见[这里][1]

### 创建一个新数据库
登陆后按照如下操作

![mongolab-1](http://ohrpyryjo.bkt.clouddn.com/16-12-11/30918370-file_1481429270266_10211.png)

选择`single node`, `sandbox`, 注意, 只有特定的区域才有`single node`节点可选, 需要自己手动试一下哪个可行.

![mongolab-single-node](http://ohrpyryjo.bkt.clouddn.com/16-12-11/91141098-file_1481429517670_ffd3.png)

创建成功后的效果

![](http://ohrpyryjo.bkt.clouddn.com/16-12-11/57873354-file_1481429810720_299e.png)

如果没有创建成功, 多半是数据库名称冲突了, 多试几个就好.

点击`Name`进入数据库, 提示要创建一个用户来使用数据库, 那么我们切换到`Users`标签, 点击`add database user`

![](http://ohrpyryjo.bkt.clouddn.com/16-12-11/90480148-file_1481430025597_8845.png)

配置Mongolab数据库连接字符串到heroku的配置文件中

```bash
$ heroku config:set MONGOLAB_URI=mongodb://<dbuser>:<dbpassword>@ds127958.mlab.com:27958/congyh
Setting MONGOLAB_URI and restarting ⬢ sheltered-everglades-85543... done, v10
...
```

### 同步本地开发数据库的测试数据到Mongolab
> **创建一个临时文件夹, 用于本地开发数据库的备份**

```bash
$ mkdir -p ~/tmp/mongodump
```
> **备份本地开发数据库**

```bash
$ mongodump -h localhost:27017 -d Loc8r -o ~/tmp/mongodump
```

> **还原数据到云端数据库**

```bash
$ mongorestore -h ds127958.mlab.com:27958 -d congyh -u <username> -p <password> ~/tmp/mongodump/Loc8r
...
2016-12-11T12:40:06.685+0800    finished restoring congyh.locations (3 documents)
2016-12-11T12:40:06.685+0800    done
```

> **检查数据还原情况**

首先使用mongo shell连接到远程数据库

```bash
$ mongo ds127958.mlab.com:27958/congyh -u <username> -p <password>
MongoDB shell version v3.4.0
connecting to: mongodb://ds127958.mlab.com:27958/congyh
MongoDB server version: 3.2.11
WARNING: shell and server versions do not match
rs-ds127958:PRIMARY>
```

列出数据

```sql
> show collections
> db.locations.find()
```

### 让应用根据环境自动选择连接的数据库
经过以上操作, 我们获得了一个和本地开发数据库同步的云端数据库, 由于我们的应用同时在本地开发和Heroku部署, 需要让应用根据环境自动连接到正确的数据库.

![database-in-two-locations](http://ohrpyryjo.bkt.clouddn.com/16-12-11/46376636-file_1481431744964_cf29.png)

> **设置NODE_ENV环境变量**

首先需要将heroku上部署的应用切换到`production`环境(注意: 要在应用根目录下执行指令).

```bash
$ heroku config:set NODE_ENV=production
Setting NODE_ENV and restarting ⬢ sheltered-everglades-85543... done, v11
NODE_ENV: production
```

> **更改应用源码中数据库连接的设置**

```javascript
var dbURI = 'mongodb://localhost/Loc8r';
if (process.env.NODE_ENV === 'production') {
    dbURI = process.env.MONGOLAB_URI;
}
mongoose.connect(dbURI);
```

> **本地测试连接到本地开发数据库和Mongolab数据库**

首先测试连接到本地开发数据库

```bash
$ nodemon
Mongoose connected to mongodb://localhost/Loc8r
```

然后测试连接到Mongolab数据库

```bash
$  NODE_ENV=production MONGOLAB_URI=mongodb://<dbuser>:<dbpassword>@ds127958.mlab.com:27958/congyh nodemon
Mongoose connected to mongodb:///<dbuser>:<dbpassword>@ds127958.mlab.com:27958/congyh
```
> 测试成功后, 将应用推送到Heroku仓库部署

```bash
$ git add .
$ git commit -am "add mongolab support"
$ git push heroku master
```

通过检查heroku云端应用日志, 验证数据库连接情况

```bash
$ heroku logs
...
2016-12-11T05:08:18.152506+00:00 app[web.1]: Mongoose connected to mongodb://<dbuser>:<dbpassword>@ds127958.mlab.com:27958/congyh
```

以上, 就完成了生产和开发环境连接不同数据库的配置.








[1]: http://docs.mlab.com/ "MongoLab文档"
