---
title: Oracle到MySQL数据库迁移之--主键生成策略替换
tags:
  - MySQL
  - Oracle
  - 数据库迁移
  - Sequence
  - Hibernate
  - 存储过程
categories:
  - MySQL
  - Oracle
date: 2017-01-03 14:40:35
---


Oracle数据库到MySQL数据库迁移过程中的一大难题就是主键生成策略的替换. 如果之前的程序中使用Oracle的`Sequence`机制来实现主键的自增的话. MySQL中需要另寻他法进行等价替换.

替换的时候, 主要有两个地方需要修改:
- 数据库存储过程;
- Java程序的修改

## Java程序中的修改
这里以Hibernate操作数据库为例进行演示.

### 使用Oracle Sequence
假如你之前的程序使用的是`Sequence`, 这里以一个名为`SEQ`的`Sequence`为例,  那么你操作`id`字段的代码应该长的是下面这个样子:

```java
@SequenceGenerator(name = "generator", sequenceName = "SEQ")
@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generator")
public Long getId() {
	return id;
}
```

### 使用MySQL表模拟Oracle Sequence
首先你需要在MySQL中建立一个表`sys_sequence`, 表中有两个字段, 一个是`seq_name`, 代表Oracle序列的名称, 另一个是`current_value`, 代表该序列的当前值(注意: 需要将此初始值设定为Oracle数据库中对应序列的当前值.). 表的样子如下:

```sql
> select * from sys_sequence;
+--------------+------------+
| seq_name     | curr_value |
+--------------+------------+
| SEQ          |      2809  |
+--------------+------------+
```
. 然后在程序中如下编写:

```java
/**
* allocationSize是每次程序启动第一次插入时与之前最大值的差值.
*/
@Id
@TableGenerator(name = "sequence", table = "sys_sequence", pkColumnName = "seq_name", valueColumnName = "curr_value", pkColumnValue = "SEQ", allocationSize = 1)
@GeneratedValue(strategy = GenerationType.TABLE, generator = "sequence")
private Long id;
```

## 存储过程的修改
存储过程中, 主要涉及到`Sequence`的`nextval()`等方法的替换, 我们同样可以在MySQL中进行模拟.

### 使用Oracle Sequence
假设我们现在有一个`Sequence`名为`SEQ`, 那么我们通常在存储过程中使用如下函数获得`SEQ`的下一个值:

```sql
SEQ.nextval
```

### 使用MySQL模拟Oracle Sequence
首先需要创建一个表格, 用于存储所有序列的名称, 当前值以及递增步长. 这里我们继续沿用前面所述的`sys_sequence`表, 不过还需要为表新增一个字段`increment_by`, 我们对照Oracle数据库的设置手动进行`increment_by`初值的设定.

```sql
> select * from sys_sequence;
+--------------+------------+--------------+
| seq_name     | curr_value | increment_by |
+--------------+------------+--------------+
| SEQ          |      2809  |            1 |
+--------------+------------+--------------+
```

然后在数据库中新增两个函数, 一个是`currval`, 用于获取模拟的`Sequence`的当前值:

```sql
CREATE DEFINER=`root`@`%` FUNCTION `currval`(`v_seq_name` varchar(50)) RETURNS decimal(18,0)
BEGIN
DECLARE v_currval DECIMAL(18);
    SET v_currval = 1;  
    SELECT curr_value INTO v_currval FROM sys_sequence WHERE seq_name = v_seq_name;  
    RETURN v_currval;  
END
```

 另一个是`nextval`, 用户获取模拟的`Sequence`的下一个值:

```sql
CREATE DEFINER=`root`@`%` FUNCTION `nextval`(`v_seq_name` varchar(50)) RETURNS decimal(18,0)
BEGIN
	  UPDATE sys_sequence SET curr_value = curr_value + increment_by WHERE seq_name = v_seq_name;  
    RETURN currval(v_seq_name);  
END
```

之后在需要使用`Sequence`的地方, 使用如下语句替代即可:

```sql
nextval('SEQ')
```

## 小结
如此一来, 就达到了利用MySQL的表来模拟Oracle的Sequence的目的. 以后每当有需要替换的序列, 都在前面建立的`sys_sequence`中新增一行即可.
