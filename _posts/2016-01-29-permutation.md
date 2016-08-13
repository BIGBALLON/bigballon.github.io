---
layout: post
title: 全排列生成算法
categories: [algorithm]
tags: [algorithm,icpc]
---



全排列的生成算法，居然有20多种，我哪里知道真么多啊。。。。
就拿几种来说吧2333.


## 1. 递归

$n$个数的全排列共有$n!$个,而$n!=n(n-1)!=n(n-1)(n-2)!$  
也就是我们可以先确定一个数，然后再确定$n-1$个数，而对这$n-1$个数，从中选择一个，再确定$n-2$个数。。。  
看出来了，，就是**暴力枚举**，，是的，，我们用**递归**  
递归过程如下：  

     dfs( nums, len, id ):
        if(id == len ) store answer and return
        for i from id to n-1
            swap(nums[id],nums[i])
            dfs( nums, step+1, id+1 )
            swap(nums[id],nums[i])


## 2. 字典序

算法过程如下：  

1. 从右往左对序列进行扫描，直到找到第一次下降的位置 $i$
2. 在 $i$ 的右侧的所有数中找出比 $a_i$ 大的最小的数的位置 $j$
3. 交换 $a_i$ 和 $a_j$
4. 将 $a_i$ 右侧的序列翻转，得到字典序的下一个序列

**反复执行上述操作，可以得到完整的全排列**

> 对于 $839647521$ 这个序列，它的下一个排列为  
  找到 第一次下降的位置 $i = 4 $  
  在 $i$ 的右侧的所有数中找出比 $a_i = 4$ 大的最小的数的位置 $j=6$  
  交换 $a_4$ 和 $a_6$ 序列变为 $839657421$   
  将 $a_i$ 右侧的序列（即后缀）翻转，得到 $839651247$   
 
 事实上，$\text{STL}$中的 ``next_permutation`` 就是使用的这种算法  
 ``next_permutation( nums.begin(), nums.end() )``!
 
 
 
## 3. SJT Algorithm
 
该算法规定，每个数字具有一定的移动方向  

 - 如果该数的方向指向的相邻数比该数小的话则称该数是可移动数$\text{(Mobile Integer)}$
 - $1$ 永远不可移动
 - $n$ 除了指向边界外都可以移动

算法步骤： 初始状态所有数的移动方向朝左　$\overleftarrow{a_1},\overleftarrow{a_2},...,\overleftarrow{a_n}$  

1. 找到当前最大的可移动数$a_k$  
2. 交换$a_k$与它指向的数  
3. 改变所有比$a_k$大的数的移动方向  
4. 重复上述操作，直到没有可移动数为止  
 

## 4. Heap's Algorithm

不是很理解


## 5. 存在重复元素的序列的全排列

> Given a collection of numbers that might contain duplicates, return all possible unique permutations.

这里有一个需要解决的问题，就是去重问题。  
我们保证当前数只和与自己不想等的数交换，就能保证没有重复，具体的，我们可以写一个函数来进行判重处理  

{% highlight c++ %}
class Solution {
public:
    bool noswap(vector<int> &nums, int i, int id ) {
        for( int j = id; j < i; j++ ) {
            if ( nums[i] == nums[j] ) return true;
        }
        return false;
    }
    void dfs( vector<vector<int> >& res, vector<int>&nums, int id, int len ){
        if( id == len - 1 ){
            res.push_back( nums );
            return;
        }
        for( int i = id; i < len; ++i ){
            if( !noswap( nums, i, id ) ){
                swap( nums[i], nums[id] );
                dfs( res, nums, id + 1, len );
                swap( nums[i], nums[id] );
            }
        }
    }
    vector<vector<int>> permuteUnique(vector<int>& nums) {
        sort( nums.begin(), nums.end() );
        vector<vector<int>> res;
        dfs( res, nums, 0, nums.size() );
        return res;
    }
};
{% endhighlight %}
 
一个[遗留问题][1]  


## 6. 参考文献
 
 > [全排列算法(字典序法、SJT Algorithm 、Heap's Algorithm)][2]  
 > [全排列生成算法（一）][3]  
 > [Heap's algorithm][4]  
 > [Steinhaus–Johnson–Trotter algorithm][5]  


  [1]: https://leetcode.com/discuss/25279/a-simple-c-solution-in-only-20-lines
  [2]: http://blog.csdn.net/JDPlus/article/details/41546455
  [3]: http://blog.csdn.net/joylnwang/article/details/7064115
  [4]: https://en.wikipedia.org/wiki/Heap%27s_algorithm
  [5]: https://en.wikipedia.org/wiki/Steinhaus%E2%80%93Johnson%E2%80%93Trotter_algorithm
