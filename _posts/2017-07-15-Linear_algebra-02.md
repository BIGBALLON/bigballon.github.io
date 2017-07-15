---
layout: post
title: Linear algebra(2)
categories: [math]
tags: [math]
---

本章主要内容：

---

- 线性变换(Linear Transformations)， 零空间(Null spaces) 与 值域(ranges)
- 线性变换的矩阵表示(The Matrix Representation of a Linear Transformation)
- 线性变换的组合(Combination of Linear Transformations ) 与 矩阵的乘法(Matrix Multiplication)
- 可逆性(Invertibility) 与 同构(Isomorphisms)
- 坐标变换矩阵(The Change of Coordinate Matrix)



## 2.1 Linear Transformations, null spaces and ranges(线性变换 零空间 与 值域)

---

- Definition of **Linear Transformations**:

> Let V and W be vector spaces. We call a function 「$T: V  \rightarrow W$」  a Linear Transformations(or Linear) from V to W   
> if for all $x,y \in v$ and $c \in F$, we have (a) $T(x+y) = T(x) + T(y)$ and (b) $T(cx) = cT(x)$.

    
- Remarks:
    - 若 $F=Q$, 则 (a) $\Rightarrow$ (b).
    - 一般情况，(a)和(b)是彼此独立的.
    - $T(0) = T(0)$.
    - $T(x-y)=T(x)-T(y)$.
    - $$T(\sum_{i=1}^{n}{a_{i}x_{i}})=\sum_{i=1}^{n}{a_{i}T(x_{i})}$$.
    - $T$ is linear $\Leftrightarrow T(cx+y) = cT(x) + T(y)$     **Important**
    - 「$I: V  \rightarrow V$」 is called the **identity transformation(相等转换)**
    - 「$$T_{0}: V  \rightarrow V T_{0}(x) = 0$$」 is called the **zero transformation(零转换)**


- Definitions of **null spaces** and **ranges**:

> 「$T: V  \rightarrow W$」is Linear.   
> (i)  N(T) = the null space(or kernel) of T. $N(T) = \{ x \in V : T(x) = 0\}$.  
> (ii) R(T) = the range(or image) of T. $R(T) = \{ y \in W : \exists x \in V \text{ with } T(x) = y\}$.  

### Theorem2.1 

> 「$T: V  \rightarrow W$」, where V, W are vector spaces and T is linear.    
> $\Rightarrow $ R(T) and N(T) are subspaces of W and V, respectively.

### Theorem2.2

> 「$T: V  \rightarrow W$」, where V, W are vector spaces and T is linear.   
> If $$\beta = \{ v_{1}, v_{2}, ... v_{n}\} $$ if basis for V, then  
> $$R(T) = Span(T(\beta)) = Span(\{ v_{1}, v_{2}, ... v_{n}\})$$

### **Theorem2.3 (Dimension Thm. or Rank-nullity Thm.)** 

> 「$T: V  \rightarrow W$」, where V, W are vector spaces and T is linear.   
> If dim(V) $< \infty$, then **nullity(T) + rank(T) = dim(V)**  
> **where nullity(T) = dim(N(T)) and rank(T) = dim(R(T)).**


### Theorem2.4

> 「$T: V  \rightarrow W$」, where V, W are vector spaces and T is linear.   
> Then T is one to one.  $\Leftrightarrow$ $N(T) = \{ 0 \}$


### Theorem2.5

> 「$T: V  \rightarrow W$」, where V, W are vector spaces and T is linear.   
> Let dim(V) = dim(W) $ < \infty$, then  
> (i) T is one to one.  
> (ii) T is onto.  
> (iii) rank(T) = dim(V) = dim(W)

### Theorem2.6

> Let $$\{ v_{1},v_{2},...v_{n} \}$$ be basis for V. $$T(v_{i})=w_{i}, i = 1,2,...,n$$,   
> then $\exists ! $ $T: V  \rightarrow W$ s.t.  $$T(v_{i})=w_{i} \text{ for } i = 1,2,...,n$$.


## 2.2 The Martix Representation of Linear Transformation (线性变换的矩阵表示)

---

- Definition of **ordered basis**:

> An ordered basis of V is a finite sequence of linearly independent vectors in V that generates V.

- Definition of **the coordinate vector of $x$ relative to $\beta$**:

> Let $$\beta = {u_{1},u_{2},...u_{n}}$$ be an ordered basis for V. For $x \in v$, let $$a_{1},a_{2},a_{n}$$ be the unique scalars s.t. $$x = \sum_{i=1}^{n}{a_{i}u_{i}}$$.  
> We define the coordinate vector of $x$ relative to $\beta$, denoted $$[x]_{\beta}=
\begin{pmatrix}
a_{1}\\ 
a_{2}\\ 
.\\
.\\
.\\
a_{n}\\ 
\end{pmatrix}$$.

- Remarks:
    -  $$[u_{i}]_{\beta}=e_{i}$$.
    -  $T: V  \rightarrow F^{n}$ by $$T(x)=[x]_{\beta}$$ is a linear trainsformation.

- Definition of **the matrix representation(矩阵表示法)**:：

> $$\beta = \{ u_{1},u_{2},...u_{n} \}$$ and $$\gamma = \{ w_{1},w_{2},...w_{m} \}$$ be ordered bases for V and W respectively.  
> Let $$T(v_{j})=\sum_{i=1}^{n}{a_{ij}w_{i}} \Rightarrow [T(v_{j})]_{r}=
\begin{pmatrix}
a_{1j}\\ 
a_{2j}\\ 
.\\
.\\
.\\
a_{mj}\\ 
\end{pmatrix} ,1 \leq j \leq n$$ and set $$A = (a_{ij})_{m \times n}$$.  
> The matrix $A$ defined above is called the matrix representation of T in the ordered bases $\beta$ and $\gamma$ and write $$A=[T]_{\beta}^{\gamma}$$.  
> If $V = W$ and $\beta = \gamma$, then we write $$A=[T]_{\beta}$$.  

### Theorem2.7



