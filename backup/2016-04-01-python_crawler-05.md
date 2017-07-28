---
layout: post
title: 听说你叫爬虫(4) —— 手刃「URP教务系统」
categories: [python]
tags: [爬虫]
---


## 0. 本爬虫目标

- 模拟登陆URP教务系统
- 查询 本学期/历年 成绩
- 计算历年成绩的绩点

**下面是一点废「私」话「货」：**  
一般情况，查询成绩大家会通过如下方式：    

```  
登陆信息门户 -> 转到教学空间 -> 选择教务管理 -> 选择综合查询  
```  

最终可以看到你的成绩  
吐槽一下，查询成绩必须使用IE内核的浏览器，在IE11中还需要设置兼容性，非IE内核的浏览器是无法查看成绩的。   

![CR1][1]

好。我们查看一下源代码，或者凭经验可以发现，，这个「成绩」是嵌套在一个frame框架中的。  
啊，，好蛋疼啊。。。。。  
啊，，好蛋疼啊。。。。。  
啊，，好蛋疼啊。。。。。  
是的，，，事实上，，我们可以发现四个页面：  
**本学期成绩：** ``http://bksjw.chd.edu.cn/bxqcjcxAction.do``    
**学年成绩：**``http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=qbinfo&lnxndm``  
**方案成绩：**``http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=fainfo&fajhh=3792``  
**打印成绩：**``http://bksjw.chd.edu.cn/reportFiles/student/cj_zwcjd_all.jsp``  

抛开这些，试着点击一下注销，，我靠，我们从信息门户跳转到了URP教务系统。。
实际上，信息门户的系统只是以框架的形式将URP教务系统的页面嵌套进来，那就不奇怪了！  

![CR2][2]

更神奇的是，，，，，啊，，在没有修改密码的情况下，，  所有人。。。。。是的，是所有人。。。。     
**默认帐号密码都是自己的学号！！！！！  自己的学号，己的学号，的学号~~~~~**      
  
所以，，，我们下面。直接拿URP来开刀，，，，查询成绩以及计算绩点！！   

## 1. 模拟登陆URP教务系统

### 1.1 页面分析

- 打开IE浏览器 -> 按F12打开调试工具 -> 进入URP综合教务系统 的 [主页][3]  

![CR3][4]  

- 输入帐号密码，登陆系统，页面跳转，观察页面的信息
    - IE下看不到表单数据，但是非IE内核却又不能查看成绩，怎么办，，先到非IE内核浏览器下查看表单数据，再回来？其实你可以用其他抓包工具啊，比如 ``httpwatch`` 吖。
    - 另外一个问题需要明白，我们post的URL并非是主页``http://bksjw.chd.edu.cn/``  
而是`http://bksjw.chd.edu.cn/loginAction.do```，这个我们在分析过程中是可以发现的  

![CR4][5]  

- 我们可以看到headers，cookies，postdata等我们需要的数据  

![CR5][6]  

模拟登陆的关键就是这个 ``Form Data``

### 1.2 尝试登陆

{% highlight python %}
#coding=utf-8
import urllib,urllib2,cookielib

# hosturl用于获取cookies, posturl是登陆请求的URL
hosturl = 'http://bksjw.chd.edu.cn/'
posturl = 'http://bksjw.chd.edu.cn/loginAction.do' 

#获取cookies
cj = cookielib.LWPCookieJar()  
cookie_support = urllib2.HTTPCookieProcessor(cj)  
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)  
urllib2.install_opener(opener)  
h = urllib2.urlopen(hosturl)  

# 伪装成浏览器，反“反爬虫”——虽然我们学校的URP好像没有做反爬虫
headers = {'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)',
    'Referer':'http://bksjw.chd.edu.cn/'} 
# 构造POST数据 用户名和密码，，自行修改啊，，别乱来啊。
postData = {
	'dllx':'dldl',
	'zjh':'xxxx',
	'mm':'xxxx' }
postData = urllib.urlencode(postData)
# 构造请求
request = urllib2.Request( posturl, postData, headers ) 
# 登陆
urllib2.urlopen(request)
{% endhighlight  %}


## 2. 查询成绩

好的，我们成功模拟登陆URP系统，接下来。。继续分析吧。。。  
查看源代码。。。发现，，这个URP系统是一个框架套一个框架。简直爆炸。。  
没关系，我们仔细找，最终可以找到类似如下的地址，，是的，这正是我们需要的，其实就是我上面说的那四个。。。。。   

![CR6][7]

我们接着写  

{% highlight python %}
#coding=utf-8
import urllib,urllib2,cookielib

# hosturl用于获取cookies, posturl是登陆请求的URL
hosturl = 'http://bksjw.chd.edu.cn/'
posturl = 'http://bksjw.chd.edu.cn/loginAction.do' 

#获取cookies
cj = cookielib.LWPCookieJar()  
cookie_support = urllib2.HTTPCookieProcessor(cj)  
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)  
urllib2.install_opener(opener)  
h = urllib2.urlopen(hosturl)  

# 伪装成浏览器，反“反爬虫”——虽然我们学校的URP好像没有做反爬虫
headers = {'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)',
    'Referer':'http://bksjw.chd.edu.cn/'} 
# 构造POST数据
postData = {
	'dllx':'dldl',
	'zjh':'201224060201',
	'mm':'XXXXXXXX' }
postData = urllib.urlencode(postData)
# 构造请求
request = urllib2.Request( posturl, postData, headers ) 
# 登陆
urllib2.urlopen(request)

# 用一个方案成绩做测试
testurl = 'http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=fainfo&fajhh=3792'
save = urllib2.urlopen(testurl).read()
open( 'score.html', "w").write(save)
{% endhighlight  %}  

可以看到，程序运行之后，桌面上产生了一个 ``score.html`` 我们查询到了自己的方案成绩，nice！  

![CR7][8]


### 一个应该注意的问题

在linux下html可能会出现乱码，原因是，保存下来的html代码并没有指明编码方式，好蛋疼的代码啊  
我们用如下方法来处理：  

```
testurl = 'http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=fainfo&fajhh=3792'
head = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">' 
save = head + urllib2.urlopen(testurl).read().decode('GBK').encode('UTF-8')
open( 'score.html', "w").write(save)
```


## 3. 计算绩点

还是看源代码，，发现，，，，好垃圾的代码，，好乱的代码。。。。。。无语  
最后可以发现，每门成绩对应的html代码如下：  

![CR8][9]

大框架是一个``<tr>xxxxxxx</tr>``，，开始尝试写正则表达式  
却发现又存在一个问题，，，空格好多，，而且代码好乱  
怎么办。。。强行写了一个很难看的RE表达式：  

```
reg = re.compile(r'<tr class="odd".*?>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td align="center">\s*(\S+)\s*</td>.*?<td.*?</td>.*?<td align="center">.*?<p align="center">(.*?)&nbsp.*?</P>.*?</td>.*?<td.*?</td>.*?</tr>.*?',re.S)
```

使用正则表达式匹配出每门课的学分和分数，相乘之后相加，最后再除以总学分数，就OK了  

$$   
GPA =\frac{\sum credit \times grade }{\sum credit }
$$   

然而，还有一个问题需要解决，，我的天，，，有些成绩给的是等级「优秀、良好之类云云」，而不是分数。    
好吧，我们首先把字符统一转化为``utf-8``，然后再进行判断，转化为浮点型进行计算    
那就有了如下函数：  

```
def calc_gpa(self):

	reg = re.compile(r'<tr class="odd".*?>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td align="center">\s*(\S+)\s*</td>.*?<td.*?</td>.*?<td align="center">.*?<p align="center">(.*?)&nbsp.*?</P>.*?</td>.*?<td.*?</td>.*?</tr>.*?',re.S)
	myItems = reg.findall(self.score_html)
	score = []
	credit = []
	sum = 0.0
	weight = 0.0

	for item in myItems:
		credit.append(item[0])
		score.append(item[1])
	
	for i in range(len(score)):
		try:
			we = float(credit[i])
			add = float(score[i])
			sum += add*we
			weight += we
		except:
			if score[i] == "优秀":	
				sum += 95.0*we
				weight += we
			elif score[i] == "良好":	
				sum += 85.0*we
				weight += we
			elif score[i] == "中等":	
				sum += 75.0*we
				weight += we
			elif score[i] == "及格":	
				sum += 60.0*we
				weight += we
			else:
				weight += we
	if weight == 0 :
		return
	print 'your GPA is ', sum/weight
```

## 4. 最终成果

![CR9][10]  

是的，最后我实现了以四种模式查看成绩，计算GPA两个功能。

## 5. 一点扩展

如果是在windows下，我们还可以 [使用 PyInstaller 把python程序 .py转为 .exe 可执行程序][11]  
我只说一点，，，，切记不要放在中文目录，，否则你会死的很难看。。。。

![CR10][12]  

## 6. 源代码

代码有点撮不是很想贴，，你可以在我的 [github][13] 中找到，算了，还是贴出来吧

{% highlight python %}
#!/usr/bin/python  
# -*- coding: utf-8 -*-
__author__ = 'BG'  

import urllib, urllib2  
import cookielib
import re

class URP:

	def __init__(self,username,password):
		self.usr = username
		self.psw = password
		self.hosturl = 'http://bksjw.chd.edu.cn/'
		self.posturl = 'http://bksjw.chd.edu.cn/loginAction.do' 

		cj = cookielib.LWPCookieJar()  
		cookie_support = urllib2.HTTPCookieProcessor(cj)  
		opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)  
		urllib2.install_opener(opener)  
		h = urllib2.urlopen(self.hosturl)  

		self.headers = {'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)',
	        'Referer':'http://bksjw.chd.edu.cn/'} 
		self.postData = {'dllx':'dldl','zjh':self.usr,'mm':self.psw }
		self.postData = urllib.urlencode(self.postData)
		self.request = urllib2.Request( self.posturl, self.postData, self.headers )  

	def login(self):
		flag = False
		try:
			urllib2.urlopen(self.request)
			urllib2.urlopen('http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=qbinfo&lnxndm').read()
		except urllib2.HTTPError, e:
			print '-----------------------------------------------------------'
			print 'Login Failed [%s], maybe your username or password is error!'  %e.code
			print '-----------------------------------------------------------'
		else:
			print '-----------------------------------------------------------'
			print 'Login Successful'
			print '-----------------------------------------------------------'
			flag = True
		return flag
			
	def BXQ_score(self):
	  	self.score_html = urllib2.urlopen('http://bksjw.chd.edu.cn/bxqcjcxAction.do').read()

	def NJ_score(self):
	  	self.score_html = urllib2.urlopen('http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=qbinfo&lnxndm').read()

	def TAB_score(self):
	  	self.score_html = urllib2.urlopen('http://bksjw.chd.edu.cn/reportFiles/student/cj_zwcjd_all.jsp').read()

	def FA_score(self):
	  	self.score_html = urllib2.urlopen('http://bksjw.chd.edu.cn/gradeLnAllAction.do?type=ln&oper=fainfo&fajhh=3792').read()
	
	def calc_gpa(self):
		reg = re.compile(r'<tr class="odd".*?>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td align="center">\s*(\S+)\s*</td>.*?<td.*?</td>.*?<td align="center">.*?<p align="center">(.*?)&nbsp.*?</P>.*?</td>.*?<td.*?</td>.*?</tr>.*?',re.S)
		myItems = reg.findall(self.score_html)

		score = []
		credit = []
		sum = 0.0
		weight = 0.0

		for item in myItems:
			credit.append(item[0])
			score.append(item[1])
		
		for i in range(len(score)):
			try:
				we = float(credit[i])
				add = float(score[i])
				sum += add*we
				weight += we
			except:
				if score[i] == "优秀":	
					sum += 95.0*we
					weight += we
				elif score[i] == "良好":	
					sum += 85.0*we
					weight += we
				elif score[i] == "中等":	
					sum += 75.0*we
					weight += we
				elif score[i] == "及格":	
					sum += 60.0*we
					weight += we
				else:
					weight += we
		if weight == 0 :
			return
		print 'your GPA is ', sum/weight


	def save_html(self):

		fout=open("score.html","w")  
		head = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">' 
		self.score_html = head + self.score_html.decode('GBK').encode('UTF-8')
		fout.write(self.score_html)  
		print '-----------------------------------------------------------'
		print 'The result was saved in score.html\nGod bless you!!!!!!'


def query_score():
	print 'Please input your username:'
	usr = raw_input()
	print 'Please input your password:'
	psw = raw_input()

	urp = URP(usr,psw)
	if urp.login() == True:
		print 'Please choose an mode:'
		print '1 - your score of each subject in this term'
		print '2 - all of your score in each term'
		print '3 - all of your score in a table'
		print '4 - all of your score by plan'

		choose = raw_input()
		if choose == '1':
			urp.BXQ_score()
		elif choose == '2':
			urp.NJ_score()
		elif choose == '3':
			urp.TAB_score()
		else:
			urp.FA_score()

		urp.save_html()
		urp.calc_gpa()
	else:
		return

if __name__ == '__main__':
	query_score()
	raw_input ('Press Enter to exit!')


{% endhighlight %}

## 7. TODO

我又更新了一个 [版本][14] ，可以获取自己的证件照。。其实就是入学时候的身份证照片。丑到爆。。  
本来想把全年级同学的照片都爬下来，后来想想不是很道德。还是算了吧。


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/CR1.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/CR2.png
  [3]: http://bksjw.chd.edu.cn/
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/CR3.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/CR4.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/CR5.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/CR6.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/CR7.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/CR8.jpg
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/CR9.png
  [11]: http://blog.csdn.net/daniel_ustc/article/details/15501385
  [12]: http://7xi3e9.com1.z0.glb.clouddn.com/CR10.jpg
  [13]: https://github.com/BIGBALLON/crawler_demo
  [14]: https://github.com/BIGBALLON/crawler_demo/blob/master/Qscore_v1/Qscore_v2.py