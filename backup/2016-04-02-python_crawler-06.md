---
layout: post
title: 听说你叫爬虫(5) —— 扒一下codeforces题面
categories: [python]
tags: [爬虫]
---

上一次我们拿学校的URP做了个小小的demo。。。。   
其实我们还可以把每个学生的证件照爬下来做成一个证件照校花校草评比  
另外也可以写一个物理实验自动选课。。。
但是出于多种原因，，还是绕开这些敏感话题。。
今天，我们来扒一下cf的题面！ PS:本代码不是我原创


## 1. 必要的分析

### 1.1 页面的获取

一般情况CF的每一个 contest 是这样的：  

![][1]

对应的``URL``是：``http://codeforces.com/contest/xxx``

还有一个``Complete problemset``页面，它是这样的：  

![][2]

对应的``URL``是：``http://codeforces.com/contest/xxx/problems``

可以发现，每一个contest除了xxx不一样外，其他都一样。  
这样，我们就可以通过修改xxx的内容，来决定爬取哪一场比赛的题面了。  


### 1.2 src保存问题

要保存整个网站，除了html的文本内容外，还需要将页面中对应的其他资源一起保存下来。  
这里，我们分两步来做  

- 第一步，将html页面的头部以及对应的资源事先保存下来，因为这些头部都是一样的  
- 第二步，每访问一个contest，就下载其中相应的资源文件，并保存到相应的目录。  

### 1.3 一些扩展

保存为html并不是很方便查看，我们可以使用wkhtmltopdf将html转化为pdf。  
脚本如下：  

```
if [ -d ./pdf ]; then
    :
else
    mkdir -p pdf
fi

cd html
for h in *.html;
do
    wkhtmltopdf -q "$h" "../pdf/`echo "$h"|sed "s/\.html/\.pdf/"`"
done
```

我们还可以写一个用于清理的脚本：  

```
rm -f contest/*
rm -f html/*
rm -f problem/*
rm -f src/*
```

那么最后，我们拥有如下文件：  


- ``caches``和``header.html``是我们之间保存的一些共用文件
- ``clear.sh``和``html2pdf.sh``是我们写的脚本
- ``crawl_html.py``是我们的爬虫


![][3]

## 2. 代码

{% highlight python %}
#coding=utf-8

# 导入需要用到的模块
import urllib2
import re
import os
import sys
import threading
import HTMLParser

# 抓取网页内容
def get_html(url):
	t=5
	while t>0:
		try:
			return urllib2.urlopen(url).read()
		except:
			t-=1
	print "open url failed:%s"%url

# 编译正则表达式
def allre(reg):
	return re.compile(reg,re.DOTALL)

# 下载页面资源
def down_src(html,title):
	src=allre(r'src="(.*?)"').findall(html)
	id = 1
	for s in src:
		nsrc='src/'+title + str(id)
		nsrc = nsrc.replace('#','').replace('.','').replace(' ','')
		nsrc = nsrc + '.png'
		open(workdir+nsrc,"w").write(get_html(s))
		html=html.replace(s,'../'+nsrc)
	return html

# 获取contest内容
def get_contest(c):
	html=get_html("http://codeforces.com/contest/%d/problems"%c)
	p=allre('class="caption">(.*?)</div>').findall(html)
	if len(p)==0:
		return None
	title=HTMLParser.HTMLParser().unescape(p[0]) # 获取标题

	html_path = workdir + 'html/[%d]%s.html'%(c,title.replace('/','_'))
	flag = False
	if os.path.exists(html_path):
		flag = True
	else:
		html=allre('(<div style="text-align: center;.*)').findall(html)[0] # 获取比赛页面内容
		html=down_src(html,title) #下载页面所需要的src
	return (c,title,html_path,html,flag)

# 存储contest内容
def save_contest(contest):
	html_path=contest[2]
	html=contest[3]
	open(html_path,'w').write(header+html)

# ---------------------------------------------------------------
# 多线程类
class crawl_contest(threading.Thread):
    def __init__(this):
        threading.Thread.__init__(this)
    def run(this):
    	global begin
    	while begin<=end:
	    	lock.acquire()
	    	curid=begin
	    	begin+=1
	    	lock.release()
	    	contest=get_contest(curid)
	    	lock.acquire()
	    	# 三种情况，1- 没有获取到页面 2 - 页面已经下载过了 3 - 正常爬取页面
	    	if contest==None:
	    		print "cannot crawl contest %d"%curid
	    	elif contest[4]:
	    		print "existed:[%d]%s"%(contest[0],contest[1])
	    	else:
	    		save_contest(contest)
	    		print "crawled:[%d]%s"%(contest[0],contest[1])
	    	lock.release()
# ---------------------------------------------------------------



# ---------------------------------------------------------------
# 从控制台获取参数 python xx.py 200 300 20 xxxx  ----- 5
#                         0      1   2   3  4
# argv[1] -> begin
# argv[2] -> end
# argv[3] -> thread number
# argv[4] -> workdir 默认为当前目录

arglen=len(sys.argv)
if arglen<4 or arglen>5:
	print "Usage:\n\t%s begin end threads [workdir]"%sys.argv[0]
	exit()
if arglen==5:
	workdir=sys.argv[4]
else:
	workdir="./"

begin=int(sys.argv[1])
end=int(sys.argv[2])
threads=int(sys.argv[3])

# 创建src与html目录
for d in ['src','html']:
	d = workdir + d
	if not os.path.exists(d):
		print "makedirs:%s"%d
		os.makedirs(d)
# ---------------------------------------------------------------



# 初始化线程lock
lock = threading.RLock()

#读取html头
header=open("header.html").read()

# 开始工作
print "crawl contest %d to %d\n%d threads used,save in %s"%(begin,end,threads,workdir)
for i in range(threads):
	crawl_contest().start()
{% endhighlight %}


## 3. 实例

我们以下载编号为200-250的contest为例：  

```
python crawl_html.py 200 250 30
```

![][4]

![][5]

其中html保存的即为html页面，src保存的为图片等资源  
我们随意打开一个页面，可以看到，效果不错。

![][6]

我们再使用shell脚本，将html批量生成pdf：   

```
./html2pdf.sh 
```

可以看到，我们成功将html转化为pdf了。  

![][7]


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/cf1.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/cf2.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/cf4.png
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/C5.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/C6.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/C77.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/CRRR.png