---
layout: post
title: 听说你叫爬虫(2) —— 爬一下ZOL壁纸 
categories: [python]
tags: [爬虫]
---

我喜欢去ZOL找一些动漫壁纸当作桌面，而一张一张保存显然是太慢了。  
那怎么办呢，我们尝试使用简单的爬虫来解决这个问题。  

## 0. 本爬虫目标

1. 抓取给定分类「或子分类」网址的内容
2. 分析并得到每个分类下的所有图片专辑
3. 下载每一个专辑中的图片「每一个专辑对应一个文件夹」

## 1. 必要的分析

- 我们打开浏览器，输入``http://desk.zol.com.cn/``，跳转到ZOL壁纸的首页。  
- 右键 -> 查看源代码   
    - 大致浏览一下都有什么东西  
    - 我们可以了解到，需要下载一张图片，我们需要选择一个专题  
- 进入专题后，我们通过点击某张图片，可以看到图片的预览
    - 当然这只是预览  
    - 我们可以通过点击相应的分辨率，跳转到图片所在的真正页面
- 进入图片所在页面后，再查看源代码   
    - 我们可以找到图片在服务器上的准确位置，这就是我们想要找的地址

## 2. 简要的思路

- 我们可以写一个程序，直接从某个专题开始，然后通过寻找该专题中的图片，进行下载。  
- 我这里实现的，是给定一个分类或者子分类，然后下载该分类下的所有图片  
    - 比如我可以下载[动漫][1]分类下的所有图片  
    - 或者我也可以下载动漫分类下的[初音未来][2]子分类下的所有图片
- 那么，我们应该是这样做：  
    1. 扒下[初音未来][3]子分类的页面内容  
    2. 在页面的内容中找到当前页所有专辑对应的``URL``，并将``URL``储存起来  
    3. 对每一个专辑进行操作 ``for url in URL`` ：    
        - 确定专辑中图片数量  
        - 进入每一个图片所在的页面：  
            - 确定要下载的图片的分辨率「这里我直接默认找最大分辨率」  
            - 下载该图片   
    4. 判断是否有下一页，有的话继续执行3  
    
    
## 3. 先上code为敬

{% highlight python  %}
# *-* coding: UTF-8 *-*
__author__ = 'BG'
import urllib2
import os
import re

class ZOLPIC:

	# 初始化ZOLPIC类
	# 默认的base地址为ZOL壁纸首页
	# 通过手动读入想要下载的图片分类地址
	# 创建文件夹
	def __init__(self):
		self.base_html = "http://desk.zol.com.cn"
		print "请输入想要下载的图片分类的网址："
		self.cla_html = raw_input()
		if not os.path.exists('./PIC'):
			os.mkdir(r'./PIC')

	# 获取某个页面的内容
	def getHtml(self,url):	
		try:
			html = urllib2.urlopen(url)
			html = html.read().decode('gbk').encode('utf-8') 	
			return html
		except:
			return None

	# 下载图片
	# 通过正则表达式对图片地址进行匹配
	# 创建文件并写入数据
	def downloadPic(self,url,ml):
		src_html = re.search(r'<img src="(.*?)">',url).group(1)
		pic_name = re.search(r'http.*/(.*[jpg|png])',src_html).group(1)
		file_name = r'./PIC/'+ ml + r'/' + pic_name
		if os.path.exists(file_name):							#已经抓取过
			print '图片已经存在 %s' % pic_name
			return
		picsrc = urllib2.urlopen(src_html).read()
		# print picsrc
		print '正在下载图片 %s' % pic_name
		open( file_name,"wb").write(picsrc)

	def startCrawler(self):
		html = self.getHtml(self.cla_html)
		while True:
			page = re.search(r'<ul class="pic-list2  clearfix">(.*)</ins></li>		</ul>',html,re.DOTALL).group(1)
			pic = re.findall(r'href="(/bizhi/.*?html)"',page,re.DOTALL)
			for p in pic:
				cur_page = self.getHtml(self.base_html+p)
				picTotal = int(re.search(r'picTotal 		: ([0-9]+)',cur_page).group(1))
				ml_name = re.search(r'nowGroupName 	: "(.*?)"',cur_page).group(1)
				print '\n\n当前组图名: %s , 共有 %d 张 '%(ml_name,picTotal)
				print '-------------------------------------------'
				if not os.path.exists(r'./PIC/'+str(ml_name)):
					os.mkdir(r'./PIC/'+str(ml_name))
				while picTotal > 0 :
					ori_screen	=  re.search(r'oriScreen.*: "(.*?)"',cur_page).group(1)
					# print ori_screen
					if  ori_screen:
						full_pic = re.search(r'href="(/showpic/%s.*?.html)'%ori_screen,cur_page).group(1)
						# print full_pic
						next_page = cur_page
						cur_page = self.getHtml(self.base_html+full_pic)
						# print cur_page
						self.downloadPic(cur_page,ml_name)
						cur_page = self.base_html + re.search(r'nextPic.*: "(/bizhi/.*?html)"',next_page).group(1)
						cur_page = self.getHtml(cur_page)
					picTotal = picTotal - 1
					print '-------------------------------------------'
			nextPage = re.search(r'<a id="pageNext" href="(.*)" class="next".*?>',html)
			if nextPage == None:
				return
			html = self.getHtml(self.base_html + nextPage.group(1)) 

if __name__ == '__main__':
	spider = ZOLPIC()
	spider.startCrawler()

	
{% endhighlight  %}

基本的解释已经放在了代码里

- 通过``urlopen()``来获取页面    
- 通过``open()`` ``write()``进行写入    
- 通过[正则表达式][4]来进行匹配和筛选信息
- 通过``os.path.exists('./PIC')``来判断某个路径是否存在，不存在则调用``os.mkdir()``进行创建    

最后就是``startCrawler()``这个函数，他将我们上面的思路代码化    
利用了正则表达式进行匹配，找到我们所需要的``URL``，再针对``URL``进行具体的操作
			
## 4. 搜刮ZOL吧！

我测试的时候，爬虫总共爬取了``2.3GB``的图片    
效果图如下「推荐在新标签页中打开图片，有惊喜哦」：    

![下载][5]

![爆炸][6]

![海贼王][7]

## 5. 一些说明

- 本爬虫宝宝是单线程的  
- 本宝宝默认下载最大分辨率的图片「因为人家喜欢高清的图片啦」  
- 本宝宝只能在linux系统下运行「原因是我没有处理字符编码问题，在windows下会出现乱码」


  [1]: http://desk.zol.com.cn/dongman/
  [2]: http://desk.zol.com.cn/dongman/chuyinweilai/
  [3]: http://desk.zol.com.cn/dongman/chuyinweilai/
  [4]: http://cuiqingcai.com/977.html
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/zol12.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/hah.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/222hzw.png