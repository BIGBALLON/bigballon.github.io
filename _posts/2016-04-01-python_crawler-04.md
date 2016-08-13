---
layout: post
title: 听说你叫爬虫(3) —— 模拟登陆
categories: [python]
tags: [爬虫]
---

本文从最基本的页面抓取开始介绍，最后用实例来分析如何进行模拟登陆    
以下所有例子均使用  [杭电][1] 主页进行分析

## 1. 基本操作

### 1.1 最基本的抓取

最一般的情况，我们可以通过如下代码来抓取页面：

```
import urllib2
html = urllib2.urlopen('https://www.baidu.com/').read()
```

### 1.2 伪装成浏览器访问

某些网站（比如：[http://acm.hdu.edu.cn/][2]）对爬虫一律拒绝请求，这时候我们需要伪装成浏览器才能进行访问  
我们可以通过修改http包中的header来实现：

```
import urllib2
headers = {
    'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'
}
req = urllib2.Request(
    url = 'http://acm.hdu.edu.cn/',
    data = None,
    headers = headers
)
html = urllib2.urlopen(req).read()
print html
```

### 1.3 需要登陆的情况

许多网站，只有登陆之后才能进行相关的操作，那么就涉及到如何登陆。

#### 1.3.1 cookie的处理

```
import urllib2, cookielib
cookie_support= urllib2.HTTPCookieProcessor(cookielib.CookieJar())
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)
urllib2.install_opener(opener)
content = urllib2.urlopen('http://XXXX').read()
```

#### 1.3.2 表单的处理

一般情况，我们都需要以post方式向服务器传递请求来进行登陆。我们可以用浏览器自带的分析工具进行分析。    
比如``chrome``和``firefox``的``F12`` 我们打开杭电主页，按``F12``打开抓包工具，输入账号密码进行登陆，可以看到如下数据  

![抓包][3]

``headers``就是我们前面介绍到的表头  
``form Data``就是我们登陆使用的数据，这里包括了三个字段``username``,``userpasswd``和``login``。   
下面我们构造一下post所需的数据：   

```
postdata=urllib.urlencode({
	'username':'China_Lee',
	'userpass':'xxxxxxx',
	'login':'Sign In'
})

req_post = urllib2.Request(
	url = 'http://acm.hdu.edu.cn/userloginex.php?action=login',
    data = postdata,
    headers = headers
)
result = urllib2.urlopen(req_post).read()
```

#### 1.3.3 反”反盗链”

某些站点有所谓的反盗链设置，其实说穿了很简单    
就是检查你发送请求的``header``里面，``referer``站点是不是他自己，所以我们只需在``headers``加入``Referer``：

```
headers = {
    'Referer':'Referer:http://acm.hdu.edu.cn/userloginex.php'
}
```

## 2. 实例

### 2.1 目标

- 模拟登陆HDU
- 下载一个自己曾经AC过的题目的代码

### 2.2 代码与分析

{% highlight python %}
#coding=utf-8
'''
urllib——用于表单数据的生成
urllib2——必要的库，不再赘述
cookielib——提供可存储cookie的对象，以便于与urllib2模块配合使用来访问Internet资源
re——用于正则表达式
HTMLParser——用于处理html代码的转义字符
'''
import urllib2, urllib, cookielib
import re, HTMLParser

host_url = 'http://acm.hdu.edu.cn/'
post_url = 'http://acm.hdu.edu.cn/userloginex.php?action=login'

# 伪装成浏览器
headers = {
    'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6',
}
# 生成请求，这里访问hdu的主页，而不是登陆url，这里只是为了获取cookie
# 因为hdu做了反爬虫，所有必须加入headers才能访问
req_host = urllib2.Request(
    url = host_url,
    headers = headers
)
# 获取cookie
cookie_support= urllib2.HTTPCookieProcessor(cookielib.CookieJar())
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)
urllib2.install_opener(opener)
content = urllib2.urlopen(req_host).read()
# 生成post请求所需要的表单数据
# 账号密码换成你自己的
postdata=urllib.urlencode({
  'username':'China_Lee',
  'userpass':'XXXX',
  'login':'Sign In'
})

# 生成post所需的请求
req_post = urllib2.Request(
  url = post_url,
    data = postdata,
    headers = headers
)
# 发送请求，登陆成功
result = urllib2.urlopen(req_post).read()

# 声明一个HTMLParser实例
html_parser = HTMLParser.HTMLParser()

# 制定某一个代码页面
# 注意，这个页面是我自己找到，是我自己的AC代码，如果你使用这个页面，是没有权限的，请换一个你所AC的代码所在的URL
req_code = urllib2.Request(
    url = 'http://acm.hdu.edu.cn/viewcode.php?rid=14880688',
    headers = headers
)
# 读取页面内容
down_html = urllib2.urlopen(req_code).read()

# 分析页面后得到正则表达式
pattern = re.compile('<textarea id=usercode style="display:none;text-align:left;">(.+?)</textarea>',re.S)
# 使用正则表达式匹配code
down_code = pattern.search(down_html)
if down_code == None:
    print "error"

# 使用unescape处理html中的转义字符
else:
    code = html_parser.unescape(down_code.group(1))
    # 使用replace处理\r\n,windows下和linux下并不相同
    code = code.replace('\r\n','\n')
    # 将代码存储为test.cpp
    open('test.cpp',"w").write(code)



{% endhighlight %}

最后我们可以看到，``test.cpp``正是我们AC的代码    


![ac][4]


  [1]: http://acm.hdu.edu.cn/
  [2]: http://acm.hdu.edu.cn/
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/s.png
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/cpp.png