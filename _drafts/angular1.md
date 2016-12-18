---
title: Angular基础(一)
tags:
categories:
---

Angular是客户端的框架, 让我们能够在浏览器中构建整个应用程序.
我们能够使用Angular来与REST API进行交互.

Angular是一个MVW模式的框架, W的意思是"Whatever works for you". 意思就是它能够作为controller, view-model, services的任意一种使用.

## 双向数据绑定(two-way data binding)
双向数据绑定指的是model和view的绑定, 它有以下特征

> 视图的改变会更新模型, 模型的改变也会更新视图, 一切都是发生在浏览器中的

![two-way-data-binding](http://ohrpyryjo.bkt.clouddn.com/16-12-14/43062226-file_1481688667084_58c0.png)

## Angular Scope
Angular有一个`rootScope`, 也就是`ng-app`定义的scope, 子scope是由`ng-controller`创建的.

在Angular中, scope是与view, model和controller绑定的, 它们使用的是相同的scope.
