---
layout: post
title: Tensorflow Checklist
categories: [tensorflow]
tags: [tensorflow]
---


- [Tensorflow中使用指定的GPU及GPU显存][1]

```
//终端执行程序时设置使用的GPU
CUDA_VISIBLE_DEVICES=1 python my_script.py

//python代码中设置使用的GPU
import os
os.environ["CUDA_VISIBLE_DEVICES"] = "2"
```


```
//设置tensorflow使用的显存大小
//定量设置显存

//默认tensorflow是使用GPU尽可能多的显存。可以通过下面的方式，来设置使用的GPU显存：

gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.7)
sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))        

//按需设置显存

gpu_options = tf.GPUOptions(allow_growth=True)
sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))   
```


- [SSH 访问 Tensorboard][2]

```
ssh -L 16006:127.0.0.1:6006 account@server.address
```



  [1]: http://www.cnblogs.com/darkknightzh/p/6591923.html
  [2]: https://stackoverflow.com/questions/38513333/is-it-possible-to-see-tensorboard-over-ssh
