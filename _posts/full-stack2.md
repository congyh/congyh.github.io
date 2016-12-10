---
title: Jade模板中变量的使用
tags:
  - jade
categories:
  - Jade
date: 2016-12-10 13:33:44
---

> **形式1: JavaScript行内代码**

```javaScript
h1= pageHeader.title
```

> **形式2: 插值**

```javascript
some text #{pageHeader.strapline}
```
注意: 以上两种做法都会将html代码直接转为文本输出(出于安全考虑), 如果想保留原来的html标签输出, 则使用`!=`和`!{}`的形式即可

> **形式3: 使用JavaScript代码段**

```javascript
- for (var i = 1; i < location.rating; i++)
    <本行为Jade代码>
```

注意:
- 整体上来看, 与JavaScript语法相当像, 不过现在不是用大括号标识代码块, 而是用缩进来标志.
- `if`语句不需要用"-"连接

> **形式4: 使用mixin定义可重用的代码段**

无参数的`mixin`定义

```javascript
mixin welcome
    p Welcome
```

调用`mixin`的语法为

```jade
+welcome
```

下面是带参数的`mixin`定义

```javascript
mixin outputRating(rating)
    - for (var i = 1; i <= rating; i++)
        <这里是jade代码>
```

调用带参数的`mixin`语法

```jade
+outputRating(<实参>)
```

如果我们想要在其他文件中使用在本文件中定义的`mixin`, 通过`include`关键字加路径实现. 例如, 现在我们的目录层级如下所示:

```bash
├── _includes
│   └── sharedHTMLfunctions.jade
└── locations-list.jade
```

我们想通过`location-list.jade`文件来引用`_includes/sharedHTMLfunctions.jade`中的mixin, 可以如下使用:

```jade
include _includes/sharedHTMLfunctions
...
+outputRating(<实参>)
```
