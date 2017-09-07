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


- [查看tensorflow版本][3]

```
pip list | grep tensorflow
//or
python -c 'import tensorflow as tf; print(tf.__version__)'
```


- tf.app.run & tf.app.flags 用法

Runs the program with an optional 'main' function and 'argv' list.

```
def run(main=None, argv=None):
  """Runs the program with an optional 'main' function and 'argv' list."""
  f = flags.FLAGS

  # Extract the args from the optional `argv` list.
  args = argv[1:] if argv else None

  # Parse the known flags from that list, or from the command
  # line otherwise.
  # pylint: disable=protected-access
  flags_passthrough = f._parse_flags(args=args)
  # pylint: enable=protected-access

  main = main or _sys.modules['__main__'].main

  # Call the main function, passing through any arguments
  # to the final program.
  _sys.exit(main(_sys.argv[:1] + flags_passthrough))
```

```
FLAGS = tf.app.flags.FLAGS

tf.app.flags.DEFINE_string('log_save_path', './nin_logs', 'Directory where to save tensorboard log')
tf.app.flags.DEFINE_string('model_save_path', './model/', 'Directory where to save model weights')
tf.app.flags.DEFINE_integer('batch_size', 128, 'batch size')
tf.app.flags.DEFINE_integer('iteration', 391, 'iteration')
tf.app.flags.DEFINE_float('weight_decay', 0.0001, 'weight decay')
tf.app.flags.DEFINE_float('dropout', 0.5, 'dropout')
tf.app.flags.DEFINE_float('epochs', 164, 'epochs')
tf.app.flags.DEFINE_float('momentum', 0.9, 'momentum')
```

  [1]: http://www.cnblogs.com/darkknightzh/p/6591923.html
  [2]: https://stackoverflow.com/questions/38513333/is-it-possible-to-see-tensorboard-over-ssh
  [3]: https://stackoverflow.com/questions/38549253/how-to-find-which-version-of-tensorflow-is-installed-in-my-system