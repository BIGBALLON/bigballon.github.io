---
layout: post
title: Linear algebra(1)
categories: [math]
tags: [math]
---

## Vector Spaces (向量空间)

---

初浅来说，线性代数是学习作用在向量空间(Vector Spaces)的线性函数的一些共同性质。 

- Definition of Vector Spaces:

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
    - (VS 1-2,5-8) 对W来说会自动满足，因此检查W是否是subspaces只需要检查(VS -1,0,3,4)  
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

Defination of **linear combination**:

> $V$: A vector space.  $S \subset V, S \neq \emptyset$.  
> A vector $v \in V$ is called linear combination of vectors of $S$    
> if $$\exists u_{i} \in S, a_{i} \in F, \text{ s.t. } v = \sum_{i=1}^{n}{a_{i}u_{i}}$$

Defination of **span(张成)**:

> $V$: A vector space.  $S \subset V, S \neq \emptyset$.  
> The span of S = span(S) = The set of all l.c. of the vectors of  
> $$S=\left \{  \sum_{i=1}^{n}{a_{i}u_{i}: u_{i} \in S, a_{i} \in F, i = 1,2,...,n, n \in N}\right \}$$
