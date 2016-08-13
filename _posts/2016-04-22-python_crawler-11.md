---
layout: post
title: 听说你叫爬虫(10) —— 专利检索DEMO
categories: [python]
tags: [爬虫]
---


这是一个稍微复杂的demo，它的功能如下：

1. 输入专利号，下载对应的专利文档
2. 输入关键词，下载所有相关的专利文档

---

## 0. 模块准备

- 首先是requests，这个就不说了，爬虫利器
- 其次是安装[tesseract-ocr][1]，pytesseract 和 [PIL][2] 「用于识别验证码」 

## 1. 模拟登陆

我们需要对 这个网站 [专利检索及分析][3] 进行分析，反复鼓捣之后发现，找不到下载链接？  
tell my why? 原来是没有登陆。 果然，登陆之后能够找到下载按钮，并手动下载成功。  

![验证码][4]

注意到，在登陆和下载的同时，还需要输入验证码。  

> 这样，我们第一步要解决的问题，便是验证码识别与模拟登陆

- [python验证码识别][5]
- [python利用pytesser模块实现图片文字识别][6]

- ubuntu下使用：

```
apt-get install tesseract-ocr  
pip install pytesseract
pip install PIL
```

## 2. 关键字检索请求

登陆之后，我们键入一个关键词，进行检索

![js][7]

![js2][8]

浏览器会向上图所示的url发送post请求，``form data``中的``searchExp``是我们的关键词

> 那么，我们通过post请求，便可以得到检索结果了

## 3. 翻页

![fy][9]

把鼠标放在下一页上，我们能看到，是调用js来实现页面跳转的。

![fy2][10]

进一步分析，实际上我们对上图的url进行post请求也能实现翻页。
注意到``form data``中的参数  

```
"resultPagination.limit":"10",
"resultPagination.sumLimit":"10",
"resultPagination.start":cnt, #这次参数决定了当前页面从搜索到的第几个数据开始
"resultPagination.totalCount":total, #总的搜索数据数目
"searchCondition.searchType":"Sino_foreign",
"searchCondition.dbId":"",
"searchCondition.extendInfo['MODE']":"MODE_GENERAL",
"searchCondition.searchExp":keywords, #我们输入的关键词
"wee.bizlog.modulelevel":"0200101",
"searchCondition.executableSearchExp":executableSearchExp, #需要我们自己构造
"searchCondition.literatureSF":literatureSF, #需要我们自己构造
"searchCondition.strategy":"",
"searchCondition.searchKeywords":"",
"searchCondition.searchKeywords":keywords # 我们输入的关键词
```

> 所以我们需要翻页的时候向 ``showSearchResult-startWa.shtml`` 这个页面进行post请求即可，  
注意每次更新``resultPagination.start``参数  

## 4. 浏览文档

需要下载专利文献，我们需要跳转到另外一个页面，而这个页面，又是通过js跳转的。

![xz][11]

> 注意这里跳转的同时，传入的参数即为专利号，我们把它们保存下了，后面的post请求需要用到

![xz2][12]

可以看到，通过js跳转到了一个新窗口``showViewList``   
这里的``viewQC.viewLiteraQCList[0].searchCondition.executableSearchExp:``非常关键，  
这正是之前将它们保存下来的原因。

```
'viewQC.viewLiteraQCList[0].srcCnName':cnName,
'viewQC.viewLiteraQCList[0].srcEnName':srcEnName,
'viewQC.viewLiteraQCList[0].searchStrategy':'',
'viewQC.viewLiteraQCList[0].searchCondition.executableSearchExp':condition,
'viewQC.viewLiteraQCList[0].searchCondition.sortFields':'-APD,+PD',
'viewQC.needSearch':'true',
'viewQC.type':'SEARCH',
'wee.bizlog.modulelevel':'0200604'
```

## 5. 下载文档

![xz21][13]

点击下载按钮，弹出一个新的界面，Nextwork中产生三个请求
第三个便是验证码对应的图片

![xz22][14]

![xz222][15]

> 手动输入验证码后，首先通过``validateMask.shtml``进行验证码校验，并返回一个加密过后的mask串  
再向``downloadLitera.do``发送post请求，完成下载！其中的参数，需要在之前自行确定。

## 6. 初步代码

很多细节问题需要考虑，这份代码只能算初步代码：  
{% highlight python %}
#coding=utf-8
import requests, re
import Image
from pytesseract import *


def get_verification_code(url):
	src = s.get(url).content
	open('temp_pic',"wb").write(src)
	pic=Image.open(r'./temp_pic')
	return image_to_string(pic)

login_url = 'http://www.pss-system.gov.cn/sipopublicsearch/wee/platform/wee_security_check'
host_url = 'http://www.pss-system.gov.cn/sipopublicsearch/portal/index.shtml'
pic_url = 'http://www.pss-system.gov.cn/sipopublicsearch/portal/login-showPic.shtml'
pic_mask = 'http://www.pss-system.gov.cn/sipopublicsearch/search/validateCode-showPic.shtml?params=2595D550022F3AC2E5D76ED4CAFD4D8E'
search_url = 'http://www.pss-system.gov.cn/sipopublicsearch/search/smartSearch-executeSmartSearch.shtml'
show_page = 'http://www.pss-system.gov.cn/sipopublicsearch/search/showSearchResult-startWa.shtml'
show_list = 'http://www.pss-system.gov.cn/sipopublicsearch/search/search/showViewList.shtml'
mask_check_url = 'http://www.pss-system.gov.cn/sipopublicsearch/search/validateMask.shtml'
download_url = 'http://www.pss-system.gov.cn/sipopublicsearch/search/downloadLitera.do'

down_head = {
	'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	'Accept-Encoding':'gzip, deflate',
	'Accept-Language':'en-US,en;q=0.8',
	'Cache-Control':'max-age=0',
	'Connection':'keep-alive',
	'Content-Type':'application/x-www-form-urlencoded',
	'Origin':'http://www.pss-system.gov.cn',
	'Referer':'http://www.pss-system.gov.cn/sipopublicsearch/search/search/showViewList.shtml',
	'Upgrade-Insecure-Requests':'1',
	'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36'
}


s = requests.session()
cookies = dict(cookies_are='working')
s.get(host_url)

vcode = get_verification_code(pic_url)
login_data = {
	'j_validation_code':vcode,
	'j_loginsuccess_url':'http://www.pss-system.gov.cn/sipopublicsearch/portal/index.shtml',
	'j_username':'emhhbmdzYW4xMjM=',
	'j_password':'emhhbmdzYW4xMjM='
}

s.post(login_url,data=login_data,cookies=cookies)
print "login!!\n-------------------"

keywords = raw_input("please input keywords: ")
cnt = 0

search_data = {
	'searchCondition.searchExp':keywords,
	'searchCondition.dbId':'VDB',
	'searchCondition.searchType':'Sino_foreign',
	'wee.bizlog.modulelevel':'0200101'
}


result = s.post(search_url,data=search_data,cookies=cookies).content
total = int(re.search(r'&nbsp;共.*?页&nbsp;(.*?)条数据',result,re.S).group(1))
print "total:",total
all_result = re.findall('javascript:viewLitera_search\(\'.*?\',\'(.*?)\',\'single\'\)',result,re.S)

executableSearchExp = "VDB:(TBI=" + "'" + keywords + "')"
literatureSF = "复合文本=(" + keywords + ")"

while cnt <= total:
	cnt += 10
	for cur in all_result:
		real_id = cur
		if 'CN' in cur :
			real_id = cur[:14] + '.' + cur[14:]

		condition = r"VDB:(ID='" + real_id + r"')"
		cnName = '检索式:复合文本=' + '(' + keywords + ')'
		srcEnName = 'SearchStatement:复合文本=' + '(' + keywords + ')'


		print real_id

		data_cur = {
			'viewQC.viewLiteraQCList[0].srcCnName':cnName,
			'viewQC.viewLiteraQCList[0].srcEnName':srcEnName,
			'viewQC.viewLiteraQCList[0].searchStrategy':'',
			'viewQC.viewLiteraQCList[0].searchCondition.executableSearchExp':condition,
			'viewQC.viewLiteraQCList[0].searchCondition.sortFields':'-APD,+PD',
			'viewQC.needSearch':'true',
			'viewQC.type':'SEARCH',
			'wee.bizlog.modulelevel':'0200604'
		}


		show = s.post(show_list,data = data_cur,cookies=cookies).content

		tmp = re.search('literaList\[0\] = \{(.*?)\};',show,re.S)
		if tmp == None:
			break;

		idlist = re.findall('"(.*?)"',tmp.group(1).replace(' ',''),re.S)

		# 解析验证码
		vcode = get_verification_code(pic_mask)
		print vcode

		# 获取加密后的mask
		mask_data = {
			'':'',
			'wee.bizlog.modulelevel':'02016',
			'mask':vcode
		}
		kao = s.post(mask_check_url,data=mask_data,cookies=cookies).content
		#{"downloadCount":2,"downloadItems":null,"mask":"1a75026a-5138-4460-a35e-5ef60258d1d0","pass":true,"sid":null}
		mask_jm = re.search(r'"mask":"(.*?)"',kao,re.S).group(1)
		#print mask_jm

		data_down = {
			'wee.bizlog.modulelevel':'02016',
			'checkItems':'abstractCheck',
			'__checkbox_checkItems':'abstractCheck',
			'checkItems':'TIVIEW',
			'checkItems':'APO',
			'checkItems':'APD',
			'checkItems':'PN',
			'checkItems':'PD',
			'checkItems':'ICST',
			'checkItems':'PAVIEW',
			'checkItems':'INVIEW',
			'checkItems':'PR',
			'checkItems':'ABVIEW',
			'checkItems':'ABSIMG',
			'idList[0].id':idlist[0],
			'idList[0].pn':idlist[3],
			'idList[0].an':idlist[2],
			'idList[0].lang':idlist[4],
			'checkItems':'fullTextCheck',
			'__checkbox_checkItems':'fullTextCheck',
			'checkItems':'fullImageCheck',
			'__checkbox_checkItems':'fullImageCheck',
			'mask':mask_jm
		}


		down_page = s.post(download_url,data=data_down,headers=down_head,cookies=cookies).content

		open( cur + ".zip" ,"wb").write(down_page)

	kao_data = {
		"resultPagination.limit":"10",
		"resultPagination.sumLimit":"10",
		"resultPagination.start":cnt,
		"resultPagination.totalCount":total,
		"searchCondition.searchType":"Sino_foreign",
		"searchCondition.dbId":"",
		"searchCondition.extendInfo['MODE']":"MODE_GENERAL",
		"searchCondition.searchExp":keywords,
		"wee.bizlog.modulelevel":"0200101",
		"searchCondition.executableSearchExp":executableSearchExp,
		"searchCondition.literatureSF":literatureSF,
		"searchCondition.strategy":"",
		"searchCondition.searchKeywords":"",
		"searchCondition.searchKeywords":keywords
	}
	result = s.post(show_page,data=kao_data,cookies=cookies).content
	print "next page"
	all_result = re.findall('javascript:viewLitera_search\(\'.*?\',\'(.*?)\',\'single\'\)',result,re.S)
{% endhighlight%}

## 7. 效果展示

![xx1][16]

## 8. TODO

可能会继续更新 [code][17]


  [1]: https://github.com/tesseract-ocr
  [2]: http://www.pythonware.com/products/pil/
  [3]: http://www.pss-system.gov.cn/sipopublicsearch/search/searchHome-searchIndex.shtml
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/2016-04-22_133143.png
  [5]: http://www.waitalone.cn/python-php-ocr.html?utm_source=tuicool&utm_medium=referral
  [6]: http://www.jinglingshu.org/?p=9281
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_133526.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_133726.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_133840.png
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_134027.png
  [11]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_134226.png
  [12]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_134411.png
  [13]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_135128.png
  [14]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_135241.png
  [15]: http://7xi3e9.com1.z0.glb.clouddn.com/zlcx2016-04-22_141702.png
  [16]: http://7xi3e9.com1.z0.glb.clouddn.com/xx1.png
  [17]: https://github.com/BIGBALLON/crawler_demo/blob/master/zl_search/zlcx.py
