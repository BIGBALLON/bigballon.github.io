---
layout: post
title: Linear algebra(1)
categories: [math]
tags: [math]
---

## Vector Spaces (向量空间)

---

初浅来说，线性代数是学习作用在向量空间(Vector Spaces)的线性函数的一些共同性质。 

- Definition of **Vector Spaces**:

> A Vector space V over a field F consists of a set on which two operations are defined(addition and scalar multiplicaiton), so that the following 10 properties hold.

- **(VS -1)** $x+y \in V \text{whenever }  x,y \in V.$ [加法封闭]
- **(VS 0)** $ax \in V \text{ whenever }  a \in F \text{ and }  x \in V.$ [乘法封闭]
- **(VS 1)** $x+y=y+x \text{ for all } x,y \in V.$ [可交换]
- **(VS 2)** $(x+y)+z=y+(x+z) \text{ for all } x,y,z \in V.$ [可结合]
- **(VS 3)** $\exists \vec{0} \in V \text{ so that } x + \vec{0} = x \text{ for all }x \in V.$ [有加法单位元素]
- **(VS 4)** $\text{ for each } x \in V, \exists{y}\in V  \text{ s.t.} x + y = \vec{0}.$ [有加法反元素]
- **(VS 5)** $\text{ for each } x \in V, 1x=x. \text{ Here } 1 \in F.$ [有乘法单位元素]
- **(VS 6)** $(ab)x = a(bx) \text{ for all } a,b \in F \text{ and } x \in V.$ [分配率]
- **(VS 7)** $a(x+y) = ax+by \text{ for all } a \in F \text{ and } x,y \in V.$ [分配率]
- **(VS 8)** $(a+b)x = ax+bx \text{ for all } a,b \in F \text{ and } x \in V.$ [分配率]
    
- Remarks:
    - The elements of the field $F$ are called saclars.
    - The elelments of the $V$ are called vectros.


### Theorem1.1 

> $\text{If } x,y,z \text{ are in } V, V \text{ such that } x+z=y+z, \text{ then } x = y $ (消去定理)

### Theorem1.2

> $V$ is a vector space . Then   
> (a) $0x = \vec{0} \text{ for all } x \in V (0\in F, \vec{0} \in V)$  
> (b) $(-a)x = -(ax) = a(-x) \text{ for } a \in F \text{ and } x \in V.$   
> (c) $a\vec{0} = \vec{0} \text{ for } a \in F.$   

## Subspaces (子空间)

---

- Definition of Vector Subspaces:

> Let $V$ be a VS over a field $F$. Then $W \subset{V}$ is called a subspace of $V$ if $W$ is a VS over the $F$ under the operations of addition and SM defined on $V$.

- Remarks:
    - $V$ and $ \{ \vec{0} \} $ are subspaces of $V$.  
    - (VS 1-2,5-8) 对$W$来说会自动满足，因此检查$W$是否是subspaces只需要检查(VS -1,0,3,4)  
    - 事实上，只需检查(VS-1,0,3)即可。若$V \neq \emptyset  $,则只需要检查(VS-1,0)  

### Theorem1.3

> $W \subset V$, where $V$ is a VS. Then $W$ is subspace of $V  \Leftrightarrow$    
> (a) $\vec{0} \in W.$  (VS-3)  
> (b) $x+y \in W \text{ whenever } x,y \in W.$    (VS-1)  
> (c) $cx \in W \text{ whenever } c \in F,x \in W.$   (VS-0)  


### Theorem1.4

> Any intersection(交集) of subspace of a vector space is a subspace of $V$.


##  Linear Combinations and Systems of Linear Equations (线性组合与线性方程组)

---

Definition of **linear combination**:

> $V$: A vector space.  $S \subset V, S \neq \emptyset$.  
> A vector $v \in V$ is called linear combination of vectors of $S$    
> if $$\exists u_{i} \in S, a_{i} \in F, \text{ s.t. } v = \sum_{i=1}^{n}{a_{i}u_{i}}$$

Definition of **span(张成)**:

> $V$: A vector space.  $S \subset V, S \neq \emptyset$.  
> The span of S = span(S) = The set of all l.c. of the vectors of  
> $$S=\left \{  \sum_{i=1}^{n}{a_{i}u_{i}: u_{i} \in S, a_{i} \in F, i = 1,2,...,n, n \in N}\right \}$$

### Theorem1.5

> (i) Span($S$): is a subspace of $V$  
> (ii) $W$: is a subspace of $V$  and $S \subset W$  
> Then, $ W \supset $ Span($S$)   


##  Linear Dependence and Linear Independence

---

> (i) A subset S of a vector space V is called l.d. if $\exists$ distinct vectors $$u_{i}, i=1,...,n$$ in S and scalars $$a_{i},i=1,2,...,n$$, not all zero, s.t. $$\sum_{i=1}^{n}{a_{i}u_{i}}=0$$  
> (ii) If S is not l.d. then S is called l.i.(For any finite number of distinct vectors in S and $$\sum_{i=1}^{n}{a_{i}u_{i}}=0$$, where $$a_{i} \in F, \text{ then } a_{1} = a_{2} = ... = a_{n} = 0$$).


### Theorem1.6

> let V be a vector space, and let $$ S_{1} \subseteq S_{2} \subseteq V$$. If $S_{1} \text{is l.d.} , \text{ then } S_{2} $ is l.d.
> Cor. $$ \text{If } S_{2}  , \text{is l.i. then } S_{1} \text{ is l.i.} $$


### Theorem1.7

> S: l.i. and $v \in V-S$. Then $$S \cup \left \{  v \right \}$$ is l.d. $\Leftrightarrow v \in Span(S),$  
> or equivalently $$v \notin Span(S) \Leftrightarrow S\cup \left \{  v \right \}$$ is l.i.

一个线性无关的集合S,多加一个向量 $v \notin S$,则新的集合是否是i.d，取决于v是否在Span($S$).



##   Bases and Dimension (基低和维度)

---

一个向量空间的building block 是一组 linearly independent generating(l.i.g.) set，就如基本粒子之于物理世界。本章节是要找一组“不多”也“不少”的集合能生成一个向量空间。此“恰好”的集合称为此向量空间的基底(basis)，此基底的元素的个数称为此向量空间的维度(dimention)

Definition of **Basis**:

> A basis B for a vector space V is a l.i. subset of V that generates V

向量空间V的一个基低是它的一个线性无关的子集合，且这个子集合能够生成V

### Theorem1.8

> $V$: a vector space   
> $B$: $$\{u_{1},u_{2},...,u_{n}\}$$, Then   
> $B$ is a basis for $V$ $\Leftrightarrow $   
> each $v \in V $. $$\exists ! a_{i} \in F, 1 \leq i \leq n$$, s.t. $$v = \sum_{i=1}^{n}{a_{i}u_{i}}$$.

- Remark:
    - 一个向量空间若其基底个数是有限的，则上述定理显示 $$V \cong F_{n}$$
    - 这里主要讨论的是有限基底得到向量空间.
    - 一个向量空间基底的元素个数不一定是有限的，但theorem1.9告诉我们，若此向量空间可以由一有限集合所生成，则此向量空间必有一个有限基底。

### Theorem1.9

> Let $V$ = Span($S$), where #$ (S)< \infty$. Then  
> some subsets of $S$ is a basis for $V$. Hence $V$ has a finite basis.


### Theorem1.10 (Replacement Theorem)

> Let V = Span(G), where #(G) = n  
> Let L is a l.i. subset of V with #(L) = m.  
> $\Leftrightarrow$  
> (i) $m \leq n$ (由G span出来的 vector space 中的线性无关的向量个数不可能大于G集合的个数)  
> (ii) $\exists H \subset G$, #(H) = n - m, s.t. Span($L\cup H$)=V 

由定理可得，若一向量空间是由有限多个向量所张出的空间，则此向量空间不可能含有一个无限的线性无关的集合。


### Theorem1.11

> $W$: a subspace of $V$, where $dim(V) < \infty$, Then  
> (i) $dim(W) \leq dim(V) $   
> (ii) If $dim(W) = dim(V)$, then $W=V$.

