---
layout: post
title: Jekyll + Github  搭建属于你的静态博客
categories: [Jekyll]
tags: [Jekyll, Github]
---


## 1. 搭建Jekyll环境

linux下jekyll的安装非常简单，这里主要讲一下windows下的jekyll的安装过程  
这是一台刚刚装完系统的win10系统，它什么都没有，让我们从零开始。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j1.png)  

### 1.1 Install Ruby and the Ruby DevKit

Jekyll是使用ruby语言进行开发的，所以我们第一步需要安装ruby以及ruby相关的开发工具  
你可以在 [官网](http://rubyinstaller.org/downloads/)  下载我们所需要的安装包和开发工具  
教程用的是 ``rubyinstaller-2.2.3-x64`` 和 ``DevKit-mingw64-64-4.7.2-20130224-1432-sfx``  

``ruby`` 的安装需要注意一点，就是将ruby的可执行文件加入到环境变量的PATH中，如下图，将其勾上，然后安装即可。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j2.png)  

接下来我们安装 ``Ruby DevKit``，双击我们刚才下载的``DevKit-mingw64-64-4.7.2-20130224-1432-sfx``，将其解压到某个文件夹下，这里我选择的是``C:\RubyDevKit``，解压完毕后，我们以此输入如下命令  
``cd C:\RubyDevKit``   
``ruby dk.rb init``  
``ruby dk.rb install``  

最后我们可以用``gem -v`` 和 ``ruby -v``   来确认一下ruby和gem是否已经安装成功，如果安装过程中有什么问题，可以关闭cmd，再以管理员权限打开cmd尝试重新操作。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j3.png)  

### 1.2 Change the Gem's sources

我们用``gem sources``查看原始的gem源，发现是``https://rubygems.org/``  ，这意味着什么呢，，在这个CCFHQ的阻拦下，很多网站你是无法访问的，那我们更换一个国内的源吧。   
``gem sources --remove https://rubygems.org/`` 将原始的源删掉  
``gem sources -a https://ruby.taobao.org/`` 添加taobao的源  
``gem sources -u `` 更新缓存  
 
![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j4.png)  

好了，现在我们的gem可以放心使用了，妈妈再也不用担心我翻不了墙了。  


### 1.3 Install the Jekyll 

终于，我们可以安装jekyll了，只需要一调命令即可  
``gem install jekyll``  
经过些许的等待，我们成功安装了Jekyll，使用``jekyll -v``，我们看到目前的最新版本已经是``jekyll 3.1.0``，这里稍微强调一下，这个版本和之前的2.x.  x版本有些许不一样，可能在后面``_config.yml``的写法上可能有差异，不过没关系，这并不影响我继续前进。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j5.png)  

### 1.4 Build your first blog

至此，我们Jekyll 安装完毕。。。。  
我们赶紧来测试一下。。。你期待已久的博客马上诞生。  
这里我把当前工作目录切换到desktop  
使用``jekyll new firstblog``命令，我们在桌面创建出了一个firstblog文件夹，是的，这个就是你博客源文件存放的地方。  
我们进入这个目录``cd firstblog``，并``jekyll serve``  
打开浏览器，输入`` http://127.0.0.1:4000/``，是的，你看到了你用jekyll原生的模板创建出来的博客，你成功了，你的第一个blog。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j6.png)  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j7.png)  

另外，不需要本地测试时，使用``ctrl+c``关闭端口哦。  


你现在可以进入firstblog这个文件夹下，查看下模板都生成了些什么。  
是的，这里有若干个文件夹，和一些配置文件，这里我简要说明一下，  
``_includes``和 ``_layouts``  文件夹分别保存着一些html文件，而post文件夹，用来存放你要发布的文章，一般我们习惯用markdown来写博客，而jekyll是完全支持的。当然还有一个至关重要的文件``_config.yml``，这个文件用于设置站点的若干信息，非常重要。更多的细节，请参看官网。  



### 1.5 Install a Syntax Highlighter

实际上前面你可以看到，jekyll3.x版本没有自带wdm，那么我们用``gem install wdm``装一个吧。  

上面我们成功生成了一个模板，现在我们需要继续改进。  
作为一名coder，，我想代码高亮一定是我们所必要的。so。。我们需要一个代码高亮插件。  
jekyll 原生的代码高亮是``rouge``，这里，我们使用一个叫``Pygments``代码高亮插件，它是基于Python的，所以在这之前我们需要先安装Python。  

#### 1.5.1 Install Python

如果是python2.7.9以前的版本，除了安装Python，你可能还需要安装 pip，但是这之后的版本，安装Python的同时会自动安装pip，这里我选择的是最新版本``python-2.7.11.amd64``，所以我跳过了这一步，但是你记得在Python安装完毕后通过命令``python -m pip install --upgrade pip``将pip升级至最新版本。
安装时请务必把Python加入到环境变量PATH中，如果你忘记了，请手动添加。记得安装完毕后重启一次计算机。在命令行输入``Python -V`` 可以查看当前版本，同时也确认Python成功安装。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j8.png)  

#### 1.5.2 Install Pygments

先执行``python -m pip install Pygments``  
再执行``gem install pygments.rb``  
这样 pygments 就装好了。  
然后我们打开前面说到的``_config.yml``文件，在里面添加一行``highlighter: pygments``，这样我们就将默认的高亮换成了pygments  

我们自己写一篇post来测试吧    

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j9.png)  

将写好的post命名为``20xx-xx-xx-xx-xx.md``的形式，如``2014-06-30-manacher-algorithm.md``，并放入``_posts``文件夹下。  
我们再次``jekyll serve``，可以看到，pygments代码高亮测试成功  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j10.png)  

### 1.6 Using MathJax with Jekyll

作为一名acmer，恐怕数学公式是你必须要用到的，那么，我们用mathjax，使得我们的博客支持LaTex数学公式，，那是不是很美妙啊。。。哈哈。  

我们打开``_includes``文件夹中的``head.html``文件。  
加入如下代码  
{% highlight c++ %}
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [['$','$'], ['\\(','\\)']],
    processEscapes: true
  }
});
</script>

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      tex2jax: {
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
      }
    });
</script>
{% endhighlight%}

上面的代码是引用了mathjax的js，下面还处理的 `` $ `` ，这样我们可以通过使用 `` $`` 在行内插入公式，使用`` $$ `` 在行间插入公式
我们的博客就支持数学公式啦，等什么，再写一篇post来测试吧。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j11.png)  

beautiful，LaTex，大爱！！！  

至此，基本的设置，告一段落，更多惊喜请参考[jekyll官方网站](http://jekyll.bootcss.com/)  


## 2. 用Github展示你的博客

这里，再次说明，Ubuntu下，自带Python，安装jekyll几行命令可以搞定，安装pygments一行命令搞定，安装git也是一行命令可以搞定。  
所以这里还是讲windows端的安装，其他命令行下的操作，windows与linux几乎是一样的。  

### 2.1 安装git

在[官网](https://git-for-windows.github.io/)下载``git for windows``，直接安装即可。  
**以下所有的操作**，均在``git``(windows端的``git bash``)下进行，**不再使用前面用到的cmd命令行了**。  

### 2.2 使用Github

首先我们注册一个Github帐号。  
这里我的帐号昵称是``cainiaonidongde``  

#### 2.2.1 配置ssh  
1. 设置Git的user name和email：  
``git config --global user.name "cainiaonidongde"``  
``git config --global user.email "842212859@qq.com"``  
2. 查看是否已经有了ssh密钥：``cd ~/.ssh``  
如果没有密钥则不会有此文件夹，有则备份删除，你第一次玩github是肯定没有的  
3. 生成密钥：  
``ssh-keygen -t rsa -C “842212859@qq.com”``   按3个回车，密码为空。很明显能看到这里用的是RSA的加密体制，所以生成的文件必然有两个，一个公钥，一个私钥，不了解的同学记得去学习数论哦。再次``cd ~/.ssh``，ls之后你会发现两个文件，就是刚才说的，公钥（id_rsa.pub）和私钥  
4. 在github上添加一个ssh密钥，这要添加的是``id_rsa.pub``文件里面的内容。  
5. 测试：  
``ssh -T git@github.com``  
最后一行显示``Hi cainiaonidongde! You've successfully authenticated, but GitHub does not provide shell access.``，没错，我们成功了。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j14.png)  

#### 2.2.2  Create a new repository 

这时候，我们创建一个新的仓库  
这里仓库的名字必须为``你github的名字+github+io``，即``yourname.github.io``  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j12.png)  
![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j13.png)  

我将当前工作目录切换到桌面。`` cd Desktop/``  
1. 然后将我们创建的仓库克隆下来，当然，目前里面什么都没有  
``git clone https://github.com/cainiaonidongde/cainiaonidongde.github.io.git``  
2. 这时候你看到桌面上出现了一个文件夹cainiaonidongde，我们把firstblog下的所有文件复制过去。  
3. 切换到cainiaonidongde.github.io文件夹 ``cd cainiaonidongde.github.io/``  
4. ``git add .`` 添加所有文件  
5. ``git commit -m "my new blog"`` 提交修改信息  
6. ``git push origin master`` push到远程仓库  

另外这里使用https协议的在push时需要输入帐号密码，若改成ssh则可以不用输入，具体方法可以自行百度谷歌。  
  
### 2.3 Just enjoy it

现在，我们在浏览器中输入``http://cainiaonidongde.github.io/``，查看我们的博客。  

![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j15.png)  
![enter image description here](http://7xi3e9.com1.z0.glb.clouddn.com/j16.png)  

嗯，非常棒，，我们，成功了！！  



## 3. 关于linux

linux下搭建非常简单，就是依次安装gem，jekyll，git。。然后就该怎么搞怎么搞就行了。  

## 4. 参考文献

> [Run Jekyll on Windows](http://jekyll-windows.juthilo.com/3-syntax-highlighting/)  
> [Installation](https://pip.pypa.io/en/latest/installing/)  
> [Git SSH Key 生成步骤](http://blog.csdn.net/hustpzb/article/details/8230454)  
> [jekyll](http://jekyll.bootcss.com/)  
