---
title: 从零构建部署Node.js+Express+Bootstrap Web应用
tags:
  - Node.js
  - Express
  - Bootstrap
  - Heroku
categories:
  - Web开发
  - Node.js
date: 2016-12-09 15:40:07
---

本文将包括以下内容:
- 创建一个Express应用
- 使用npm和`package.json`管理应用依赖
- 调整Express工程结构到MVC架构
- Route和Controller概念分离
- 创建新的Node模块(module)
- 使用Git在线部署Express应用到Heroku

<!--more-->

在进行一切操作之前, 需要先安装好Node.js, 对于\*nix用户来说, 直接下载解压, 并添加到环境变量中即可完成安装.

首先从Express着手, Express是构建在Node之上的web应用框架.

## 使用package.json定义依赖
每个Node应用的根目录都有一个文件叫做`package.json`, 用来记录Node应用的依赖, 例如:

```json
{
  ...
  "depencencies": {
    "express": "~4.9.0"
    ...
  }
}
```

其中"~"表示使用最近的patch版本, 推荐使用.

## 使用npm安装Node依赖
### 工程范围的依赖
在和`package.json`相同的目录层级运行以下指令即可:

```bash
$ npm install
```

这会将所有的依赖(包括间接依赖)下载到`node_modules`文件夹内. 如果后期你想向工程中追加依赖, 只需要运行以下指令:

```bash
$ npm install <package-name> --save
```

以上指令完成了两步操作:
- 将指定`package`下载到`node_modules`文件夹;
- 将依赖条目追加到`package.json`文件内.

### 全局范围的依赖
一些通用的依赖需要安装成全局依赖, 例如express generator:

```bash
$ npm install -g express-generator
```

依赖会被安装到以下路径: `${NODE_HOME}/lib/node_modules/express-generator`

## 创建并启动一个Express工程
1. 新建一个文件夹
2. 在文件夹内运行`express`
3. `npm install`按照`package.json`的定义安装所有依赖
4. `npm start`启动程序, 浏览器访问localhost:3000即可.

## Express的用户请求处理逻辑
如下图所示

![express-handle-request](http://ohrpyryjo.bkt.clouddn.com/public/16-12-9/26624679.jpg)

## 重启一个Node应用
> 如果你修改了服务端的Node代码, 那么需要停止应用运行, 编译并重新启动

重启应用的方法有两种, 一种是从启动应用的控制台`ctrl+c`, 然后`npm start`, 另一种方法是使用nodemon, nodemom是Node应用的监控程序, 能够简化Node应用的开发. 安装方法如下:

```bash
$ npm install -g nodemon
```

然后使用`nodemon`指令代替`npm start`启动应用程序.

> 如果你只是修改了Jade模板, CSS文件, 或者客户端的js代码, 无需重新启动应用

## 调整Express工程结构到MVC模式
首先在根目录下新创建一个`app_server`文件夹, 将根目录下的`routes`和`views`文件夹移到里面:

![express-project-structure](http://ohrpyryjo.bkt.clouddn.com/public/16-12-9/64576206.jpg)

然后更改`app.js`文件, 将两者重新定位到新的位置. 具体的来说就是将原来的

```javascript
app.set('views', path.join(__dirname, 'views'));
var index = require('./routes/index');
var users = require('./routes/users');
```

变更为

```javascript
app.set('views', path.join(__dirname, 'app_server', 'views'));
var index = require('./app_server/routes/index');
var users = require('./app_server/routes/users');
```

## Node模块(module)的生成与使用
举个例子, 现在我们有`a.js`和`b.js`两个文件, 假设现在它们在同级目录下, 我们想在`b.js`文件中调用`a.js`中定义的变量或函数. 下面是`a.js`文件的内容

```javascript
module.exports.logThis = function(message) {
  console.log(message);
}
```

上述代码将`logThis`变量(函数)暴露出来, 供其他模块使用, 经过这样设定后我们就可以在`b.js`中如下调用

```javascript
var myModule = require("./a")
myModule.logThis("It works!")
```

需要注意的一点是, `require()`方法并不需要加后缀, 它会自动依以下顺序搜索:
- 寻找同名js文件
- 寻找同名文件夹下的`index.js`文件

## Bootstrap安装
1. 首先下载[Bootstrap发行版](www.getbootstrap.com), 解压并添加到Express工程下的public目录(public目录是用于存放静态资源的目录)下的bootstrap目录(需新建).
2. 由于Bootstrap依赖jquery, 所以我们还要下载jquery, 从这里[下载](http://jquery.com/download/), 注意下载完整版的, 不要下载slim版的, 点击之后, 会跳出一个代码页面, 直接拷贝全部, 然后保存在`public/javascript/jquery-<具体的版本.min.js`文件中即可.
3. 清空Express默认的样式. 具体的来讲, 就是清空`public/stylesheet/style.css`文件中的内容

### 安装Bootstrap主题
这里以Amelia主题为例, 从这里[下载](https://github.com/simonholmes/amelia), 将解压得到的`amelia.bootstrap.css`和`amelia.bootstrap.min.css`拷贝到Express工程下的`public/bootstrap/css`文件夹下.

## Jade模板的使用
Jade模板的使用原则是:
> 设计一系列的模板布局, 然后让其他文件去扩展

这里我们来看一个例子, 下面分别是`layout.jade`和`index.jade`文件的内容:

```jade
extend layout
block content
  h1= title
  p Welcome to #{title}
```

上面代码的意思是`index.jade`扩展了`layout.jade`, `block content`是`layout.jade`中声明的一个html填充块, 这里向里面填充了一个`<h1>`和一个`<p>`.

下面让我们来看一下`layout.jade`.

```jade
doctype html
html
  head
    title= title
    link(rel='stylesheet', href='/stylesheets/style.css')
  body
    block content
    script(src='/javascript/jquery-3.1.1.min.js')
    script(src='/bootstrap/js/bootstrap.min.js')
```
`layout.jade`除了用于定义html的模板, 还用来进行css和js脚本的连接, 注意: js脚本放在页面最下面有利于提升网页的加载速度. 此外, 第一行设置的`viewport`有利于页面能够在移动设备上良好的缩放.

到此, 使用Bootstrap的Amelia主题之后的显示效果如下:

![bootstrap-theme-amelia](http://ohrpyryjo.bkt.clouddn.com/public/16-12-9/73781121.jpg)

## 使用Heroku进行网站的对外在线演示
将网站托管到在线平台上的意义是:
> 可以便利的进行跨浏览器的测试, 跨设备测试, 并且能够向同事和合作伙伴快速展示与交流开发阶段性进展.

类似的平台服务还有Google Cloud Platform, Nodejitsu, OpenShift等.
## 安装Heroku
1. 从这里[注册](https://www.heroku.com/)一个免费账号
2. 下载[Heroku toolbelt](https://devcenter.heroku.com/articles/heroku-cli), 或者直接使用以下指令在Ubuntu中下载
   ```bash
   $ wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
   ```
3. 触发安装
   ```bash
   $ heroku --version
   ```
4. 验证安装成果
   ```bash
   $ heroku --version
   heroku-toolbelt/3.43.15 (x86_64-linux) ruby/1.9.3
   heroku-cli/5.5.6-a9ddee4 (linux-amd64) go1.7.4
   You have no installed plugins.
   ```
5. 登陆(实际上完成了类似ssh密钥对生成并上传公钥的工作)
   ```bash
   $ heroku login
   ```
### 使用Heroku提交Node.js应用
> 首先需要保证云端的运行环境与本地开发环境一致


具体的是在`package.json`中添加一个`engines`配置块, 指明node和npm的版本, 如果不清楚的话, 还是确认一下比较好:

```bash
$ node --version
$ npm --version
```

下面是示例的`package.json`文件:

```json
{
  "name": "Loc8r"
  ...
  "engines": {
    "node": "~4.6.0",
    "npm": "~2.15.9"
  },
  ...
}
```

> 创建一个云端启动脚本

具体来说就是创建一个启动脚本, 指明我们应用的类型以及启动指令, 对于Node.js应用来说, 需要在应用的根目录下创建一个名为`Procfile`的文件, 示例内容如下:

```bash
web: npm start
```

> 使用heroku local进行本地验证

`heroku local`的前身是`foreman`, 但是现在的heroku toolbelt中已经用前者替换掉了了后者, 详见如下[官方通知](https://devcenter.heroku.com/changelog-items/692)

`heroku local`工具是用来在提交应用前进行本地验证的, 使用`heroku local`启动应用前需要先关闭本地应用, 然后使用以下指令启动:

```bash
$ heroku local web
```

程序成功启动后会监听在5000端口, 我们可以通过`localhost:5000`来访问, 显示效果应与之前本地直接运行相同.

> 将应用托管到Heroku

首先需要初始化一个git仓库, 添加.gitignore文件, 推荐使用[这里](https://www.gitignore.io)自动生成(键入Node即可).

然后在云端创建一个heroku应用容器(隐式完成了本地仓库的关联)

```bash
$ heroku create
Creating app... done, ⬢ sheltered-everglades-85543
https://sheltered-everglades-85543.herokuapp.com/ | https://git.heroku.com/sheltered-everglades-85543.git
```

推送到远程仓库

```bash
$ git push heroku master
```

> 在heroku云端用测试机(dyno)来运行部署的程序

每位用户都会免费获得一个可用的web测试机, 使用如下指令来开启它

```bash
$ heroku ps:scale web=1
Scaling dynos... done, now running web at 1:Free
```

> 在线浏览部署情况

```bash
$ heroku open
```

自动在云端的网址上看到部署的应用的情况

![node-app-on-heroku](http://ohrpyryjo.bkt.clouddn.com/public/16-12-9/79249714.jpg)

之后修改了应用代码后, 只需要push到heroku容器的master分支, 就会自动更新并部署.
