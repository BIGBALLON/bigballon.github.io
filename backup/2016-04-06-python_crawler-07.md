---
layout: post
title: 听说你叫爬虫(6) —— 神器 Requests
categories: [python]
tags: [爬虫]
---


> Requests 是使用 Apache2 Licensed 许可证的 HTTP 库。用 Python 编写，真正的为人类着想。  
Python 标准库中的 urllib2 模块提供了你所需要的大多数 HTTP 功能，但是它的 API 太渣了。它是为另一个时代、另一个互联网所创建的。它需要巨量的工作，甚至包括各种方法覆盖，来完成最简单的任务。

所以我们来看下Requests库吧！  

## 0. 安装Requests

### 0.1 Distribute & Pip ¶

使用 pip 安装Requests非常简单

```
 pip install requests
```

### 0.2 获得源码 ¶

下载源码：  

```
curl -OL https://github.com/kennethreitz/requests/zipball/master
```

解压并切换到该目录下，进行安装：  

```
python setup.py install
```

## 1 使用Requests

### 1.1 抓取某个页面

使用urllib2抓取一个页面，我们是这样的：  

```
import urllib2
test = urllib2.urlopen('http://bigballon.github.io/').read()
print test
```

而使用requests，我们有如下代码：  

```
import requests
r = requests.get('http://bigballon.github.io/')
print r.text
```

### 1.2 增加headers

某些页面可能需要我们的爬虫伪装成浏览器才可以访问。还是拿[hdu][1]来举例，我们有如下代码：  

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

而直接使用requests呢，我们还是只需要这样写：  

```
import requests
r = requests.get("http://acm.hdu.edu.cn/")
print r.text
```

### 1.3 需要登陆的情况

要登陆到HDU，我们可能要写一大串代码：  

```
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
    'userpass':'xxxxx',
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
```

但是我们使用requests呢：  

```
import requests
data = {'username':'China_Lee','userpass':'XXXXX','login':'Sign In'}
cookies = dict(cookies_are='working')
url = 'http://acm.hdu.edu.cn/userloginex.php?action=login'
r = requests.post(url,data=data,cookies=cookies)
```

## 2. 实例对比

我们曾经写过一个获取指定 ``runid`` 下的AC代码的小 ``DEMO``：    

{% highlight python %}
#coding=utf-8
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
    'userpass':'xxxxx',
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
down_code = pattern.findall(down_html)[0]
# 使用unescape处理html中的转义字符
code = html_parser.unescape(down_code)
# 使用replace处理\r\n,windows下和linux下并不相同
code = code.replace('\r\n','\n')
# 将代码存储为test.cpp
open('test.cpp',"w").write(code)
{% endhighlight %}

现在我们用requests来改写：  

{% highlight python %}
#coding=utf-8
import re, HTMLParser, requests
s = requests.session()
html_parser = HTMLParser.HTMLParser()

cookies = dict(cookies_are='working')
post_url = 'http://acm.hdu.edu.cn/userloginex.php?action=login'
data = {'username':'China_Lee','userpass':'XXXXX','login':'Sign In'}
# 登陆
r = s.post(post_url,data=data,cookies=cookies)

code_url = 'http://acm.hdu.edu.cn/viewcode.php?rid=14880688'
down_html = s.get(code_url,cookies=cookies).text

pattern = re.compile('<textarea id=usercode style="display:none;text-align:left;">(.+?)</textarea>',re.S)
down_code = pattern.findall(down_html)[0]
code = html_parser.unescape(down_code)
code = code.replace('\r\n','\n')
open('test.cpp',"w").write(code)
{% endhighlight %}

是的，就是这样的，requests是相当好用的。

### 3. TODO

更多用法请参考：

1. [Python爬虫利器一之Requests库的用法][2]
2. [官方文档——快速上手][3]


  [1]: http://bigballon.github.io/python/2016/04/01/python_crawler-04.html
  [2]: http://cuiqingcai.com/2556.html
  [3]: http://cn.python-requests.org/zh_CN/latest/user/quickstart.html