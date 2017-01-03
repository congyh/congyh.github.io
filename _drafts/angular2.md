---
title: Angular基础(二)--第一个Angular程序
tags: [Angular]
categories: [Angular]
---

### 添加Angular到现有的web程序中的方法
> #### 步骤1: 下载Angular的lib

到官网上下载即可, 下载的文件一般叫做`angular.min.js`

> #### 步骤2: 创建一个Angular模块

创建一个js文件, 然后进行angular模块的创建, controller的创建等一系列操作. 例如, 我们想创建一个叫做"loc8rApp"的Angular模块.

```javascript
// 创建一个angular模块, 相当于setter方法
angular.module('loc8rApp', []);

// scope参数是随着controller的建立隐式创建的
var myController = function ($scope) {
    $scope.myInput = "world!";
};

// 相当于一个getter方法, 获取了"loc8rApp"这个模块.
angular.module('loc8rApp')
    // 这里相当于一个setter方法, 设置了一个controller
    .controller('myController', myController);
```

> #### 步骤3: 关联Angular模块到html文件

```html
<!DOCTYPE html>
<html ng-app="loc8rApp">
<head>
    <meta charset="UTF-8">
    <title>Angular binding test</title>
    <script src="angular.min.js"></script>
    <!--这里一定要记得引入一个模块-->
    <script src="loc8rApp.js"></script>
</head>
<body ng-controller="myController">
    <input ng-model="myInput" />
    <h1>Hello {{myInput}}</h1>
</body>
</html>
```

经过以上配置, 一个简单的Angular程序就完成了, 我们可以通过在浏览器中打开网页查看效果:

![angular-sample-app](http://ohrpyryjo.bkt.clouddn.com/16-12-18/27701773-file_1482036322668_1547e.png)

随着我们的输入, 视图也会随之改变.

![](http://ohrpyryjo.bkt.clouddn.com/16-12-18/93900990-file_1482036378517_f53a.png)

### 使用ng-repeat遍历数组元素
我们可以如下定义一个控制器:

```javascript
var myController = function ($scope) {
    $scope.items = ['one', 'two', 'three'];
};
```

然后在html中这样遍历(注意, `ng-repeat`要绑定在需要重复的元素上, 在下例中是`li`元素)

```html
<body ng-controller="myController">
    <ul>
        <li ng-repeat="item in items">{{item}}</li>
    </ul>
</body>
```

在浏览器中查看是如下效果:

![angular-ng-repeat](http://ohrpyryjo.bkt.clouddn.com/16-12-18/32430745-file_1482037618010_4b55.png)

### Angular filter
