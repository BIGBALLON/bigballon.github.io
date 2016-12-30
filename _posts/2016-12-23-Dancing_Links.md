---
layout: post
title: Dancing Links and Exact Cover
categories: [icpc]
tags: [icpc]
---


## 1. Exact Cover Problem

DLX是用来解决精确覆盖问题行之有效的算法。
在讲解DLX之前，我们先了解一下什么是精确覆盖问题(Exact Cover Problem)？

### 1.1 Polyomino 

多联骨牌（Polyomino）是一种类似于七巧板的棋盘游戏：  
如下图所示，除去中间$4$个方格不允许放置任何东西，这个棋盘总共有$8*8-4=60$个方格  

![dlx1][1]

> 将这$12$个由$5$个方格组成的图形全部放入到棋盘中，满足每个格子都被使用，而且只被使用一次。

每个格子都被覆盖，而且只能被覆盖一次，对，这就是精确覆盖问题！  
(PS:因为$12*5=60$，而整个棋盘除去中间$4$格也刚好是$60$格，所以你应该很容易就明白"每个格子都被覆盖，而且只能被覆盖一次"的含义)

### 1.2 Sudoku

数独（Sudoku）这个游戏，大家应该都非常熟悉了。  
我们以经典的$9*9$数独为例

![dlx2][2]

- 每一个方格必须要放置一个数字，而且只能放置一次  
- 每一行只能放置1-9，而且每个数字只能出现一次  
- 每一列只能放置1-9，而且每个数字只能出现一次  
- 每一宫只能放置1-9，而且每个数字只能出现一次  

是的，这很明显也是一个精确覆盖问题。

### 1.3 Exact Cover Problem

我们下面将精确覆盖问题抽象一下。

> 给定一个仅由 $0$ 和 $1$ 组成的矩阵，  
是否能找到一个行的集合，使得集合中每一列都恰好包含一个 $1$

下图的矩阵中，我们可以找到一个集合$(row1,row4,row5)$，使得每一列有且只有一个$1$

![dlx3][3]

## 2 Dancing Links & X Algorithm

- Algorithm X = “traditional” backtracking ( DFS )
- Algorithm DLX = Dancing Links + Algorithm X

### 2.1 X algorithm

理解了精确覆盖问题，我们再来了解一下 X 算法。  
X算法是由 [Donald Knuth][4] 提出的一个用来解决 精确覆盖问题的算法。

它实际上就是一种传统意义上的回溯（Backtracking）。  
假定我们需要求解的矩阵为A，我们来看一下它的主要流程：


- 如果矩阵 $A$ 为空，找到解；成功返回。
- 否则，选择一个列 $c$。
    - 选择一个满足 $A[r][c]=1$行 $r$，把 $r$ 包含进部分解
        - 对于所有满足 $A[r][j]=1$ 的 $j$，从矩阵 $A$ 中删除第 $j$ 列；
    - 对于所有满足 $A[i][j]=1$ 的 $i$，从矩阵 $A$ 中删除第 $i$ 行。
- 再不断减少的矩阵 $A$ 上递归地重复上述算法。


好，这是个递归的过程，但是看起来有些费解，让我们用图来解释吧。

如下图所示，假设当前我们选择的是第$3$列，那么第三列中含有$1$的行分别是$row1$和$row3$。  
假设我们选择第一行(图片中被标红)，那么这行中，第3，5，6列都含有1，所以我们将列3，5和6标记，表示已经覆盖过。   
由于3，5，6列已经被覆盖，所以其他行如果在列3，5或者6出现1，则一定不能选择，所以我们将第3行和第6行删去，因为第一行已经被我们选择了，所以第一行也删去，那么我们就会得到右边的新矩阵，它只包含$row2,row4,row5$三行。   
好的，接下来我们再选择$row2$(在图中是第一行，但实际上它的标号是$row2$)，选择之后，覆盖第1，4，7列，同样做删除操作之后，将会得到右边的空矩阵。     
但是我们会发现，第2列并没有被覆盖，但是矩阵已经为空，所以我们并没有找到答案。  
这时候，我们就需要回溯。  

![dlx4][5]

刚才我们选择了$row2$，并确定$row2$是错误的，那么现在我们选择$row4$，它将会覆盖第1和第4列，删除操作后，得到右边的$(1,1)$矩阵，此时还剩下第2和第7列没有被覆盖，然而我们只剩下$row5$这一行，所以再次选择$row5$，矩阵为空，所有列全部被覆盖，OK，我们得到了一组正解，它就是$(row1,row4,row5)$

![dlx5][6]

对，这就是X算法的核心思想了。

### 2.2 Dancing Links

没错，dancing links并不是一个算法，它实际上是一个数据结构，**双向循环十字链表**。

如下图所示，把十字链表变成双向十字链表，再加上头尾循环，就变成了$dancing \;links$

![dlx6][7]

不过，实际上的dancing links，还有一个链表头（List header）    
前面我们用到的矩阵 $A$,所对应的dancing links就如下图所示。

![dlx7][8]

对于每一个元素，我们有5个fields，分别是$L[x],R[x],U[x],D[x],C[x]$
$L,R,U,D$分别代表x的左右和上下,$C$代表当前元素所在的列，实际上有时候我们还会再加上一个域，来表示当前元素所在的行。


![dlx8][9]

对于每一列，我们还有一个链表头，除了拥有$L[y],R[y],U[y],D[y],C[y]$这5个基本的域之外，它还有一个额外的$S[y]$，用来表示当前列总过有多少个1，别入图中$x$所在的列，总共有两个1，所以$S[C[X]]=2$

![dlx9][10]

####  2.2.1 Subsequent Operations

假设 $x$ 指向双向链的一个节点；$L[x]$和 $R[x]$分别表示 $x$ 的前驱节点和后继节点。  
每个程序员都知道将 $x$ 从链表删除的操作：  

> $L[R[x]] ← L[x], R[L[x]] ← R[x]$

但是只有少数程序员意识到如下操作：

> $L[R[x]] ← x, R[L[x]] ← x $

而这就是dancing links的精髓所在，在回溯的过程中，我们仅仅只是将某个元素移除，而不是将它彻底删除，所以用这种方式，我们不需要额外开辟空间去存储递归过程中的矩阵和位置信息，而是通过跳舞来解决这个问题！

![dlx10][11]

### 2.3 DLX Algorithm

好的，还是刚才的矩阵 $A$, 我们把dancing links运用到X算法上，来看看DLX是如何进行的。

![dlx11][12]

首先我们查看$R[head]$，发现它等于$A$,所以我们覆盖第一列，并进行$remove$操作。  
因为第一列需要被覆盖，所以第一列存在1的行，都将被删去，我们将这些元素标记为红色。

![dlx12][13]

我们选择$row2$, 那么$row2$除了覆盖第$2$列，还覆盖了第$4(D)$和第$7(G)$列。  
于此同时，凡是也也覆盖第$4(D)$或者第$7(G)$列行，都将被删去，我们把这些元素用标记为黑色。


![dlx13][14]

删去这些元素，我们继续遍历表头，这时候我们需要覆盖的是第$2(B)$列，同样进行$remove$操作。  

![dlx14][15]

这时候我们只能选择$row3$,继续做相应的$remove$操作。

![dlx15][16]

最后我们发现还剩下第$5(E)$列没有被覆盖，但是矩阵 $A$ 中已经没有元素了。  
这时候我们需要进行回溯，也就是这里的$resume$操作。

![dlx16][17]

回溯回来发现，这里只有$row3$能选，那我们继续执行$resume$操作。

![dlx17][18]

刚才我们选择了$row2$，这次我们选择$row4$, 如之前所述，再次执行$remove$操作。

![dlx18][19]

这里又出现两个选择，$row3$和$row5$,我们会先选择$row3$,继而删光矩阵中的所有元素，发现无解，再次resume回来。  
那我们继续选择$row5$，再次执行$remove$操作。

![dlx19][20]

最后我们只能选择$row1$，执行$remove$操作。

![dlx20][21]

这次我们发现，$R[head] = head$，矩阵中也没有任何元素，所有列均被覆盖。  
因此我们得到了答案$(row4,row5,row1)$。


![dlx21][22]


#### 2.3.1 Heuristic

前面有提到过，我们还有一个叫做S的域，这个域是有作用的，我们不应该每次都选取$head$的右结点$R[head]$，我们应该去选择1的数量最少的列。  

如下图所示的矩阵(假设为$B$)，第4列只有$S[y]=1$，说明我们必须要选择$row3$,而且$row3$一定是正确的，那连带图中紫色标出的另外4个1，也是正确的，于是矩阵$B$瞬间被$remove$操作删减为$(1,1)$，我们可以迅速通过2层的递归得到一个解$(row3,row5)$

![dlx22][23]

另外，如果把链表的指针形式改写为静态数组形式，效率会更高。

![dlx23][24]


## 3 Application & Comparison

### 3.1 Polyomino and Exact Cover

在最开始我们介绍的多联骨牌（Polyomino），我们来考虑如何将它转化为精确覆盖问题。

首先，我们将$60$个方格编号，为$1-60$。
那么，如果某个格子被覆盖到了，那么这一列就为1，
总共有$12$个图形，所以我们还需要标记是哪一个图形，这里我们用$61-72$来表示这$12$个图形。
如下图，我们用十字这个图形来覆盖，如果是左边这种情况，我们会覆盖$2，9，10，11，18$这$5$列，加上十字这个图形是编号$70$，所以我们还要覆盖列$70$。   
如果是右边这种情况，我们会覆盖$3，10，11，12，19，70$这$6$列。

从这里可以看出，我们的矩阵会有$72$列，以及若干行，具体多少行，和$12$个图形的形状有关。  
将它们完全转化为矩阵之后。就变成精确覆盖问题了，套用DLX模板，即可求解。


![dlx24][25]


### 3.2 Sudoku and Exact Cover 

数独问题怎么转化为精确覆盖问题呢？  
我们需要构造的矩阵，行和列分别表示什么呢？

- 对于列$(4*n^2)$， 一共有4个限制:
    - 位置限制:每一格有且仅有一个数.
    - 列限制:每一列中每个数仅出现一次.
    - 行限制:每一行中每个数仅出现一次.
    - 区域限制:每个区域每个数仅出现一次.

- 对于行$(n^3)$： 
    - 表示每个数放入每格中.


对于位置限制，每一个位置都需要出现一个数，且只能出现一个数，拿$4*4$的数独，那就是16个格子每个格子只能出现一个数，我们将它们在矩阵中编号为$1-16$。  
如下图所示，2出现在第一行，第一列，所以在举证的列1，填上1，数字4出现在第一行第二列，所以在列2填上1。

![dlx25][26]

对于列的限制，每一列中每个数仅出现一次。我们将它们在矩阵中编号为$17-32$。  
如下图所示，2出现在数独的第一列，所以在矩阵的第18列(表示第1列出现2)填上1，数字4出现在数独第二列，所以在矩阵的第24列(表示第2列出现4)填上1。

![dlx26][27]

对于行的限制，每一行中每个数仅出现一次。我们将它们在矩阵中编号为$33-48$。  
如下图所示，2出现在数独的第一行，所以在矩阵的第34列(表示第1行出现2)填上1，数字4出现在数独第二列，所以在矩阵的第36列(表示第1行出现4)填上1。

![dlx27][28]


对于宫的限制，每一宫中每个数仅出现一次。我们将它们在矩阵中编号为$48-64$。  
如下图所示，2出现在数独的第一行，所以在矩阵的第50列(表示第1宫出现2)填上1，数字4出现在数独第二列，所以在矩阵的第52列(表示第1宫出现4)填上1。


![dlx28][29]


那么最终，我们的矩阵共有$4*n^2=64$列

而每个格子最多有n总放置方法$(1-n)$，我们共有$n*n$个格子，所以最多会有$n^3=64$行。

![dlx29][30]

对于$9*9$的数独,  
我们将其转化为一个 $729*324$ 的矩阵，然后DLX模板套之即可！  

![dlx30][31]

![dlx_code][32]

```
struct DLX{
	int n, m, cnt;
	int L[maxnode], R[maxnode], U[maxnode], D[maxnode], row[maxnode], col[maxnode];
	int S[MAXC], H[MAXR], o[MAXR];
	void init( int _n, int _m ){
		n = _n; m = _m;
		for( int i = 0; i <= m; ++i ){
			S[i] = 0;
			U[i] = D[i] = i;
			L[i] = i - 1; R[i] = i + 1;
		}
		R[m] = 0; L[0] = m;
		cnt = m;
		for( int i = 1; i <= n; ++i ) H[i] = -1;
	}
	void link( int r, int  c ){
		S[c]++;
		col[++cnt] = c;	row[cnt] = r;
		D[cnt] = D[c];	U[D[c]] = cnt;
		U[cnt] = c; D[c] = cnt;
		if( H[r] < 0 ) H[r] = L[cnt] = R[cnt] = cnt;
		else{
			R[cnt] = R[H[r]];
			L[R[H[r]]] = cnt;
			L[cnt] = H[r];
			R[H[r]] = cnt;
		}
	}
	void remove( int c ){
		L[R[c]] = L[c]; R[L[c]] = R[c];
		for( int i = D[c]; i != c; i = D[i] )
			for( int j = R[i]; j != i; j = R[j] ){
				U[D[j]] = U[j];
				D[U[j]] = D[j];
				--S[col[j]];
			}
	}
	void resume( int c ){
		for( int i = U[c]; i != c; i = U[i] )
			for( int j = L[i]; j != i; j = L[j] ){
				U[D[j]] = D[U[j]] = j;
				++S[col[j]];
			}
		L[R[c]] = R[L[c]] = c;
	}
	bool dancing( int d ){
		if( R[0] == 0 )
			return true;
		int c = R[0];
		for( int i = R[0]; i != 0; i = R[i] )
			if( S[i] < S[c] ) 
				c = i;
		remove(c);
		for( int i = D[c]; i != c; i = D[i] ){
			o[d] = row[i];
			for( int j = R[i] ; j != i; j = R[j] ) remove( col[j] );
			if( dancing( d + 1 ) ) return true;
			for( int j = L[i] ; j != i; j = L[j] ) resume( col[j] );
		}
		resume(c);
		return false;
	}
}dlx;

```

#### 3.2.1 test

我先使用 [qqwing][33] 生成的难度级分别别为简单，中等和困难的$9*9$数独各200个。    
然后对DLX和DFS分别进行测试，得到如下图所示的结果，DLX要比DFS快了**60-140**倍！

![dlx31][34]

### 3.3 N-queens and Exact Cover

N皇后问题，也可以转化为精确覆盖，然后DLX模板套之。。
通过前面的讲解你应该能够自己建模了吧？试一试[SPOJ NQUEEN][35]这道题目怎么样？


## 4 Conclusion

- DLX is a simple and beautiful algorithm.
- It can solve Exact Cover Problem（精确覆盖） efficiently.
- It can also solve Overlapping Cover(重复覆盖) Problem.(虽然本文没有提及，但这也是DLX的重要运用，需要对remove和resume操作以及dancing部分进行略微的修改)
- Thanks for Donald E. Knuth.

## 5 Reference

- 一些也许有用的链接
    - [Solving Sudoku with Dancing Links][36]
    - [Knuth's Algorithm X and Dancing Links][37]
    - [Dancing Links Donald E. Knuth, Stanford University][38]
    - [Exact cover I][39]
    - [跳跃的舞者，舞蹈链（Dancing Links）算法][40]
    - [bin神的DLX专题][41]

- 一些也许有用的资料下载
    - [我的slide][42]
    - [我测试的code][43]
    - [某巨巨ppt][44]
    - [Dancing Links在搜索中的运用][45]
    - [Dancing links中文版][46]


> Let’s dance ! Thank you!


  [1]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx1.png
  [2]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx2.png
  [3]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx3.png
  [4]: https://en.wikipedia.org/wiki/Donald_Knuth
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx4.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx5.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx6.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx7.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx8.png
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx9.png
  [11]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx10.png
  [12]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx11.png
  [13]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx12.png
  [14]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx13.png
  [15]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx14.png
  [16]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx15.png
  [17]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx16.png
  [18]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx17.png
  [19]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx18.png
  [20]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx19.png
  [21]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx20.png
  [22]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx21.png
  [23]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx22.png
  [24]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx23.png
  [25]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx24.png
  [26]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx25.png
  [27]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx26.png
  [28]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx27.png
  [29]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx28.png
  [30]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx29.png
  [31]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx30.png
  [32]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx_code.png
  [33]: https://qqwing.com/
  [34]: http://7xi3e9.com1.z0.glb.clouddn.com/dlx31.png
  [35]: http://www.spoj.com/problems/NQUEEN/
  [36]: https://rafal.io/posts/solving-sudoku-with-dancing-links.html
  [37]: http://wiki.dreamrunner.org/public_html/Algorithms/TheoryOfAlgorithms/dancing-links.html
  [38]: https://arxiv.org/pdf/cs/0011047v1.pdf
  [39]: http://garethrees.org/2015/11/09/exact-cover/
  [40]: http://www.cnblogs.com/grenet/p/3145800.html
  [41]: https://vjudge.net/contest/141053
  [42]: http://pan.baidu.com/s/1mityuZA
  [43]: http://pan.baidu.com/s/1nv2PtRN
  [44]: http://pan.baidu.com/s/1o8hOBHo
  [45]: http://pan.baidu.com/s/1skGEft7
  [46]: http://pan.baidu.com/s/1sl8gTuX