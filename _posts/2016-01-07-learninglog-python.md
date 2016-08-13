---
layout: post
title: python学习小记
categories: [python]
tags: [ipcp, python]
---


## 入坑python ¶

适当要接触一下python了，采取的策略是直接上手，边用边学。
**未完成，，完善中。。。。。。**

---

## 0. 参考文档 ¶

- [Python 入门指南 ¶][1]
- [The Python Tutorial ¶][2]
- [Python 2.7教程 - 廖雪峰 ¶][3]
- [循序渐进学Python ¶][4]
- [30个有关Python的小技巧 ¶][5]
- [Python字符编码详解 ¶][6]
- [Python函数式编程指南：目录和参考 ¶][7]

## 1. 数据结构 ¶

在python中有六种内建序，它们是：  
列表、元组、字符串、Unicode字符串、buffer对象和xrange对象  

### 1.0 通用操作 

所有的序列都可以进行特定的操作，它们分别是：  

 - 索引(indexing)： 序列中所有元素都是有编号的，索引从0开始递增，这和C语言是相同的。而神奇的是，python还支持负数索引，即从序列的右端开始计数，-1代表序列的最后一个元素。
 - 分片(sliceing)： 分片也是python的一个强大之处，我们可以使用分片操作来访问一定范围内元素。
 - 加(adding)： 类似于C++的string类，python也支持两个类型相同的序列的连接操作。
 - 乘(multiplying)： 使用数字n乘以一个序列会生成新的序列，在新的序列中，原来的序列将被重复n次。
 - 检查某个元素是否属于这序列(index)： ``in``
 - 计算序列长度(len)： ``len(x)``
 - 找出最大元素和最小元素(min/max):  ``min(x)`` ``max(x)``

### 1.1 列表 List 

#### 1.1.1 list函数

通过使用list函数可以将字符串转换为一个序列。(注意：list函数适用于所有类型的序列，而不只是字符串)

#### 1.1.2 list方法  

- append：把一个元素添加到链表的结尾  
- count：用于统计某个元素在列表中出现的次数：  
- extend：将一个给定列表中的所有元素都添加到另一个列表中   
- index：用于从列表中找出某个值第一个匹配项的索引位置  
- insert：在指定位置插入一个元素。第一个参数是准备插入到其前面的那个元素的索引    
- pop：从链表的指定位置删除元素，并将其返回  
- remove：删除链表中值为 x 的第一个元素。如果没有这样的元素，就会返回一个错误  
- reverse：就地倒排链表中的元素  
- sort：对链表中的元素就地进行排序  


### 1.2 元组 Tuple 

python中的tuple 类似于C语言中的常量，是不可修改的。

### 1.3 字典 Dictionaries 

### 1.4 字符串

### 1.5 集合 Set 

### 1.6 堆 Heap 

## 2. Python 流程控制 ¶

- if 语句  
- for 语句  
- range() 函数  
- break 和 continue 语句, 以及循环中的 else 子句  
- pass 语句  

## 3. 输入输出


  [1]: http://www.pythondoc.com/pythontutorial27/index.html
  [2]: https://docs.python.org/2.7/tutorial/index.html
  [3]: http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000
  [4]: http://www.cnblogs.com/IPrograming/category/476786.html
  [5]: http://blog.jobbole.com/63320/
  [6]: http://www.cnblogs.com/huxi/archive/2010/12/05/1897271.html
  [7]: http://www.cnblogs.com/huxi/archive/2011/07/15/2107536.html