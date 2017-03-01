---
layout: post
title: Something about Giraffe
date: 2017-02-27 23:48
---

## Run Giraffe in Ubuntu

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

> [The Programming Language Lua][7]  
> [Getting started with Torch][8]

先这样吧，明天再看看有什么新的进度！

反正现在我在Linux已经可以run起来而且train也是可以的！

![train][9]



## Run Giraffe in Windows(not use torch)

---


好吧，还是想试试看在Windows下面能不能run起来。
首先是安装lua，在Windows下面真的是比较麻烦，官网给出了如下一句话：

> If you use Windows, try [LuaDist][4], a multi-platform distribution of the Lua that includes batteries.

于是我开是安装LuaDist，点进去发现。。。。2333

> Windows users can follow our detailed [install instructions][5]

从bootstrap里面看到这句话，果然是要用cmake

> cmake --build "%BUILD%" --target install

紧接着build的好长时间

紧接着clone torch的least version，似乎有提供install.bat,仿佛看到了希望，233，于是乎发现这个是安装在msvc上的，果断看到还有一个install-deps，独立安装成功




于是我开始安装Cmake，加上原本我装过的minGW，都就为之后开始安装LuaDist，后来还是没有成功。233

好，我惊奇的发现makefile的第一行就是取消torch，然后就开始了漫长的mingw测试，最后发现可能是GCC太新了现在已经自动包含了threat所要的头文件，sad，最后我还是compile过了。

![][6]

## Conclusion

---

请不要早Windows上面搞Deep learning的东西，虽然tensorflow已经支持Windows了，但是我还是希望在Linux下面作业。  
minGW还是给力吖，另外makefile也是给力啊。233




  [1]: https://bitbucket.org/waterreaction/giraffe/overview
  [2]: http://blog.csdn.net/pdcxs007/article/details/8582559
  [3]: http://blog.csdn.net/abacn/article/details/45153579
  [4]: http://luadist.org/
  [5]: https://github.com/LuaDist/Repository/wiki/LuaDist:-Installation
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/giraffe5.jpg
  [7]: https://www.lua.org/home.html
  [8]: http://torch.ch/docs/getting-started.html
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/giraffe2.jpg