---
layout: post
title: CPE Solution
categories: [icpc]
tags: [icpc]
---

## 2016-10-04 CPE

---

### 11192: Group Reverse

> 分组，翻转

### 1587: Box

> 题意： 多组数据，每组数据给定6个长方形的长和宽，问，这6个长方形是否能拼成长方体  
> 分析：

- 分情况讨论：

1. 3种不同长度的边，每种边各4条$(1,2)(2,3)(3,1)$
2. 2种不同长度的边，$(1,2)(2,2)(2,2)$
3. 正方体，$(2,2)(2,2)(2,2)$

- 排序：
对所有边进行降序排序，两两比较，全部当作第一种情况考虑，因为排序的缘故，只有一种配对可能。  
PS：读入的时候需要将进行适当的交换(短边在前，长边在后)


### 10415: Eb Alto Saxophone Player

> 题意： 萨克斯有$c,d,e,f,g,a,b,C,D,E,F,G,A,B$个音调，每个音调需要若干个手指按压来实现，给定一个曲谱，问每个手指头按了多少次？  
> 分析： 看清题意简单模拟即可


### 11344: The Huge One

> 大数除以小数，简单模拟

### 12694: Meeting Room Arrangement

> greedy..时间安排问题，对结束时间升序排序，然后$O(n)$扫一遍  

### 439: Knight Moves

> 骑士遍历问题，裸bfs

### 11624: Fire!

> bfs预处理 + bfs or 两个bfs合并(多源BFS)  


## 2016-05-24 CPE

---

### 11942	Lumberjack Sequencing

> 乱搞

### 499	What's The Frequency, Kenneth?

> 统计

### 948	Fibonaccimal Base

> 简单模拟

### 10200	Prime Time

> 暴力，精度

### 11995	I Can Guess the Data Structure!

> STL

### UVA 10025	The ? 1 ? 2 ? ... ? n = k problem

>  题意： 给定一个K，问表达式? 1 ? 2 ? ... ? n = k成立的最小的n 
如：$- 1 + 2 + 3 + 4 + 5 + 6 - 7 = 12 \;\;\;n = 7$ 

只考虑正数的情况（负数取绝对值）  

- 对于每一个$i$,考虑全部相加的情况：
    - $sum>k \;and\; sum-k \;is\; even$, $i \;is \;answer$
    - $otherwise \;continue$
-  $sum-k$需要为偶数的原因是，每将一个$+$改变为$-$，必定会减少$2x$,所以如果当前的$i$要成立，必须有$sum-k$是偶数


### 11472	Beautiful Numbers