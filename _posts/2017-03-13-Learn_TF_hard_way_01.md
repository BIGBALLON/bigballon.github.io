---
layout: post
title: Learn Tensorflow Hard Way (I) Installation
date: 2017-03-13 0:58
---

古人有云： 

> 工欲善其事必先利其器

让我们从安装开始

简要说明我手头机器的配置

- 自己的Razer Blade 14 (2016)
    - i7 6700HQ
    - 16GB RAM
    - 256GB SSD
    - GTX1060 6GB 
- 学校的机器 
    - GTX 1060 6GB


下面简要说一下我自己Laptop的安装过程


## STEP 1: Install Ubuntu 16.04

---

1. 到 [Ubuntu官网][1] 下载ISO镜像
2. 使用 UltraISO 把镜像刻录到U盘
3. 进入Win10，打开磁盘管理，压缩出40GB(or more)的磁盘空间
4. Reboot，进入BIOS，关闭 Security boot 及 Win10 的 Fast boot (Important)
5. Reboot，从USB 引导进入安装界面
6. 选择Ubuntu与Windows共存(或者你乐意选择其他自己分配空间也无妨)
7. 一路安装到底 (tips: 安装的时候不要更新，仅安装第三方软件即可)

## STEP 2: Install NVIDIA Driver

---

- 更新源和必要的软件，如果在国内请自行更换合适的source

```
sudo apt-get update
sudo apt-get upgrade
```

- 禁用Nouveau

```
sudo vi /etc/modprobe.d/disable-nouveau.conf

//加入如下两行
blacklist nouveau
options nouveau modeset=0

```

重建kernel initramfs并重新启动

```
sudo update-initramfs -u
sudo reboot
```

- 安装NVIDIA 驱动

重启进入登录界面，切换到tty1(ctrl+alt+f1)

关闭图形界面

```
sudo service lightdm stop
```

增加 Nvidia 的 ppa 源

```
sudo apt-get purge nvidia-*
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
```

安装Nvidia

```
sudo apt-get install nvidia-375
reboot
```

重启，再次进入tty1，执行如下命令，没问题则ok了

```
sudo apt-get update && sudo apt-get upgrade
```

最后，用 nvidia-smi 查看GPU的信息

## STEP 3: Install CUDA 8.0

---

- 从[官网][2]下载CUDA文件(ex. cuda_8.0.61_375.26_linux-run )
- 加执行权限并安装

```
cd Downloads/
sudo chmod a+x cuda_8.0.61_375.26_linux-run
sudo ./cuda_8.0.61_375.26_linux-run
```
- 设置环境变量

```
sudo vi ~/.bashrc  
//加入这两行
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export CUDA_HOME=/usr/local/cuda-8.0

//使环境变量生效
source ~/.bashrc
```

- 测试CUDA的Sample

```
cd /usr/local/cuda-8.0/samples/1_Utilities/deviceQuery
sudo make
sudo ./deviceQuery
```

## STEP 4: Install Cudnn

---

- 到 [官网][3] 下载(需注册账号)
- 解压 & 复制文件 & 给执行权限

```
cd Downloads/
tar -zxvf cudnn-8.0-linux-x64-v5.1.tgz 
sudo cp cuda/include/cudnn.h /usr/local/cuda-8.0/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda-8.0/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda-8.0/lib64/libcudnn*
```

## STEP 5: [Install Tensorflow][4] via pip

---

- 安装必要依赖

```
sudo apt-get install libcupti-dev
```
- 安装python-pip

```
sudo apt-get install python-pip python-dev
//python3
sudo apt-get install python3-pip
pip install -U pip
```

- 安装tensorflow

```
//python
pip2 install tensorflow-gpu
//python3
pip3 install tensorflow-gpu
```

- 测试

开启一个terminal

```
>>> import tensorflow as tf
>>> hello = tf.constant('Hello, TensorFlow!')
>>> sess = tf.Session()
>>> print(sess.run(hello))
```

输出

```
Hello, TensorFlow!
```

安装成功


  [1]: https://www.ubuntu.com/download/desktop
  [2]: https://developer.nvidia.com/cuda-downloads
  [3]: https://developer.nvidia.com/rdp/cudnn-download
  [4]: https://www.tensorflow.org/install/
