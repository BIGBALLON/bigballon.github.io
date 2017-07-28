---
layout: post
title: Ubuntu 14.04 Virtual Judge 的搭建
categories: [icpc]
tags: [vjudge]
---


> - 由于集训队需要，我们决定架设自己的OnlineJudge和Virtual Judge  
> - OJ的搭建，非常顺利，但是，Vjudge的搭建，我却遇到了相当多的问题.  
> - 无奈，泛滥的大量博文中，信息相当杂，精品相当少  
> 大多数都是转载来转载去，内容相同还没有营养，搭建Vjudge方面的博文更是稀少  
连续两天我都没有能够搭建起来，最后在jcf的帮助下，  
终于解决了各种问题，成功搭建起了Virtual Judge。  
(强烈吐槽一下：在打包war文件的时候有0.2MB的文件掉包了导致我折腾了整整两天)  
但是对于不熟悉Linux和JSP的同学，这篇文章也许太过简单,  
然而，我再也没有找到更好的参考博文或是文档，于是，决定自己花一点时间来完成这个空缺，这篇文章由此诞生。  

---


## 1. 前期准备工作

### 1.1 一个Linux系统 
    因为现场赛的缘故，我一直使用的都是乌邦图。  
    这里我测试用的是ubuntu14.04 Desktop 64bit ,当然选择Server会更好一些.  
    系统的安装不再赘述，作为服务器请选用Server版本。  



### 1.2 更新源

    在搭建环境之前，请确保你的源是有效的，速度是给力的，  
    建议选择一个国内的源14.04 LTS 更新源  
    sudo gedit /etc/apt/sources.list 将原来的源覆盖并保存  
    最后执行 sudo apt-get update  更新源  

### 1.3 必要文件准备 
    我们需要下载这几个文件（部分链接需要翻墙才能访问）：  
    1．*.sql 	 		https://gist.github.com/trcnkq/a3cf7004759d41d79eb7  
    2．http_client.json 		https://gist.github.com/trcnkq/7a5deff639ff99475138  
    3．remote_accounts.json 	https://gist.github.com/trcnkq/e9dac7eea72d2b781949  
    4．virtual judge源文件 	https://github.com/trcnkq/virtual-judge  

> 如果无法翻墙，请用我的备用链接： [Vjudge搭建][1]


---


## 2. 必要环境搭建 

### 2.1 JDK的安装和配置

    首先需要下载JDK，地址：https://jdk7.java.net/download.html  
    注意系统是32位还是64位  

    1.)	解压下载的文件  
    tar -xzvf jdk1.7.0_80  
    
    2.)	移动文件夹到指定目录下  
    sudo mkdir /usr/lib/jvm  
    sudo mv jdk1.7.0_80/ /usr/lib/jvm/  
    
    3.)	设置环境变量
    sudo gedit /etc/profile
    
    在文件最后加入如下内容：
    export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_80
    export JRE_HOME=${JAVA_HOME}/jre
    
    export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
    export PATH=${JAVA_HOME}/bin:$PATH
    
![][2] 


	4.)	使修改生效：  
    sudo source /etc/profile  
    这时候在终端输入 java –version 查看当前 JDK 版本  
    至此，JDK 配置完成  
    
![][3]


### 2.2 Redis的安装和配置 


    1.)    下载安装Redis:  
    wget http://download.redis.io/releases/redis-2.8.9.tar.gz    
    tar xvzf redis-2.8.9.tar.gz    
    cd redis-2.8.9/    
    make  
    sudo make install    

    2.)    配置init脚本：  
    wget https://github.com/ijonas/dotfiles/raw/master/etc/init.d/redis-server  
    wget https://github.com/ijonas/dotfiles/raw/master/etc/redis.conf  
    sudo mv redis-server /etc/init.d/redis-server  
    sudo chmod +x /etc/init.d/redis-server  
    sudo mv redis.conf /etc/redis.conf   


    3.)    初始化用户和日志路径  
    第一次启动Redis前，建议为Redis单独建立一个用户，并新建data和日志文件夹  
    sudo useradd redis  
    sudo mkdir -p /var/lib/redis  
    sudo mkdir -p /var/log/redis  
    sudo chown redis.redis /var/lib/redis  
    sudo chown redis.redis /var/log/redis  

    4.)	设置开机自动启动，关机自动关闭  
    update-rc.d redis-server defaults  
 
    5.)	启动Redis：  
    /etc/init.d/redis-server start  


### 2.3 Maven3的安装和配置 


    1.)    通过apt-get安装Maven3  
    ubuntu12.04之后，可直接用apt-get来获得  
    sudo apt-get install maven -y  
    
    安装完后，进入sudo su 进入root  
    用 mvn –v 查看一下Maven的版本，如下图：  
    安装完毕后，默认的JDK版本可能会被更改。  
    因为Maven3安装的同时把openjdk也一并安装了。  

![此处输入图片的描述][4]    


2.)  修改系统默认的jdk

    update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_80/bin/java 300  
    update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_80/bin/javac 300  
    
    update-alternatives --config java  
    update-alternatives --config javac  

    使用java -version再次查看,JDK版本已更改  

![][5]


### 2.4 Tomcat7的安装和配置 
	
	1.)    apt-get安装tomcat7：  
    sudo apt-get install tomcat7 -y    
    
    tomcat7默认会被安装在目录/var/lib/tomcat7/下,  
    安装完之后在浏览器下输入localhost:8080查看是否安装成功  
    如果出现下图，即为安装成功  

 ![][6]

    
    2.)    安装tomcat7-admin  
    安装成后，我们还需要安装一个tomcat7-admin  
    sudo apt-get install tomcat7-admin  
    
    3.)    修改账户：  
    安装完毕之后，我们进入tomcat7的conf目录下修改tomcat-users.xml文件  
    cd /var/lib/tomcat7/conf/  
    gedit tomcat-users.xml   
    
    我这里用的是  
    <role rolename="manager-gui"/>  
    <role rolename="admin-gui"/>  
    <user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>  

 ![][7]

    
    4.)    重启tomcat:  
    sudo /etc/init.d/tomcat7 restart  


    重新在浏览器打开tomcat界面  
    点击manager webapp，用刚才我们建立的用户登陆  
![][8]

    
    5.)    修改JDK默认的JDK版本  
      
    检查 tomcat7 的 Server Information，版本可能不是我们自己的jdk版本。  
    这里我们要修改tomcat使用的JDK版本，这步很重要，否则会出现很多问题   

![][9]


    sudo gedit /etc/default/tomcat7  

    加入如下内容：  
    JAVA_HOME=/usr/lib/jvm/jdk1.7.0_80  
      
    再次重启tomcat7：  
    sudo /etc/init.d/tomcat7 restart  

![][10]


    OK， tomcat7的JDK版本修改完毕。  


### 2.5 Mysql的安装 


    sudo apt-get install mysql-server -y   
    安装过程中会要求你输入数据库的密码，这里我直接用的123456，连续输入两次即可。  
      
    进入数据库测试一下  
    mysql -u root -p      


    输入密码之后如果看到下图，表明 mysql 成功安装：  


![][11]
 
 
    至此，搭建 Virtual Judge 所需的所有环境，都已搭建完毕！  


---


## 3. 工程代码实施

    准备好四个文件，就是一开始下载的那四个：      

![][12]

### 3.1 Vjudge的打包 
    
    进入virtual-judge-master 目录：  
    cd virtual-judge-master/  
    
    用 Maven 将 Virtual Judge 打包:  
    mvn clean package    


    里面会有一个vjudge.war文件，就是我们打包完成的 Virtual Judge。  
    把这个war文件拷到tomcat7的webapps目录下。  

 

> 打包的过程可能会相当长，特别是网络不好的情况下，万一掉包了，非常蛋疼，如果你不想等待太久，可以直接下载此文件，[网盘][13]  


    
    放到webapps目录后，会自动生成一个vjudge文件夹，如果没有生成，你也可以自行解压。  

![][14]


### 3.2 remote_accounts.json文件的编辑

    把各个OJ的提交账号添加到remote_accounts.json里。   


### 3.3 config.properties文件的编辑

    如不需要代理或VPN访问国外OJ，保留http_client.json里面的["direct"]即可。  

![][15] 



### 3.4 vjudge的简单部署 

    把 remote_accounts.json 和 http_client.json 两个文件放在指定的文件夹下  
    这里我放在 /var/lib/tomcat7/webapps/vjudge/ 目录下  

    sudo mv http_client.json /var/lib/tomcat7/webapps/vjudge/  
    sudo mv remote_accounts.json /var/lib/tomcat7/webapps/vjudge/  


    
    更改/webapps/vjudge/WEB-INF/classes/的目录下config.properties文件  
    将remote_accounts.json和http_client.json的绝对路径改为正确的路径  

    
    cd /var/lib/tomcat7/webapps/vjudge/WEB-INF/classes/  
    sudo gedit config.properties  


 ![][16]

    PS:如果你的数据库密码不是123456，那么上面的root密码你也需要修改，默认为123456   




### 3.5 vhoj数据库的建立 

    在mysql中新建一个数据库，名字为：vhoj，  
    并把表vhoj_20141109.sql导入(可能我的版本略微旧了点)。  
    
    
    mysql -u root -p    
    create database vhoj;    
    exit;   
    
    
![][17]

    mysql -h localhost -u root -p vhoj < vhoj_20141109.sql    


![][18]

    最后，重启tomcat7，进入manager  
    查看Application，可以看到vjudge已经处于running状态了。  

 ![][19]


---

## 4. 大功告成的Vjudge 

    在地址栏输入localhost:8080/vjudge，进入搭建成功的vjudge:  

![][20]


> **到此为止，Virtual Judge 终于搭建成功，just enjoy it！**  


  
> - 参考文献：  
> - [ Virtual Judge 环境搭建与配置][21]   
> - [How to deploy your own Vjudge][22]  




  
  


  [1]: http://pan.baidu.com/s/1o6JVKtc
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/1.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/2.png
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/3.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/4.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/5.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/6.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/8.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/9.png
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/11.png
  [11]: http://7xi3e9.com1.z0.glb.clouddn.com/12.png
  [12]: http://7xi3e9.com1.z0.glb.clouddn.com/14.png
  [13]: http://pan.baidu.com/s/1o6JVKtc
  [14]: http://7xi3e9.com1.z0.glb.clouddn.com/16.png
  [15]: http://7xi3e9.com1.z0.glb.clouddn.com/17.png
  [16]: http://7xi3e9.com1.z0.glb.clouddn.com/18.png
  [17]: http://7xi3e9.com1.z0.glb.clouddn.com/19.png
  [18]: http://7xi3e9.com1.z0.glb.clouddn.com/20.png
  [19]: http://7xi3e9.com1.z0.glb.clouddn.com/21.png
  [20]: http://7xi3e9.com1.z0.glb.clouddn.com/22.png
  [21]: http://blog.csdn.net/free_way/article/details/41311985
  [22]: https://github.com/trcnkq/virtual-judge/wiki/How-to-deploy-your-own-Virtual-Judge