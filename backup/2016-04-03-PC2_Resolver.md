---
layout: post
title: PC^2 API之滚榜神器「Resolver」
categories: [python]
tags: [icpc]
---


## 0. 关于PC^2

PC^2的基本使用，不想再写了，如果你还不了解什么是PC^2，[戳我][1]

## 1. 什么是Resolver

虽然进 World Finals 对于我来说是「不可能事件」，但是你一定见过，wf的滚榜吧。  
它会让你热血沸腾的，它是什么呢，，对，就是这个东西——「[Resolver][2]」


## 2. 导出文件

使用Resolver之前，我们需要从PC^2中导出``Event Feed XML for ICPC Tools Resolver``文件  
PS:  记得在导出之前，把比赛结束   

![][3]




## 3. 使用Resolver

- Resolver是用java开发的，所以使用之前请确保你的机器已经配置了JDK。

- 下载Resolver并解压，我们可以看到如下文件：  

![][4]

- 将我们导出的XML文件放入该文件夹，其实你只要知道路径就可以了

- 通过控制台来运行它，比如：  

```
resolver.bat Event Feed XML for ICPC Tools Resolver
```

## 4. 高级用法

我们还可以附带其他的参数,,,其实这些在官方文档中都有！！！！  

```
//fast 能够改变滚榜的速度，speedFactor为0-1之间的浮点数
--fast [speedFactor] 
// 默认情况下冠军是 World Champion，这里我们改成Champion就行了。。毕竟不是WF比赛啊
--citation "string"
//单步执行，这个非常有用
--singleStep [startRow]
//显示所有获奖情况，金，银，铜，FB等。哈哈
--showAllFTSAwards
```
比如我输入如下命令：  

![][5]

那么我就把冠军的奖项设为``Champion``，并以``0.5``的速率，单步执行滚榜程序

当然还有一个文件操作，我们可以把参数都写在文件里  

![][6]


## 5. 尽情享用吧  

![][7]

![][8]

![][9]

![][10]



  [1]: http://www.cnblogs.com/BigBallon/p/4160507.html
  [2]: https://icpc.baylor.edu/icpctools
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/pc233_meitu_1.jpg
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/222222SS.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/444441221412.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/ssp_meitu_2.jpg
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/SSW11.jpg
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/SSW222.jpg
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/SSW444.jpg
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/SSW2115.png