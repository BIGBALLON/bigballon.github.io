---
layout: post
title: Something about Giraffe
date: 2017-02-27 23:48
---

要开始trace [Giraffe][1]的code，昨天晚上和杰哥一起看了一些   
老师留下一些问题：

> Investigate features (363) related to bitboard (or map), rules?

这个明天早上我再细看一下

> Search node budget (256? Quiescence search? Probabilistic Search?), epoch moves (64? or 12?)

昨天晚上的讨论是，确实256（512）个结点作为限制，Quiescence search是有的。

> Verify whether it does run Probabilistic Search?



想试试能不能compile起来，看作者的overview是不支持MSVC的，也就是不支持Clang，不过还是可以在Windows下面用minGW来编译，我试图使用minGW64来编译，于是乎安装之后发下好像少了对openMP的支持。然后再用minGW32，似乎makefile必须安装了torch才能使用。还是无果。不过搜索的几篇blog还是记录一下防止以后要用之类的。

> [Windows安装GNU编译器使用makefile][2]  
> [MinGW下pthread和openMP的配置][3]  

于是乎，用teamviewer连到宿舍自己的ubuntu，先安了lua，然后安装torch，第一次装的时候不小心用来sudo权限，貌似没成功所以luaT.h找不到，第二次装看起来就比较舒服，还好学校网速快，要是大陆的话搞不好源的问题还是其他我又要装很久。还有就是要记住，看文档最好看完整，看一半装完可能有问题。不过torch也装了蛮久的。

> [The Programming Language Lua][4]  
> [Getting started with Torch][5]

先这样吧，明天再看看有什么新的进度！

反正现在我在Linux已经可以run起来而且train也是可以的！

![train][6]


  [1]: https://bitbucket.org/waterreaction/giraffe/overview
  [2]: http://blog.csdn.net/pdcxs007/article/details/8582559
  [3]: http://blog.csdn.net/abacn/article/details/45153579
  [4]: https://www.lua.org/home.html
  [5]: http://torch.ch/docs/getting-started.html
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/giraffe2.jpg