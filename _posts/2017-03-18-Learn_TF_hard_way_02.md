---
layout: post
title: Learn Tensorflow Hard Way (II) MNIST For ML Beginners
date: 2017-03-18 0:58
---

> When one learns how to program, there's a tradition that the first thing you do is print "Hello World." Just like programming has Hello World, machine learning has MNIST.

正如在学习C语言时，第一个程序是输出“hello world”一样  
在学习machine learning时，第一个例子往往使用 MNIST 。


## STEP 1: Build a Softmax Regression Model

---

- Loss Function: Cross-Entropy
- Activation Function: Softmax
- Optimizer: SGD

```
# download & load MNIST_data
from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

# import tensorflow and create a session
import tensorflow as tf
sess = tf.InteractiveSession()

# x  : input images  
# y_ : output classes
x = tf.placeholder(tf.float32, shape=[None, 784])
y_ = tf.placeholder(tf.float32, shape=[None, 10])

# w : weight
# b : bias
W = tf.Variable(tf.zeros([784,10]))
b = tf.Variable(tf.zeros([10]))

# initialize variable
sess.run(tf.global_variables_initializer())

# regression model y = x * W + b
y = tf.matmul(x,W) + b

# calc cross entropy
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y))

# using SGD to minimize cross entropy error
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)

# train : 1000 iterations , 100 example data each iteration
for _ in range(1000):
  batch = mnist.train.next_batch(100)
  train_step.run(feed_dict={x: batch[0], y_: batch[1]})

# calc accuracy
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

print(accuracy.eval(feed_dict={x: mnist.test.images, y_: mnist.test.labels}))
```

最终可以得到training之后的accuracy大约在92%左右，效果并不是很理想。  
接下来再用CNN来进行training。

## STEP 2: Build a Multilayer Convolutional Network

---

卷积层的定义如下：
```
tf.nn.conv2d(input, filter, strides, padding, use_cudnn_on_gpu=None, data_format=None, name=None)
```

- 初始image大小为28*28，即input x_image为[28,28,1]  

- 第一层: 卷积层，filter数量为32，大小为5*5，padding=2    
    - 做完第1次convolution + Relu后 feature map:[28,28,1] -> [28,28,32]
    - 第1次pooling filter大小为2*2，stride=2 feature map: [28,28,32] -> [14,14,32]
- 第二层: 卷积层，filter数量为64，大小为5*5，padding=2    
    - 做完第2次convolution + Relu后 feature map:[14,14,32] -> [14,14,64]]
    - 第2次pooling filter大小为2*2，stride=2 feature map: [14,14,64] -> [7,7,64]
- 第三层: 全连接层 feature map: [7,7,64] -> [1,1,1024]
- 第四层: Dropout层 feature map: [1,1,1024] -> [1,1,1024]
- 第五层: 输出层 feature map: [1,1,1024] -> [1,1,10]
- 最后计算cross entropy，再接softmax
- 使用AdamOptimizer来进行training的最佳化
- 更新weight

![cnnmnist][1]

```
# download & load MNIST_data
from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

# import tensorflow and create a session
import tensorflow as tf
sess = tf.InteractiveSession()

# x  : input images  
# y_ : output classes
x = tf.placeholder(tf.float32, shape=[None, 784])
y_ = tf.placeholder(tf.float32, shape=[None, 10])
# reshape x -> x_image 
x_image = tf.reshape(x, [-1,28,28,1])

# Weight Initialization 
def weight_variable(shape):
  initial = tf.truncated_normal(shape, stddev=0.1)
  return tf.Variable(initial)
# Bias Initialization 
def bias_variable(shape):
  initial = tf.constant(0.1, shape=shape)
  return tf.Variable(initial)

# define convolution & max pooling
def conv2d(x, W):
  return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')

def max_pool_2x2(x):
  return tf.nn.max_pool(x, ksize=[1, 2, 2, 1],
                        strides=[1, 2, 2, 1], padding='SAME')

# First Convolutional Layer
W_conv1 = weight_variable([5, 5, 1, 32])
b_conv1 = bias_variable([32])
h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)
h_pool1 = max_pool_2x2(h_conv1)

# Second Convolutional Layer
W_conv2 = weight_variable([5, 5, 32, 64])
b_conv2 = bias_variable([64])
h_conv2 = tf.nn.relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 = max_pool_2x2(h_conv2)

# Densely Connected Layer
W_fc1 = weight_variable([7 * 7 * 64, 1024])
b_fc1 = bias_variable([1024])
h_pool2_flat = tf.reshape(h_pool2, [-1, 7*7*64])
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)

# Dropout Layer
keep_prob = tf.placeholder(tf.float32)
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

# Readout Layer
W_fc2 = weight_variable([1024, 10])
b_fc2 = bias_variable([10])

y_conv = tf.matmul(h_fc1_drop, W_fc2) + b_fc2

# Train and Evaluate the Model
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y_conv))
train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
correct_prediction = tf.equal(tf.argmax(y_conv,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

sess.run(tf.global_variables_initializer())

for i in range(20000):
  batch = mnist.train.next_batch(50)
  if i%100 == 0:
    train_accuracy = accuracy.eval(feed_dict={
        x:batch[0], y_: batch[1], keep_prob: 1.0})
    print("step %d, training accuracy %g"%(i, train_accuracy))
  train_step.run(feed_dict={x: batch[0], y_: batch[1], keep_prob: 0.5})

print("test accuracy %g"%accuracy.eval(feed_dict={x: mnist.test.images, y_: mnist.test.labels, keep_prob: 1.0}))
```
最后的结果Test accuracy 可以达到99.2%，这就比较理想了！

```
tep 0, training accuracy 0.16
step 100, training accuracy 0.8
step 200, training accuracy 0.92
step 300, training accuracy 0.86
step 400, training accuracy 0.96
step 500, training accuracy 0.88
step 600, training accuracy 1
......
......
step 19800, training accuracy 1
step 19900, training accuracy 1
test accuracy 0.9926
```


未完待续

  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/cnnmnist.png
