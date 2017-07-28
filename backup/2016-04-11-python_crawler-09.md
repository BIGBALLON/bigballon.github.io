---
layout: post
title: 听说你叫爬虫(8) —— 关于4399的一个小Demo
categories: [python]
tags: [爬虫]
---

堂弟喜欢各种游戏，在没有网络的情况下，上4399显得很无力。  
另外，4399广告好多，，而且加载慢。。

怎么办，，写个爬虫吧，，把4399上的“好玩”游戏爬下来。

## 1. 分析阶段

4399上的游戏，都是 ``.swf`` 格式的 ``flash``   

想 ``玩`` 到一个游戏，我们需要跳转若干的链接：  

![真是][1]

- 选择一个游戏 -> 进入到游戏介绍  
- 选择开始游戏 -> 跳转到游戏界面  
- 再仔细在html代码中寻找，最终可能会找到swf源文件所在的地址
- 有一些地址在html代码的 ``src`` 中直接给出，有一些则是给出的相对路径
- 那么我们抛弃掉一些吧，反正游戏非常多，忽略掉一些也无所谓

## 2. 动手吧

直接贴出代码，没什么过多的解释，算是一个crawler的小练习。

{% highlight python %}
#coding=utf-8
#爬取4399所有好玩的游戏
import re
import os
import requests

# 基础url
host_url = 'http://www.4399.com'
swfbase_url = 'http://szhong.4399.com/4399swf'	
hw_url = 'http://www.4399.com/flash/gamehw.htm'

if not os.path.exists('./swf'):
	os.mkdir(r'./swf')

# 需要的正则表达式
tmp_pat = re.compile(r'<ul class="tm_list">(.*?)</ul>',re.S)
game_pat = re.compile( r'<li><a href="(/flash.*?)"><img alt=.*?src=".*?"><b>(.*?)</b>.*?</li>', re.S )
swf_pat = re.compile(r'_strGamePath="(.*?swf)"',re.S)

game_html = requests.get(hw_url)
game_html.encoding = 'gb2312'

tt = tmp_pat.search(game_html.text,re.S).group(1)

game_list = game_pat.findall(tt)

for l in game_list:
	# print l[0], l[1]
	
	game_page = requests.get(host_url + l[0]).text
	src_url = swf_pat.search(game_page)
	if src_url == None:
		continue;
	src = requests.get( swfbase_url + src_url.group(1) ).content
	print "正在保存游戏:" , l[1] 
	open( "./swf/"+ l[1] + ".swf", "wb" ).write( src )



{% endhighlight %}


## 效果如下：  

![XXX][2]

![SSS][3]



  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/222tt.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/22222d.jpg
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/222wuwu.jpg