---
layout: post
title: Learn Deep Learning Hard Way (IV) VA + BN + WI on Cifar-10
date: 2017-03-30 11:58
---


## PART 1: Introduction
---

In Lab 3, we learned how to build an NIN (Network in Network), and how to use Tensorflow (Keras or tflearn) to implement the model. In this Lab, we will be asked to use various activation functions, batch normalization, an weight initialization in NIN, and train it on Cifar-10 dataset.


I used Keras to implement these models and test the following requirements:

- Use ReLU, Leaky Rectifier Linear Unit(LReLU) , Exponential Linear Unit(ELU)  and Maxout activation function
- implement weight initialization method of He’s paper 
- use batch normalization in NIN model.
- Train NIN using three different activation functions and compare
    - 2(ReLU, ELU,) X 2(w/wo BN) X 2(w/wo weight initial)
    - 2(LReLU, Maxout) X 1(with BN) X 1(with weight initial)

## PART 2: Experiment setup
---

- Architecture Details

![AD][1]

- Training hyperparameters:
    - Method: SGD with Nesterov momentum momentum=0.9, nesterov=True 
    - Data preprocessing: Color normalization
    - Weight initialization: He’s WI
    - batch size: 128 (391 iterations for each epoch)
    - Total epochs: 164
    - Loss function: cross-entropy
    - Initial learning rate: 0.1, divide by 10 at 81, 122 epoch
    - Weight Decay: kernel_regularizer=keras.regularizers.l2(0.0001)
    - Dropout: 0.5 

- Data augmentation: 
    - Translation: Pad 4 zeros in each side and random cropping back to 32x32 size 
    - Horizontal flipping with probability 0.5

## PART 3: Result
---

I just test all of the 8 models, it cost about 3 hours(2h59m) to train a model (ELU+BN+WI), (ELU+BN), (BN) and (BN+WI), 1h35min for the other models.
All of the 8 CNN models’ final test accuracy are more than 90%. 
The ELU+BN+WI model gets 91.67%, and the ELU+BN model gets 91.34%, it seems nice. We can learn that as the data flows through a deep network, the weights and parameters adjust those values, sometimes making the data too big or too small again. By normalizing the data in each mini-batch, this problem is largely avoided.
See the table and figures below for detailed results

![][2]

![][3]

## PART 4: Other experiments & Discussion
---

In lab4, we used lots of tricks and method to improve our model’s accuracy.

BN (Batch normalization) faster learning and higher overall accuracy. The improved method also allows us to use a higher learning rate, potentially providing another boost in speed. (Initial learning rate 0.1 is too large to train if we did not use special tricks in Lab3, but BN can avoid this problem, it makes loss drops very fast.)

WI (ReLU + He’s weight initial + without BN) got the worst accuracy compared with other models. And sometimes WI may not converge.

Different activation function will have different effect, ELU and LeakyReLU have better performance than ReLU. As for maxout, I tried to use it, but it seems that my code doesn’t work. 

## PART 5: References
---

- Maas, A. L., Hannun, A. Y., & Ng, A. Y. (2013, June). Rectifier nonlinearities improve neural network acoustic models. In Proc. ICML (Vol. 30, No. 1).
- Clevert, D. A., Unterthiner, T., & Hochreiter, S. (2015). Fast and accurate deep network learning by exponential linear units (elus). arXiv preprint arXiv:1511.07289.
- He, K., Zhang, X., Ren, S., & Sun, J. (2015). Delving deep into rectifiers: Surpassing human-level performance on imagenet classification. In Proceedings of the IEEE International Conference on Computer Vision (pp. 1026-1034).
- Ioffe, S., & Szegedy, C. (2015). Batch normalization: Accelerating deep network training by reducing internal covariate shift. arXiv preprint arXiv:1502.03167.
- Goodfellow, I. J., Warde-Farley, D., Mirza, M., Courville, A. C., & Bengio, Y. (2013). Maxout networks. ICML (3), 28, 1319-1327.


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/AC.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/lab42.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/lab41.png
