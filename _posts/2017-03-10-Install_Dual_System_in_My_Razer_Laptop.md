---
layout: post
title: Install Dual System in My Razer Laptop
date: 2017-03-10 23:58
---

### 0X00001 Windows 预热篇

---

- 系统自带了razer synapse和 killer Network manager，炫酷无比。
- 随后我更新了NVIDIA，怎么能让1060不发挥它的功效能
- 装了7zip（因为WinRAR要付费，不想用盗版，也不允许我的Razer里面有盗版APP）
- Chrome（开启Edge第一时间下载了Chrome，Google的同步功能我，绝对的赞）
- CCleaner（这东西是我唯一喜欢的清理软件）
- FileZilla（下载FileZilla赶紧连上学校的ftp）
- QQ拼音（搜狗的广告简直不能忍，这个是我唯一会用的腾讯软件了）
- TIM（好吧我打脸来，新出来个TIM，测了一下bug多多，不过干净啊，从此QQ真的真的被大家废弃了，偶耶）
- Codeblocks（其实只是癖好罢了，现在真的很少用CB了，另外GCC也用的6.3版本了）
- minGW64（赶忙装上minGW64）
- Git（这东西没有还怎么玩耍）
- Sublime（这东西没有更没办法玩耍）
- 网易云音乐（Linux下出了release版后，我就对它好评了）
- Office 2016（这时候从学校FTP下载的大批东西也都下好了，在NCTU天天用正版，超爽）
- Visual studio 2015（同样正版不解释）
- Texlive（这东西不能少吧）
- Teamviewer（这个更不能少，在连wifi的时候必须要用这个啊，话说我Razer没有网口，也必须用这个了）
- Matlab2016A（正版就是爽，2333，读研之后才发现matlab如此强大，不愧是马特拉不）
- Windows linux system（装了WLS，然后装了Teminator，效果简直日天，和Linux还是差好远）
- Teminator（本来被我给予厚望，后来失望了，不过还是感谢这位[大佬][1]）
- Anaconda（这东西还是很好用的，jupyter和spyder好评）
- Rstudio（纯粹为了部落）
- Weka（其实weka这东西真的很弱）
- putty（这个，貌似没有这个好像也没办法活下去）

![p1][2]

Windows说实话除了玩游戏什么都干不了  
可见系统垃圾至极，其实我没有买MAC买了Razer的另外一个用意，就是我想用Linux吖 
虽然网络上各种Razer难装Linux的呼声，但是我还是要装啊，药不能停啊。


### 0X00002 风风雨雨的Ubuntu折腾日记

---

按照惯例，我关闭了BIOS里的Security Boot，关闭了Windows10的快速启动。
习惯性地插入了我的SSK，习惯性地准备开始装Ubuntu16.04。

#### First Blood

- 日天了，装完没有网卡，没有wifi。。。GOD
- 找了好久，发现killer network官网暗藏杀机，果断切换到Windows下载来了deb包，dpkg -i 安装之

#### Double kill

- 于是乎，reboot，wifi出现，然而，Razer所有驱动都不能用，，，哈哈哈，这很正常
- Google之后，我决定把kernel升级到4.8...XD

#### Killing Spree

- 然后，声音不见了，WTF，耳机有声音，Speaker却没有，炸。

#### Dominating

- remove & install & ohter operator， 好了，好像有声音了。

#### Mega Kill

- LED 灯变成摆设了，在Google找了很久，，找到一个uchoma的开源项目，然后死活装不上


```
sudo add-apt-repository ppa:cyanogen/uchroma
sudo apt update
sudo apt install uchroma

sudo apt-get install python-pip
pip install -U pip
sudo apt-get -y install python3-pip
pip3 install hsluv
pip3 install grapefruit
pip3 install colorlog
pip3 install wrapt
pip3 install matplotlib
pip3 install scipy
pip3 install traitlets
pip3 install frozendict

sudo pip3 install scikit-image
```

- 联系作者，作者表示他没有在16.04上测试过，Sad。

#### Unstopabble

- 于是乎，装Nvidia， CUDA， cudnn，caffe， tensorflow。
- 测试良好，，，第二天上课，发现，如果我把电脑盖上再打开，也就是从睡眠到唤醒，就会出花屏，GOD

![][3]

#### Wicked Sick

- 然后我终于放弃了Ubuntu16.04
- 你真的以为我会放弃？
- 我只是去找了 [Ubuntu GNOME][4]，，准备和unity说再见。
- [Ubuntu GNOME][5] 16.04.2 LTS 版本默认内核为4.8，刚好满足Razer的大于4.7
- 然后我就开始装了，，这个厉害了，也是装完直接就没有声音，最后我找到的罪魁祸首
- Don't select download updates while installing as that causes the installer to freeze for some reason but do select to install third party software for devices
- shit, 就不能在这时候装什么第三方驱动，进去之后再装吧，233
- 。。。好像装了也可以，问题应该是出在系统切换上面？not sure

#### Monster Kill

- 于是乎我折腾了好久又发现显卡有问题，[chroma][6]的事情姑且不管了，等作者回复我消息再说吧。

#### Godlike

- 好吧，上面都是扯淡，，下面开始正式的Razer Ubuntu16.04 安装之旅。下面全部用英文写了。

## Holy Shit : Installing Ubuntu 16.04 on Razer Blade 14

> Hi, guys, This is my machine:

- Razer Blade 14 (2016)
- i7 6700HQ
- 16GB RAM
- 256GB PCIe SSD
- GTX1060 6GB RAM
- 1920 x 1080 Full HD


> I just try to install ubuntu on my razer blade 14 2016.  
The following steps let me install ubuntu successfully.

#### Pre-installation

> I just install [Ubuntu Gnome 16.04.2 LTS][7] instead of [Ubuntu 16.04.2 LTS][8], the kernel of Ubuntu 16.04 is 4.4.x, but it is 4.8.x in Ubuntu Gnome. 

1. Download [Ubuntu Gnome 16.04.2 LTS][9] and burn the ISO to a USB drive.
2. Log in Windows10, open Disk Management, click the C drive partition and select Shrink Volume
3. Set the size & Click shrink to finish it.
4. Reboot the laptop and mash the del key to enter the BIOS
5. Find the security tab, then disable "Secure Boot" and "Fast Boot"(It's important).
6. Save & Reboot your PC

#### Installation(I)

1. Choose UEFI boot to start installation
2. Select to Install alongside windows(It's important).
3. No need to connect to Internet
4. Don't tnstall third-party software(It may cause speaker no sound)
5. Go through & install finished & reboot with no USB disk

#### Installation(II)

Then, log in your ubuntu system.

- Connect to the Internet by wi-fi, if wi-fi device doesn't work, just install killer network driver, Download it [here][10]

```
sudo dpkg -i linux-firmware_1.163_all.deb  
reboot
```

- update source & app 

```
sudo apt-get update
sudo apt-get upgrade
```

- Install intel-graphy-driver


- Then use [this][11] & [this][12] to install GPU driver.

- Fix Time Differences in Ubuntu 16.04 & Windows 10 Dual Boot

```
timedatectl set-local-rtc 1 --adjust-system-clock
```

#### Installation(III)

......to be continue

### 0X00003 References

---

- [Guide to installing Ubuntu on the Razer Blade 14 (2016)][13]
- [Installing Ubuntu 16.04 on Razer Blade (2016)][14]
- [Ubuntu 14.04 (trusty) installation on Razer blade 2016][15]
- [killernetworking-amazing][16]
- [Index of /ubuntu/pool/main/l/linux-firmware/][17]
- [How to Fix Time Differences in Ubuntu 16.04 & Windows 10 Dual Boot][18]
- [How do I install a .deb file via the command line?][19]
- [Change default width of gnome-terminal and terminator windows][20]
- [Ubuntu16.04 安装配置Caffe][21]
- [深度学习主机环境配置: Ubuntu16.04+GeForce GTX 1080+TensorFlow][22]
- [Installing with virtualenv][23]
- [Ubuntu14.04 + Nvidia Cuda8.0 + Caffe][24] 
- [Ubuntu Intel显卡驱动安装 （Ubuntu 14.04--Ubuntu 16.10 + Intel® Graphics Update Tool）][25]
- [Cannot resume from suspend ubuntu 16.04 Gnome][26]
- [16.04 Will not Resume after Suspend][27]


### 0X00004 完美的Razer Blade

---

最近的研究有了一点点新的进展，曙光还是有的，继续努力吧。  
Seminar OK 图：

![p2][28]



to be continue


  [1]: https://blog.cyplo.net/posts/2016/07/06/terminal-emulator-windows-10-bash.html
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/050954055_o.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/0_794669662_o.png
  [4]: http://ubuntugnome.org/
  [5]: http://ubuntugnome.org/
  [6]: https://github.com/cyanogen/uchroma
  [7]: https://ubuntugnome.org/download/
  [8]: https://www.ubuntu.com/download/desktop
  [9]: https://ubuntugnome.org/download/
  [10]: http://mirrors.kernel.org/ubuntu/pool/main/l/linux-firmware/
  [11]: https://www.reddit.com/r/razer/comments/5e82i0/guide_to_installing_ubuntu_on_the_razer_blade_14/
  [12]: https://xipherzero.com/ubuntu-16-04-razer-blade-2016/
  [13]: https://www.reddit.com/r/razer/comments/5e82i0/guide_to_installing_ubuntu_on_the_razer_blade_14/
  [14]: https://xipherzero.com/ubuntu-16-04-razer-blade-2016/
  [15]: https://github.com/wecacuee/razer-blade-ubuntu-trusty-installation
  [16]: http://www.killernetworking.com/driver-downloads/knowledge-base?view=topic&id=2
  [17]: http://mirrors.kernel.org/ubuntu/pool/main/l/linux-firmware/
  [18]: http://ubuntuhandbook.org/index.php/2016/05/time-differences-ubuntu-1604-windows-10/
  [19]: http://askubuntu.com/questions/40779/how-do-i-install-a-deb-file-via-the-command-line
  [20]: http://askubuntu.com/questions/4371/change-default-width-of-gnome-terminal-and-terminator-windows
  [21]: http://www.cnblogs.com/xuanxufeng/p/6150593.html
  [22]: http://www.52nlp.cn/%E6%B7%B1%E5%BA%A6%E5%AD%A6%E4%B9%A0%E4%B8%BB%E6%9C%BA%E7%8E%AF%E5%A2%83%E9%85%8D%E7%BD%AE-ubuntu16-04-geforce-gtx1080-tensorflow
  [23]: https://www.tensorflow.org/install/install_linux#InstallingVirtualenv
  [24]: http://blog.csdn.net/yan_song_/article/details/53154611
  [25]: http://blog.csdn.net/zhangrelay/article/details/53482596
  [26]: http://askubuntu.com/questions/511432/the-resume-after-suspend-problem
  [27]: http://askubuntu.com/questions/769496/16-04-will-not-resume-after-suspend
  [28]: http://7xi3e9.com1.z0.glb.clouddn.com/1849_n.png