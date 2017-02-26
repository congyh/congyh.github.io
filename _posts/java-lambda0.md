---
title: Java-通过lambda表达式进行惰性计算
tags:
  - java
  - lambda
categories:
  - java
date: 2017-02-26 13:17:22
---


lambda表达式的出现使得JDK8内部发生了很多有趣的变化, 其中就包括惰性计算的特性.

<!--more-->
这里以JDK标准库中的Logger为例, 1.8以前的log方法有如下签名:

```java
public void log(Level level, String msg) {
        if (!isLoggable(level)) {
            return;
        }
        LogRecord lr = new LogRecord(level, msg);
        doLog(lr);
    }
```

也就是说客户端程序调用log方法的时候, 无论最终是否触发log行为, `msg`始终是要被计算的. 若计算`msg`是非常耗时的行为, 那么无疑会造成不必要的开销. 下面是一个调用的例子:

```java
log(Level.WARNING, "Log msg: " + someExpensiveOperation());
```

在java 1.8版本出现之后, 该方法多了如下重载:

```java
public void log(Level level, Supplier<String> msgSupplier) {
        if (!isLoggable(level)) {
            return;
        }
        LogRecord lr = new LogRecord(level, msgSupplier.get());
        doLog(lr);
    }
```

`Supplier`是一个`FunctionalInterface`, 也就是说现在的`log`方法可以接受一个无参的lambda表达式作为参数, 而计算的过程也被延迟到了`supplier.get()`的调用时. 改进后的调用例子:

```java
// 注意: 传入的lambda表达式并不会立即执行, 而是在log中判断isLoggable(level)成功后才会执行
log(Level.WARNING, () -> "Log msg: " + someExpensiveOperation());
```
