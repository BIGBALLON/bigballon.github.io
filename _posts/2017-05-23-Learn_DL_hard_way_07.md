---
layout: post
title: Learn Deep Learning Hard Way (VII) Caption generation with visual attention
date: 2017-05-22 12:58
---

## PART 1: Introduction

In this Lab, we are going to run a Caption generator by using CNN and RNN language generator to generate a sentence that describes the image.  
We will modify the code (https://github.com/yunjey/show-attend-and-tell)   

- Upgrade code for tensorflow 1.0 (model.py, solver.py). 
- Deal with the memory problem 

- Lab Description: 
    - Learn how to combine CNN features and RNN language generator. 
    - Compare two different attention mechanisms. 
 
 ![][1]



## PART 2: Experiment setup
---


- Upgrade code for tensorflow 1.0 (model.py, solver.py). 

1.  Download tf_upgrade.py (https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/compatibility)  
2.  Using [python tf_upgrade.py --infile InputFile --outfile OutputFile] to update

- Deal with the memory problem 

1.prepro.py main ()   
Because our machine has only 12GB memory, so we can’t load all train data. So I split features to 9 files (10000 each, the last one is 2783).  
And to run this code, I change the batch_size from 100 to 40  

 ![][2]
 
2.utils.py   
If [split == 'train'], we will not load features.hkl.   

 ![][3]

3.solver.py     
In function train (), each epoch, we will load the 9 feature files in turn.  

 ![][4]


4.train.py   

 ![][5]

5.model.py   
change softmax alpha matrix to one hat matrix ( argmax - 1 others - 0 )

![][6]
 




## PART 3: Result
---

![][7]

![][8]

- Some images:

- Soft attention:

![][9]

![][10]

![][11]

- Hard attention:

![][12]

![][13]

![][14]




## PART 4: Discussion 
---

![][15]

![][16]

The hard attention’s performance is worse than soft attention. (see figure 2’s batch loss)  
According to paper, the METEOR is about 23%(training by sampling)  
in my lab (10 epochs, about 5 hour’s training, using one hat vector), I got 20.6%.  

From figure 4 & figure 5, we also can see after 10 epoch’s training, my can got some good captions.  
But in figure 6, maybe hard attention’s caption is incorrect?  


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/Lab71.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/Lab72.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/lab73.png
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/lab74.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/lab75.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/lab76.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/lab77.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/lab78.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/lab79.png
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/lab710.png
  [11]: http://7xi3e9.com1.z0.glb.clouddn.com/lab711.png
  [12]: http://7xi3e9.com1.z0.glb.clouddn.com/lab712.png
  [13]: http://7xi3e9.com1.z0.glb.clouddn.com/lab713.png
  [14]: http://7xi3e9.com1.z0.glb.clouddn.com/lab714.png
  [15]: http://7xi3e9.com1.z0.glb.clouddn.com/lab715.png
  [16]: http://7xi3e9.com1.z0.glb.clouddn.com/lab716.png