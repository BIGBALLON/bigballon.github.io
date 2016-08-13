---
layout: post
title: 听说你叫爬虫(7) —— 爬取你的AC代码
categories: [python]
tags: [爬虫]
---

上一篇文章中，我们介绍了python爬虫利器——requests，并且拿HDU做了小测试。  
这篇文章，我们来爬取一下自己AC的代码。

## 1 确定ac代码对应的页面

如下图所示，我们一般情况可以通过该顺序找到我们曾经AC过的代码

```
登陆hdu -> 点击自己的信息 -> 点击Last accepted submissions -> 在Code Len 处选择一个代码 -> 看到你AC的代码
```

![hdu-accode][1]

我们可以看到，所有AC代码的页面都是  
``http://acm.hdu.edu.cn/viewcode.php?rid=`` + ``RunID``

而这个``RunID``，正好在表格的最前面：  

![runid][2]

很自然我们可以想到，用正则表达式进行匹配。

## 2. 处理换页问题

很显然，，如果你AC的代码多了，必然会存在换页问题  
不过我们可以在源代码中找到换页对应的URL，我们直接跳转，直到找不到为止。

![hy][3]

## 3. 代码处理问题

html中有一些转义字符，使得我们不能直接将代码保存下来。  

![parser][4]

这时候我们需要用到 ``HTMLParser``

```
code = html_parser.unescape(down_code)
```

## 4. 具体实现

{% highlight python %}
#coding=utf-8
import re, HTMLParser, requests, getpass, os

# 初始化会话对象 以及 cookies
s = requests.session()
cookies = dict(cookies_are='working')

# 一些基础的url
host_url = 'http://acm.hdu.edu.cn'
post_url = 'http://acm.hdu.edu.cn/userloginex.php?action=login'
status_url = 'http://acm.hdu.edu.cn/status.php?user='
codebase_url = 'http://acm.hdu.edu.cn/viewcode.php?rid='

# 正则表达式的匹配串
runid_pat = re.compile(r'<tr.*?align=center ><td height=22px>(.*?)</td>.*?</tr>',re.S)
code_pat = re.compile(r'<textarea id=usercode style="display:none;text-align:left;">(.+?)</textarea>',re.S)
lan_pat = re.compile(r'Language : (.*?)&nbsp;&nbsp',re.S)
problem_pat = re.compile(r'Problem : <a href=.*?target=_blank>(.*?) .*?</a>',re.S)
nextpage_pat = re.compile(r'Prev Page</a><a style="margin-right:20px" href="(.*?)">Next Page ></a>',re.S)

# 代码保存目录
if not os.path.exists('./ac_code'):
	os.mkdir(r'./ac_code')
base_path = r'./ac_code/'

# 登陆
def login(usr,psw):
	data = {'username':usr,'userpass':psw,'login':'Sign In'}	
	r = s.post(post_url,data=data,cookies=cookies)

# 代码语言判断	
def lan_judge(language):
	if language == 'G++':
		suffix = '.cpp'
	elif language == 'GCC':
		suffix = '.c'
	elif language == 'C++':
		suffix = '.cpp'
	elif language == 'C':
		suffix = '.c'
	elif language == 'Pascal':
		suffix = '.pas'
	elif language == 'Java':
		suffix = '.java'
	else:
		suffix = '.cpp'
	return suffix



if __name__ == '__main__':
	
	usr = raw_input('input your username:')
	psw = getpass.getpass('input your password:')
	
	login(usr,psw)
	
	# 用于处理html中的转义字符
	html_parser = HTMLParser.HTMLParser()

	# 遍历每一页，并下载其代码
	status_url = status_url  + usr + '&status=5'
	status_html = s.get(status_url,cookies=cookies).text
	flag = True
	print "Just go!"
	while( flag ):
		runid_list = runid_pat.findall(status_html)

		for id in runid_list:
			code_url = codebase_url + id
			down_html = s.get(code_url,cookies=cookies).text

			down_code = code_pat.search(down_html).group(1)
			language = lan_pat.search(down_html).group(1)
			problemid = problem_pat.search(down_html).group(1)

			suffix = lan_judge(language)
			code = html_parser.unescape(down_code).encode('utf-8')
			code = code.replace('\r\n','\n')
			open( base_path + 'hdu' + problemid + '__' + id + suffix,"wb").write(code)
		
		nexturl = nextpage_pat.search(status_html)
		if nexturl == None:
			flag = False
		else:
			status_url = host_url + nexturl.group(1)
			status_html = s.get(status_url,cookies=cookies).text
	print "all of your ac codes were saved!"




{% endhighlight %}

## 5. 效果截图

- ubuntu下测试：  

![xg][5]

- windows下测试：  

![xg2][6]


## 6. 写在后面

额。。很久很久很久没有刷题了。。。233333333，其实我是想告诉你一个事实   
这里就可以下载AC的代码，，，哈哈哈。so，这个爬虫仅仅用来练习就好。  


![哈哈哈][7]


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/222hah.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/222s753.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/222sds406174240.png
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/222ss1p.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/222WTW.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/222demo3.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/222xg3.png