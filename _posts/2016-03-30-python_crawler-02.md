---
layout: post
title: 听说你叫爬虫(1) —— 从urllib说起 
categories: [python]
tags: [爬虫]
---


## 0. 前言  

如果你从来没有接触过爬虫，刚开始的时候可能会有些许吃力  
因为我不会从头到尾把所有知识点都说一遍，很多文章主要是记录我自己写的一些爬虫   
所以建议先学习一下``cuiqingcai``大神的 [Python爬虫学习系列教程 ][1]  的入门部分。   
它的整个系列教程我觉得写得非常好，值得一看！     
当然，即便是你什么都不会，也没关系。  
只要有一颗上进的心，没什么是学不会的。  
希望我的文章能给你些许帮助！  

## 1. 扒下一个网页

什么都不讲，直接上一段代码


	import urllib2
	html = urllib2.urlopen( 'http://music.163.com/' )
	print html.read()


我们将其保存为 ``test.py``, 通过 ``python test.py``  运行该代码,可以看见终端下出现了网易云音乐主页的``html``源代码，是的，我们把它扒下来了。  
![test][2]

别急，我们把代码改一下  


	import urllib2
	response = urllib2.urlopen( 'http://music.163.com/' )
	html = response.read()
	open( 'test.html',"w").write(html)


执行该代码后，当前目录下会出现一个 ``test.html`` 文件，是的，我们把网页保存下来了。    

## 2. urllib2库

下面我们来分析一下上面的代码  
首先，我们将``urllib2``模块导入，以便后续使用   
可以看到我们调用了一个名为``urlopen()``的方法，它一般接受三个参数，方法执行后，返回一个``response``对象,具体定义如下：  
``def urlopen(url, data=None, timeout=socket._GLOBAL_DEFAULT_TIMEOUT):``  
第一个参数``url``即为网页的URL  
第二个参数``data``是访问URL时要传送的数据  
第三个参数``timeout``是设置超时时间    

第二和第三个参数在不传的情况下使用的是默认值``None``和``socket._GLOBAL_DEFAULT_TIMEOUT``    
第一个参数``url``是必须要传的，这里我们传的是网易云音乐的URL。   

在我们获取到的页面信息，就存放在``response``对象中，我们再通过调用``read()``方法，它可以返回网页的内容。   
最后，我们再使用文件读写操作，将页面内容保存在``test.html``中，这样，我们就成功扒取了网易云音乐的主页内容。 

  
## 3. URI 和 URL

首先你需要明白一个简单的问题，我们在浏览器地址栏一般值输入：``www.baidu.com``  
但实际上，百度的URL应该是:``https://www.baidu.com/``  
这就是我们所要理解的统一资源定位器``URL``(Uniform Resoure Locator)，基本的URL地址包含三个部分：    
1. 协议：客户与服务器之间所使用的通信协议  
2. 主机标识：存放信息的服务器地址  
3. 文件名：存放信息的路径和文件名  
可以看到 ``http://tieba.baidu.com/f?kw=acm&fr=index``就是一个典型的URL  
另外，还要清楚一个概念，``URL``是``URI``的一个子集，``URI``包括了``URL``和``URN``，如果你对概念有些模糊，参考 [这里][3]。  


## 4. GET 和 POST

在客户机和服务器之间进行请求-响应时，两种最常被用到的方法是：``GET`` 和 ``POST``。  

- GET 从指定的资源请求数据。  
- POST 向指定的资源提交要被处理的数据  

这两个请求方式很重要，你可以事先在度娘或者谷哥那里了解一下  

- [HTTP 方法：GET 对比 POST][4]    
- [浅谈HTTP中Get与Post的区别][5]  

简单来讲，可以这样理解：  

> get是从服务器上获取数据，post是向服务器传送数据



## 5. 必要的分析

想要爬取特定的信息或是数据，还需要对指定的网页进行分析，这也就涉及到了抓包工具以及正则表达式的使用，这些以后都会讲到。


## 6. 一个简短的例子


	import urllib2  
	import re # 正则表达式所用到的库

	# 我们所要下载的图片所在网址
	url = 'http://desk.zol.com.cn/bizhi/6377_78500_2.html' 
	response = urllib2.urlopen(url)
	# 获取网页内容
	html = response.read() 

	# 确定一个正则表达式，用来找到图片的所在地址
	reg = re.compile(r'<img id="bigImg" src="(.*?jpg)" .*>'); 
	imgurl = reg.findall(html)[0]

	# 打开图片并保存为haha.jpg
	imgsrc = urllib2.urlopen(imgurl).read() 
	open("haha.jpg","w").write(imgsrc)


![test2][6]

上面简短的代码片段，功能是下载ZOL桌面壁纸网站上某个指定图片。  
其中用到了我们前面介绍的urlopen，open等方法，当然，还用到了一个和正则表达式有关的类库，你可以尝试着自己写一个demo，扒一下某个知名的或者不知名的网站。  

这篇文章就到这里，以后的文章都以具体的例子展开，空讲理论不适合我。  

> Q: 如何入门爬虫？  
A: 请直接上路！


  [1]: http://cuiqingcai.com/1052.html
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/Screenshot%20from%202016-03-30%2017:44:30.png
  [3]: http://www.biaodianfu.com/uri-url-urn-relationship.html
  [4]: http://www.w3school.com.cn/tags/html_ref_httpmethods.asp
  [5]: http://www.cnblogs.com/hyddd/archive/2009/03/31/1426026.html
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/Screenshot%20from%202016-03-30%2019:12:40.png