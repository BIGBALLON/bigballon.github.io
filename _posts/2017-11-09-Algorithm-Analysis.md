---
layout: post
title: Algorithm Analysis
---    


## Part 1: Foundations

### 1.0 Master Theorem

$T(n) = aT(\frac{n}{b})+\Theta(n^k log^{p} n) \quad a,b \geq 1 ,k \geq 0, p \text{ is real number}$.

- $\textrm{if $a > b^k$, then $T(n) = \Theta(n^{log_{b}{a}})$}$
- $\textrm{if $a = b^k$}$
    - $\textrm{if $p > -1 $, then $T(n) = \Theta(n^{log_{b}{a}}\log^{p+1}n)$}$
    - $\textrm{if $p = -1 $, then $T(n) = \Theta(n^{log_{b}{a}}\log \log n)$}$
    - $\textrm{if $p < -1 $, then $T(n) = \Theta(n^{log_{b}{a}})$}$
- $\textrm{if $a < b^k$}$
    - $\textrm{if $p \geq 0 $, then $T(n) = \Theta(n^{k}log^{p}{n})$}$
    - $\textrm{if $p < 0 $, then $T(n) = \Theta(n^k)$}$
   

### 1.1 Asymptotic Tight Bound

$T(n)=2T(\frac{n}{2})+n \Rightarrow T(n)=\Theta(n\log n)$    
$T(n)=2T(\frac{n}{2})+n\log n \Rightarrow T(n)=\Theta(n\log^2n)$   
$T(n)=2T(\frac{n}{2})+\frac{n}{\log n} \Rightarrow T(n)=\Theta(n\log \log n)$  
$T(n)=2T(\frac{n}{2})+\frac{n}{\log^2 n} \Rightarrow T(n)=\Theta(n)$  
$T(n)=4T(\frac{n}{2})+\frac{n^2}{\log n} \Rightarrow T(n)=\Theta(n^2 \log \log n)$    
$T(n)=8T(\frac{n}{2})+\frac{n^3}{\log n} \Rightarrow T(n)=\Theta(n^3 \log \log n)$  
$T(n)=aT(\frac{n}{b})+n^{\log{b}^{a}}\log^{k} n \Rightarrow T(n)=\Theta(n^{\log{b}^{a}} \log^{k+1}n)$  
$T(n)=T(\frac{n}{2})+1 \Rightarrow T(n)=\Theta(\log n)$  
$T(n)=T(\frac{n}{2})+\log n \Rightarrow T(n)=\Theta(\log^2 n)$    
$T(n)=T(\sqrt n )+1 \Rightarrow T(n)=\Theta(\log\log n)$  
$T(n)=T(n-1)+n \Rightarrow T(n)=\Theta(n^2)$    
$T(n)=T(n-1)+\frac{1}{n} \Rightarrow T(n)=\Theta(\log n)$    
$T(n)=T(n-1)+\log n \Rightarrow T(n)=\Theta(n \log n)$   
$T(n)\leq T(\frac{n}{5})+ T(\frac{3n}{4})+cn \Rightarrow T(n)=\Theta(n)$      
$T(n)=\sqrt n T(\sqrt n)+n \Rightarrow T(n)=\Theta(n \log \log n)$      
$T(n)=\sqrt n T(\sqrt n)+n\log n \Rightarrow T(n)=\Theta(n \log n)$      
$T(n)=2T(\sqrt n)+\log n \Rightarrow T(n)=\Theta(\log n \log \log n)$     
$T(n)=2T(\sqrt n)+1 \Rightarrow T(n)=\Theta(\log n)$   
$T(n)=\log 1 + \log 2 + \log 3 + ...\log n \Rightarrow T(n)=\Theta(n \log n)$  
$T(n)=\log 1 + \log 2 + \log 3 + ...\log n^2 \Rightarrow T(n)=\Theta(n^2 \log n)$    
$T(n)=\frac{n}{1^2} +\frac{n}{2^2}+ \frac{n}{3^2}+ \frac{n}{n^2} \Rightarrow T(n)=\Theta(n)$    
$T(n)=\frac{n}{n}+ \frac{n}{n+1}+ \frac{n}{n+2}+ \frac{n}{n+n} \Rightarrow T(n)=\Theta(n \log n)$  


- Prove of $T(n)=2T(\sqrt n)+1  =\Theta(\log n)$  

> Let $2^m = n$, so the recurrence becomes $T(2^m)=2T(2^{m/2})+1$       
then, let $T(2^m) = g(m)$, so $g(m)=2T(\frac{m}{2})+1$,  
now, apply the Master Theorem, $g(m)=m$, so $T(n)=\Theta(\log n)$


- Prove of $T(n)=2T(\sqrt n)+\log n   =\Theta(\log n \log \log n)$  

> Let $2^m = n$, so the recurrence becomes $T(2^m)=2T(2^{\frac{m}{2}})+m$       
then, let $T(2^m) = g(m)$, so $g(m)=2T(\frac{m}{2})+m$,  
now, apply the Master Theorem, $g(m)=m \log m$, so $T(n)=\Theta(\log n \log \log n)$

- Prove of $T(n)=\sqrt n T(\sqrt n)+n=\Theta(n \log \log n)$    

> Let $2^m = n, \sqrt{n}=2^{\frac{m}{2}}$, so the recurrence becomes $T(2^m)=2^{\frac{m}{2}}T(2^{\frac{m}{2}})+2^m$       
dividing by $2^m$ , we get $\frac{T(2^m)}{2^m} = \frac{T(2^{\frac{m}{2}})}{2^\frac{m}{2}} +1$.
let $y(m)=\frac{T(2^m)}{2^m}$, then $y(m)=y(\frac{m}{2})+1$
now, we apply the Master Theorem, $y(m)= \log m$, $T(2^m)=2^m \log m$,so $T(n)=n\log \log n$.
Finally: $T(n)=\Theta(n \log \log n)$

- Prove of $T(n)=\frac{n}{n}+ \frac{n}{n+1}+ \frac{n}{n+2}+ \frac{n}{n+n}=\Theta(n \log n)$  

> $T(n)=\frac{n}{n}+ \frac{n}{n+1}+ \frac{n}{n+2}+ \frac{n}{n+n}$  
$=n(\frac{1}{n}+ \frac{1}{n+1}+ \frac{1}{n+2}+ \frac{1}{n+n})$  
$=n((\frac{1}{1}+ \frac{1}{2}+ ... + \frac{1}{n^2})- (\frac{1}{1}+ \frac{1}{2}+ ... + \frac{1}{n})+\frac{1}{n})$  
$=n(\int_{1}^{n^2}\frac{1}{x}-\int_{1}^{n}\frac{1}{x}+\frac{1}{n})$  
$=n(2\ln n-\ln 1 - \ln n + \ln 1+\frac{1}{n})$  
$=n(\ln n+\frac{1}{n})$  
$=n\ln n+1$  
$=\Theta(n \log n)$  

### 1.2 True or false

Let $f(n)$ and $g(n)$ be asymptotically positive functions.

- $f(n) = \mathcal{O}(g(n))$ implies $\log(f(n)) = \mathcal{O}(\log(g(n)))$, where $\lg(g(n)) \geq 1 $and$ f(n) \geq 1 $ for all sufficiently large $n$. 
    - **True.**
- $\log(f(n)) = \mathcal{O}(\log(g(n)))$ implies $f(n)= \mathcal{O}(g(n))$, where $\lg(g(n)) \geq 1 $and$ f(n) \geq 1 $ for all sufficiently large $n$. 
    - **False.** $\log(n^2) = \mathcal{O}(\log(n))$,but $ n^2 \ne \mathcal{O}(n)$
- $\log(f(n)) = \mathcal{o}(\log(g(n)))$ implies $f(n) = \mathcal{o}(g(n))$, where $\log(g(n)) \geq 1 $and$ f(n) \geq 1 $ for all sufficiently large $n$. 
    - **True.**
- $f(n)=\mathcal{O}(g(n))$ implies $2^{f(n)}=\mathcal{O}(2^{g(n)})$
    - **False.** we have $2n \in \mathcal{O}(n)$, but $2^{2n} \notin \mathcal{O}(2^n)$ 
- $f(n)+\mathcal{o}(n)=\Theta(f(n))$ 
    - **True**
- $(\log n)!=\mathcal{O}(n)$ 
    - **False**
- $(\log(\log n))!=\mathcal{O}(n)$
    - **True**
- $2^{\sqrt{2\log n}}=\mathcal{O}(\sqrt n)$ 
    - **True**
- If $\log(f(n))=\mathcal{o}(\log n)$ then $f(n)$ is polynomially bounded 
    - **False**
- If $\log(f(n))=\Theta(\log n)$ then $f(n)$ is polynomially bounded 
    - **True**

### 1.3 Polynomially Bounded Function

$$\begin{align*}
& (1) \lg(\lg^{*}n) & (2) 2^{lg^{*}n}           & (3) (\sqrt{2})^{\lg n}   & (4) n^2                    & (5) n!                      & (6) \left \lceil  \lg n \right \rceil ! &(7)  (\frac{3}{2})^n & \\   
& (8) n^3           & (9) \lg^{2}n              &(10) \lg(n!)              &(11) 2^{2^n}                &(12) n^{\frac{1}{\lg n}}     &(13) \ln(\ln n)                          &(14) \lg^{*}n        & \\
&(15) n2^{n}        & (16) n^{\lg \lg n}        &(17) \ln n                &(18) 1                      &(19) 2^{\lg n}               &(20)  (\lg n)^{\lg n}                    &(21) e^{n}           & \\
&(22)  4^{\lg n}    &(23) (n+1)!                &(24) \sqrt{\lg n}         &(25) \lg^{*}(\lg n)         &(26)  2^{\sqrt{2\lg n}}      &(27)  n                                  &(28)  2^n            & \\
&(29) n\lg n        &(30) 2^{2^{n+1}}           &(31) 7^{\log n}           &(32)  \log(n^n)             &(33) 10^{log_3(n)}           &(34)  n^n                                &(35) 0.5^n           & \\
&(36) 1.1^n         &(37) \left \lceil  \log \log n \right \rceil !          &(38) \frac{n\log n}{\log \log n}
\end{align*}$$

-  Pick out polynomially bounded functions.
    - $(3) \quad (\sqrt{2})^{\lg n}=2^{(\frac{1}{2} \lg n)}=2^{(\lg n^{\frac{1}{2} })}=n^{\frac{1}{2} }$
    - $(4) \quad n^2$
    - $(8) \quad n^3$
    - $(10) \quad \lg(n!)=\Theta(n\lg n)$
    - $(19) \quad 2^{\lg n}=n$
    - $(22) \quad 4^{\lg n}=n^2$
    - $(26) \quad 2^{\sqrt{2\lg n}}$
    - $(27) \quad n$
    - $(29) \quad n\lg n$
    - $(31) \quad 7^{\log n}=n^{\log 7}$
    - $(32) \quad \log{n^n}=n{\log n}=\Theta(n{\log n})$
    - $(33) \quad 10^{\log_{3}{ n}}$
    - $(37) \quad \left \lceil  \log \log n \right \rceil !  $
    - $(38)\quad \frac{n\log n}{\log \log n}$


- Then rank them by order from small to large.

$$\begin{align*}
&n^3 > 10^{\log_{3}(n)}>n^2=4^{\lg n} > n\lg(n)=\lg(n!)=\log(n^n)>\frac{n\log n}{\log \log n}\\
& >n =2^{\lg n}>7^{\log n}>(\sqrt{2})^{\lg n}>2^{\sqrt{2\lg n}}>\left \lceil  \log \log n \right \rceil !
\end{align*}$$


- 思考：$2^{\sqrt{2\lg n}} $  和 $\left \lceil  \log \log n \right \rceil !$ 谁大一些？ 它们是 Polynomial bounded function 吗?


### 1.4 Strassen's matrix multiplication problem

- Using traditional matrix product method and Strassen's methods.
    - tradition: 8 multiplications and 4 additions
    - strassen:  7 multiplications and 18 additions
- related recurrence equation
    - tradition: $T(n) = 8T(\frac{n}{2})+4(\frac{n}{2}\times \frac{n}{2})=\Theta(n^3)$
    - strassen:  $T(n) = 7T(\frac{n}{2})+18(\frac{n}{2}\times \frac{n}{2})=\Theta(n^{lg7})$
- diveide the matrices into $\frac{n}{2} \times \frac{n}{2}$ submatrices. Estimate the time complexity of this method.
    - $T(n) = mT(\frac{n}{2})+a(\frac{n}{2}\times \frac{n}{2})$
$$
T(n)=\left\{\begin{matrix}
& \mathcal{O}(n^{\log_2{m}}) &\text{if} \log_2{m} > 2 \\
& \mathcal{O}(n^2 \log n) &\text{if} \log_2{m} = 2\\
& \mathcal{O}(n^2) &\text{if} \log_2{m} < 2
\end{matrix}\right.
$$
- diveide the matrices into $\frac{n}{3} \times \frac{n}{3}$ submatrices. Estimate the time complexity of this method.
    - $T(n) = mT(\frac{n}{3})+a(\frac{n}{3}\times \frac{n}{3})$
$$T(n)=\left\{\begin{matrix}
& \mathcal{O}(n^{\log_3{m}}) &\text{if} \log_3{m} > 2 \\
& \mathcal{O}(n^2 \log n) &\text{if} \log_3{m} = 2\\
& \mathcal{O}(n^2) &\text{if} \log_3{m} < 2
\end{matrix}\right.$$
- what is the largest value of m to get an asymptotic faster matrix multiplication algorithm than Strassen's?
- Only need $log_{3}{m} < log_{2}{7}$,that is $m = \left \lfloor 3^{\log_{2}{7}} \right \rfloor=21$


### 1.5  Switch Network

Assume $n=2^k$, $T(2)=1$, then  

$$\begin{align*}
T(n) &= 2T(\frac{n}{2})+n \\
&=2(2T(c)+\frac{n}{2})+n \\
&=2^{(k-1)}+(k-1)n\\
&=\frac{1}{2}2^{k}+kn-n\\
&=\frac{1}{2}n+n\log n -n\\
&=n\log n -\frac{1}{2}n
\end{align*}$$


### 1.6 Prove of $\log(n!)$ = $\Theta(n\log n)$

$$\begin{align*}
& \because n(n-1)(n-2)(n-3) \cdots \lceil n/2 \rceil \geq (\lceil n/2 \rceil)^{\lceil n/2 \rceil} \\
& \therefore  (\lceil n/2 \rceil)^{\lceil n/2 \rceil} \leq n! \\ 
& \because \log(\frac{n}{2})^{\frac{n}{2}} = \frac{n}{2}\log(\frac{n}{2}) \\
& =\frac{n}{2}(\log n -\log 2)=\frac{n}{2}\log n-\frac{n}{2}\log 2\\ 
& =\frac{n}{2}\log n-\frac{n}{4}\log 4 \geq \frac{n}{2}\log n-\frac{n}{4}\log n = \frac{n}{4}\log n\\
& \therefore \log(n!) = \Omega(n\log n) \\
& \because n! \leq n^{n} \\
& \therefore \log(n!)=\sum_{i=1}^{n}\log i \leq \sum_{i=1}^{n}\log n = n \log n \\
& \therefore \log(n!) = \mathcal{O}(n\log n) \\
& \therefore \log(n!) = \Theta(n\log n)
\end{align*}$$



## Part 4: Dynamic Programming

---

### 4.1 Sub-set Sum problem

- **Objective function**

$x$ 表示 当前的 $target$  
$i$ 表示 当前set只有$a_{1},a_{2}...a_{i}$  
$f[x,i]$表示在只有$a_1,a_2...a_i$的情况下是否有sub-set sum为$x$   


$$
f[x,i]=
\left\{
\begin{aligned}
&1 &yes\\ 
&0 &no
\end{aligned}
\right.\\
\textrm{and $x = 0,1,2,...t$. \quad $i = 0,1,2,...n$}
$$

- **Recursive relation**

$$
f[x,i]=\max
\left\{
\begin{aligned}
&f[x-a_i,i-1] & \textrm{if x $\geq a_i$ }\\
&f[x,i-1] &
\end{aligned}
\right.
$$

- **Initial condition**
 

$$
f[x,1]=
\left\{
\begin{aligned}
&1 &\textrm{if $x=a_1$}\\
&0 &\textrm{if $x \neq a_1$}
\end{aligned}
\right.\\
\textrm{and $f[0,i]=1$}
$$

- $\textrm{Answer:}$ $f[t,n]$
- $\textrm{Time complexity} = \Theta(nt)$  
- $\textrm{Space complexity} = \Theta(nt)$

### 4.2 Zero-One knapsack problem

- **Objective function**

$x$ 表示 当前的 背包容量  
$i$ 表示 有item $w_1,w_2...w_i$  
$f[x,i]$表示在这样的情况下，所能获得的最大value

- **Recursive relation**

$$
f[x,i]=\max
\left\{
\begin{aligned}
&f[x-w_i,i-1] + v[i]& \textrm{if x $\geq w_i$ }\\
&f[x,i-1] &
\end{aligned}
\right.
$$

- **Initial condition**
 

$$
f[x,1]=
\left\{
\begin{aligned}
&v_1 &\textrm{if $x\leq w_1$}\\
&0 &\textrm{if $x \neq a_1$}
\end{aligned}
\right. \\
\textrm{and $f[0,i]=0$ for all $i=1..n$}
$$


- $\textrm{Answer:}$ $f[w,n]$
- $\textrm{Time complexity} = \Theta(nw)$  
- $\textrm{Space complexity} = \Theta(nw)$

### 4.3 Longest Common Subsequence

- **Objective function**

$s1$表示字符串1,其长度为$n$, $s2$表示字符串2,其长度为$m$  
$f[i,j]$表示以s1[i]和s2[j]结尾的两个序列的最长公共子序列(LCS)

- **Recursive relation**

$$
f[i,j]=\left\{
\begin{aligned}
&f[i-1,j-1]+1 & \textrm{if s1[i] $=$ s2[j] }\\
& \max \{ f[i-1,j] f[i,j-1]\}&
\end{aligned}
\right.
$$

- **Initial condition**


$f[i,0]=0, f[0,j]=0$


- $\textrm{Answer:}$ $f[n,m]$
- $\textrm{Time complexity} = \Theta(nm)$  
- $\textrm{Space complexity} = \Theta(nm)$

### 4.4 Matrix-Chain Multiplication Problem

- **Objective function**

$m[i,j]$表示计算$A_i...A_j$所需要的最少的scalar multiplication

- **Recursive relation**

$$
m[i,j]=
\left\{
\begin{aligned}
& 0  & \textrm{if $i=j$}\\
& \min_{i \leq k \leq j}\left\{ m[i,k]+m[k+1,j]+p_{i-1}\cdot p_{k}\cdot p_{j} \right\} & \textrm{if $i<j$} 
\end{aligned}
\right.
$$

- **Initial condition**: $m[i,j]= \infty $

- $\textrm{Answer:}$ $m[i,j]$
- $\textrm{Time complexity} = \Theta(n^3)$  
- $\textrm{Space complexity} = \Theta(n^2)$

### 4.5 Optimal Binary Search Tree

We are given a sequence $K=\left \langle k_1,k_2,...k_n \right \rangle$ of n distinct keys in sorted order, and we wish to build a binary search tree from these keys. For each key $k_i$, we have a probability $p_i$ that a search will be for $k_i$. Some searches may be for values not in $K$, and so we also have $n+1$ "dummy keys" $d_i$ representing values not in $K$. So we have 

$\sum_{i=1}^{n}p_{i}+\sum_{i=0}^{n}q_{i}=1$

for a subtree with keys $k_{i},...k_{j}$, let us denote this sum of probabilities as $w(i,j)$.
$w(i,j) = \sum_{l=i}^{j}p_{l}+\sum_{l=i-1}^{j}q_{l}$

- **Objective function**

$e[i,j]$: means expected cost of searching an optimal binary search tree containing the keys $k_i,...k_j$

- **Recursive relation**

$$
[i,j]=
\left\{
\begin{aligned}
& q_{i-1} & \textrm{if $j = i-1$}  \\
& \min_{i\leq r\leq j}\{ e[i,r-1] + e[r+1,j] + w[i,j]\} & \textrm{if $i \leq j$} 
\end{aligned}
\right.
$$

- **Initial condition**

$e[i,i-1]=q_{i-1} \quad  \textrm{for all $i= 1...n+1$}$

- $\textrm{Answer:}$ $e[1,n]$
- $\textrm{Time complexity} = \Theta(n^3)$  
- $\textrm{Space complexity} = \Theta(n^2)$


### 4.6 Huffman Coding (Greedy)

Generalize Huffman’s algorithm to ternary codewords (using 3 symbols  0, 1, 2 ) How?   

 If n is odd, take the 3 lowest-frequencies characters to merge together. 
 If n is even, take the 2 lowest-frequencies characters to merge together. 

若 n 是奇數，則第一次是 3 個合併，然後是 3 個合併，永遠是 3 個 3 個合併   
若 n 是偶數，則第一次 2 個 合併，以後永遠是 3 個 3 個合併 

### 4.7 Maximum Program Stored Problem (Greedy)

- 一个tape的情况：先对这些programs按照长度由小到大进行sort，时间复杂度为$\mathcal{O}(nlogn)$
然后再将这些programs按顺序(小到大的顺序)放入tape中，直到tape放满或者无法再放入为止。  
总的时间复杂度为$\mathcal{O}(n)+\mathcal{O}(nlogn)=\mathcal{O}(nlogn)$
- 两个tape的情况：先对这些programs按照长度由小到大进行sort，时间复杂度为$\mathcal{O}(nlogn)$
然后再将这些programs按顺序(小到大的顺序)放入tape1中，直到tape1放满或者无法再放入，
再将剩下的programs按顺序(小到大的顺序)放入tape2中，直到tape1放满或者无法再放入。  
总的时间复杂度为$\mathcal{O}(n)+\mathcal{O}(nlogn)=\mathcal{O}(nlogn)$

### 4.8 Intervals Coverage

Describe an efficient algorithm that, given  set $\{ x_1, x_2, ..., x_n\}$ of n points on real line, determines the smallest set of unit-length closed intervals that contains all of the given points

先将Set$\{ x_1, x_2, ..., x_n\}$进行排序(从小到大)，排序后变为$\{ y_1, y_2, ..., y_n\}$, 然后每次挑最左边的点，并取区间$[y_i,y_{i+1} ]$，而这个区间覆盖到的点，我们将其跳过。反复执行此动作知道所有点都处理完毕。

因为在这种情况下，一个区间必定会覆盖到尽可能多的点，所以该解法最优。

The running time of our algorithm is $\mathcal{O}(n\log n + n) = \mathcal{O}(n \log n)$, where $\mathcal{O}(n \log n)$ is the
time for soring and O(n) is the time for the linear scan.


### 4.9 Activity-selection Problem

可以正向贪心，即按照开始时间最早进行排序。  (Selecting the fisrt activity to finish)   
也可以反向贪心，即按照结束时间最晚进行排序。 (Selecting the fisrt activity to start)  

## Part 5 : Amortized analysis


---

Consider the dynamic table problem. Doubling the table size when it is full as before.But instead of contracting the table by halving its size when its load factor drops below 1/4, we contract it by multiplying its size by 2/3 when its load factor drops below 1/3.

- Write a tight potential function without any explanation.
    - $ \Phi(T)=  \vert 2 num[T]-size[T] \vert $
- Give the constant that the amortized cost of each operation is bounded above by.
    - **The amortized cost is at most 3**
- Give the amortized cost for the following four cases.
    - The load factor is full 1, and the next operation is insertion. **3**
    - The load factor is 1/3, and the next operation is insertion. **-1**
        - we have that $size_{i-1}=size_{i}$ and $num_{i-1}+1=num_{i}$  
            $$
\begin{align*}\hat{c_{i}}&=c_i+\Phi_{i}-\Phi_{i-1} \\
&=1+\left | 2num_i-size_i \right |-\left | 2num_{i-1}-size_{i-1}\right | \\
&=1+2num_i-2num_{i-1} \\
&=1 + 2num_i-2num_i-2 \\
&=-1
\end{align*}
$$
    - The load factor is 1/3, and the next operation is deletion. **2**
        - since we resize when the load factor drops below $1/3$,we have that 
            - $size_{i-1}/3=num_{i-1}=num_i+1$
$$
\begin{align*}\hat{c_{i}}&=c_i+\Phi_{i}-\Phi_{i-1} \\
&\leq num_i+1+\left | 2num_i-size_i \right |-\left | 2num_{i-1}-size_{i-1}\right | \\
&=num_i+1+(\frac{2}{3}size_{i-1}-2num_i)-(size_{i-1}-2num_{i}-2) \\
&=num_i+1+ 2 -\frac{1}{3}size_{i-1}\\
&=2
\end{align*}
$$
    - The load factor is structly between 1/3 and 1/2, and the next operation is deletion. **3**


