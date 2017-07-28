---
layout: post
title: 听说你叫爬虫(11) —— 也写个AC自动机
categories: [python]
tags: [爬虫]
---


## 0. 写在前面

本文记录了一个AC自动机的诞生！

之前看过有人用C++写过AC自动机，也有用C#写的，还有一个用nodejs写的。。  

- [C# 逆袭——自制日刷千题的AC自动机攻克HDU OJ][1]
- [HDU 自动刷题机 Auto AC （轻轻松松进入HDU首页）][2]
- [手把手教你用C++ 写ACM自动刷题神器（冲入HDU首页）][3]


感觉他们的代码过于冗长，而且AC率也不是很理想。  
刚好在回宿舍的路上和学弟聊起这个事   
随意想了想思路，觉得还是蛮简单的，就顺手写了一个，效果，还可以接受。  

先上个图吧：  

![zhenAC][4]

![rank][5]

最后应该还可以继续刷，如果修改代码或者再添加以下其他搜索引擎可以AC更多题，
不过我有意控制在3000这个AC量，也有意跟在五虎上将之后。  

## 1.  爬虫思路

思路其实非常清晰：

1. 模拟登录HDU
2. 针对某一道题目
    - 搜索AC代码
        - 通过正则表达式进行代码的提取
        - 通过htmlparser进行代码的处理
    - 提交
        - 若AC，返回2
        - 否则，继续提交代码（这里最多只提交10份代码）
        - 10次提交后还未AC，放弃此题

## 2. 简单粗暴的代码  

{% highlight python %}
#coding='utf-8'
import requests, re, os, HTMLParser, time, getpass

host_url = 'http://acm.hdu.edu.cn'
post_url = 'http://acm.hdu.edu.cn/userloginex.php?action=login'
sub_url = 'http://acm.hdu.edu.cn/submit.php?action=submit'
csdn_url = 'http://so.csdn.net/so/search/s.do'
head = { 'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' }
html_parser = HTMLParser.HTMLParser()
s = requests.session()

def login(usr,psw):	
	s.get(host_url);
	data = {'username':usr,'userpass':psw,'login':'Sign In'}	
	r = s.post(post_url,data=data)

def check_lan(lan):
	if 'java' in lan:
		return '5'
	return '0'

def parser_code(code):
	return html_parser.unescape(code).encode('utf-8')

def is_ac(pid,usr):
	tmp = requests.get('http://acm.hdu.edu.cn/userstatus.php?user='+usr).text
	accept = re.search('List of solved problems</font></h3>.*?<p align=left><script language=javascript>(.*?)</script><br></p>',tmp,re.S)
	if pid in accept.group(1):
		print '%s was solved' %pid
		return True
	else:
		return False

def search_csdn(PID,usr): 
	get_data = { 'q':'HDU ' + PID,	't':'blog',	'o':'', 's':'',	'l':'null'	}
	search_html = requests.get(csdn_url,params=get_data).text
	linklist = re.findall('<dd class="search-link"><a href="(.*?)" target="_blank">',search_html,re.S)
	for l in linklist:
		print l
		tm_html = requests.get(l,headers=head).text;
		title = re.search('<title>(.*?)</title>',tm_html,re.S).group(1).lower()
		if PID not in title:
			continue
		if 'hdu' not in title:
			continue			
		tmp = re.search('name="code" class="(.*?)">(.*?)</pre>',tm_html,re.S)
		if tmp == None:
			print 'code not find'
			continue
		LAN = check_lan(tmp.group(1))
		CODE =  parser_code(tmp.group(2))
		if r'include' in CODE:
			pass
		elif r'import java' in CODE:
			pass
		else:
			continue
		print PID, LAN
		print '--------------'
		submit_data = { 'check':'0', 'problemid':PID, 'language':LAN, 'usercode':CODE }
		s.post(sub_url,headers=head,data=submit_data)
		time.sleep(5)
		if is_ac(PID,usr):
			break
	 
if __name__ == '__main__':
	usr = raw_input('input your username:')
	psw = getpass.getpass('input your password:')
	login(usr,psw)
	pro_cnt = 1000
	while pro_cnt <= 5679:
		PID = str(pro_cnt)
		if is_ac(PID,usr):
			pro_cnt += 1
			continue
		search_csdn(PID,usr)
		pro_cnt += 1
{% endhighlight %}

代码不长，仅仅只有78行，是的，就是这样！

![yanhsi][6]

## 3. TDDO

目前没有打算完善这篇博客，也不推荐去研究这个东西，推荐的是去学习真正的算法，哈哈！ 


很久很久以前自己写过的AC自动机，，，，贴一发： 

{% highlight c++ %}
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <queue>
using namespace std;
#define clr( a, b ) memset( a, b, sizeof(a) )
const int SIGMA_SIZE = 26;
const int NODE_SIZE = 500000 + 10;

struct ac_automaton{
    int ch[ NODE_SIZE ][ SIGMA_SIZE ];
    int f[ NODE_SIZE ], val[ NODE_SIZE ], last[ NODE_SIZE ];
    int sz;
    void init(){
        sz = 1;
        clr( ch[0], 0 ), clr( val, 0 );
    }
    void insert( char *s ){
        int u = 0, i = 0;
        for( ; s[i]; ++i ){
            int c = s[i] - 'a';
            if( !ch[u][c] ){
                clr( ch[sz], 0 );
                val[sz] = 0;
                ch[u][c] = sz++;
            }
            u = ch[u][c];
        }
        val[u]++;
    }
    void getfail(){
        queue<int> q;
        f[0] = 0;
        for( int c = 0; c < SIGMA_SIZE; ++c ){
            int u = ch[0][c];
            if( u ) f[u] = 0, q.push(u), last[u] = 0;
        }
        while( !q.empty() ){
            int r = q.front(); q.pop();
            for( int c = 0; c < SIGMA_SIZE; ++c ){
                int u = ch[r][c];
                if( !u ){
                    ch[r][c] = ch[ f[r] ][c];
                    continue;    
                } 
                q.push( u );
                int v = f[r];
                while( v && !ch[v][c] ) v = f[v];
                f[u] = ch[v][c];
                last[u] = val[ f[u] ] ? f[u] : last[ f[u] ];
            }
        }
    }
    int work( char* s ){
        int res = 0;
        int u = 0, i = 0, e;
        for( ; s[i]; ++i ){
            int c = s[i] - 'a';
            u = ch[u][c];
            e = u;
            while( val[e] ){
                res += val[e];
                val[e] = 0;
                e = last[e];
            }
        }
        return res;
    } 
}ac;

{% endhighlight %}

  [1]: http://www.cnblogs.com/zjutlitao/p/4337775.html
  [2]: http://m.blog.csdn.net/article/details?id=51242562
  [3]: http://blog.csdn.net/nk_test/article/details/49497017
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/ACpaiming.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/ACrank_meitu_1.jpg
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/ACyanshi.png