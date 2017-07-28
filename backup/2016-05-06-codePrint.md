---
layout: post
title: 代码打印系统折腾日记
categories: [icpc]
tags: [icpc]
---


3天前，荆老师给了我一台打印机，让我完成省赛代码打印系统的测试。  
打印机型号为 HP P1007，算是一台比较老的打印了。  

**本文记录了从打印机驱动安装到代码打印WEB部署的全过程**  


## 1. 安装打印机驱动  

HP在linux端没有提供官方的打印机驱动，还好，在[HP Linux Imaging and Printing][1]找到了第三方驱动。  
刚开始我选择[手动安装][2]，然而驱动似乎是正确安装了，但是打印机就是不工作。  
后来采取的策略是先配置必要环境，再使用自动安装的脚本，具体记录如下：  

### 必要的文件

通过如下网站进行下载：  

https://sourceforge.net/projects/hplip/files/hplip/  
http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/  

这里我选择了最新版本 ``hplip-3.16.5``，不过还是推荐 ``hplip-3.16.3``
最终我们得到以下4个文件，一个安装脚本，一个插件，以及两个asc文件：  

```
hplip-3.16.5.run
hplip-3.16.5-plugin.run
hplip-3.16.5.run.asc
hplip-3.16.5-plugin.run.asc
```

### 安装依赖  

我的系统是 ``Ubuntu14.04 x64``, 其他版本参考 [这里][3]  
运行如下命令，完成依赖的安装：  

```
sudo apt-get install --assume-yes avahi-utils libcups2 cups libcups2-dev cups-bsd cups-client libcupsimage2-dev libdbus-1-dev build-essential ghostscript openssl libjpeg-dev libsnmp-dev snmp-mibs-downloader libtool libusb-1.0.0-dev wget policykit-1 policykit-1-gnome python3-dbus python3-gi python3-dev python3-notify2 python3-imaging python3-pyqt4 gtk2-engines-pixbuf python3-dbus.mainloop.qt python3-reportlab python3-lxml libsane libsane-dev sane-utils xsane

sudo apt-get install python-dev
```

### 运行脚本

```
sudo chmod +x hplip-3.16.5.run
./hplip-3.16.5.run
```
会出现各种提示，顺着安装程序一路走下去，即可安装成功。


## 2. 配置Nginx+PHP+mysql环境

### 提升权限
```  
sudo su
```

### 安装apt源管理工具、添加nginx和php的安装源 

```
apt-get install python-software-properties
add-apt-repository ppa:nginx/stable
add-apt-repository ppa:ondrej/php5
apt-get update
```

### 安装mysql

```
apt-get install mysql-server
```

### 安装php及对mysql的支持

```
apt-get install php5 php5-fpm php5-mysql php-apc
```

### 安装php功能模块

```
apt-get install php-pear php5-dev php5-curl php5-gd php5-intl php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
```

### 安装nginx

```
apt-get install nginx
```

### 配置php

```
vim /etc/php5/fpm/php.ini
```
找到：``cgi.fix_pathinfo=1``  
改为：``cgi.fix_pathinfo=0``

### 配置nginx

创建一个 /www 目录设置为 755 权限

```
mkdir /www
chmod 755 /www
```

```
vim /etc/nginx/sites-enabled/default
```

找到：``root /usr/share/nginx/html;``  
改为：``root /www;``

找到：``index index.html index.htm;``  
改为：``index index.php index.html index.htm;``

找到：``location ~ .php$ { * }`` 区块，修改为：

```
 location ~ \.php$ {
                try_files $uri =404;
                include snippets/fastcgi-php.conf;
        #
        #       # With php5-cgi alone:
        #       fastcgi_pass 127.0.0.1:9000;
        #       # With php5-fpm:
                fastcgi_pass unix:/var/run/php5-fpm.sock;
        }
```

### 解决php-fpm与nginx的小bug

```
vim /etc/nginx/fastcgi_params
```

在最后一行添加：

```
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
```

### 解决nginx不能运行的问题

```
vim /etc/nginx/snippets/fastcgi-php.conf
```

```
删除 ``try_files`` 所在的行
```

### 重启各项服务

```
service php5-fpm reload
service nginx reload
```

### 测试

```
vim /www/index.php
```

输入 ``<?php echo phpinfo(); ?>`` 并保存。  
打开你的浏览器访问： ``http://localhost``，若一切正常，将输出php环境信息  


## 3. 部署代码打印程序

将此 [代码打印程序][4] ，复制到 ``/www`` 目录下即可。
使用浏览器访问 ``http://localhost/codeprinter.html`` 即可。

核心代码如下：  

```
<?php
		
		$name = $_POST['name'];
		$passwd = $_POST['passwd'];
		$content = $_POST['content'];
		$content = stripslashes($content);
		$result = false;
		$handle = fopen('namelist', 'r');
		while($userinfo = fscanf($handle, "%s %s")){
			list($team, $password) = $userinfo;
			if($team == $name && $passwd == $password)
				$result = true;
		}
		fclose($handle);
		if(!$result){
			echo "<script language=javascript>alert('team number or password is wrong!');</script>";
			echo "<script language=javascript>history.back();</script>";
		}else {
		//phpinfo();
			$filename = "./code/".$name."-".date('H-i-s');
			$fp = fopen($filename, "wb");
			$content = date('H-i-s')."\t\t".$name."\n\n".$content;
			fwrite($fp, $content);
			fclose($fp);
			$command = "lpr -o prettyprint ".$filename;
			system($command);	
			echo "<script language=javascript>alert('Your code has been printed successfully, please wait a moment!');</script>";
			echo "<script language=javascript>history.back();</script>";
		}
	?>
```

最终效果如下：

![xg][5]


## 4. 参考资料

[ubuntu14.04安装hp laserjet p1007打印机][6]  
[基于ubuntu 14搭建nginx+php+mysql环境][7]   
[php5.3 fastcgi方式 安装以及和nginx整合][8]    


  [1]: http://hplipopensource.com/hplip-web/index.html
  [2]: http://hplipopensource.com/hplip-web/install/manual/distros/ubuntu.html
  [3]: http://hplipopensource.com/hplip-web/install/manual/distros/ubuntu.html
  [4]: https://github.com/BIGBALLON/codePrint
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/xg1.png
  [6]: http://blog.sina.com.cn/s/blog_6c9d65a10102uw4b.html
  [7]: http://www.limingx.com/posts/w176.html
  [8]: http://www.cnblogs.com/siqi/p/3574638.html