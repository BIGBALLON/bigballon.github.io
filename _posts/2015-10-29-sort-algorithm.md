---
layout: post
title: 排序算法小结
categories: [datastructures]
tags: [algorithm, data structure, sorts]
---

## 插播广告

班上一位同学要搞博客，，，来问我。。  
我就打开了很久没管过的博客，，发现数学公式貌似比以前好那么点了。  
遂发一个markdown上来看看效果，说实话效果并不算太好，当然，还能看的。  
就是这样！！！喵喵！  
另外。。。。。。标题等属性，，**yao 置顶 a**。。。。。  

---



## 本博文诞生原因

> 前几天有同学找我要排序算法的代码，说实话我已经有几百万年没写过排序了。  
电脑里找了一下发现代码都不见了，留下的也都是丑得一B的代码，不忍直视。。  
冒泡，选择这样的东西自从开始用$sort$之后就几百年没用过了。  
另外这个博客仅仅用于我自己整理我自己的排序算法代码。  
**至于找工作什么的要强行加上 函数返回值 和 $assert$。。就自己就加上吧。**  
现在也就这水平了，只能写写排序了，$splay$、 $sbtree$什么的早就写不出来了。。。  
如果有巨巨看到我的这篇博文别喷我。毕竟半退役ACM弱渣。。。  
另外本文写于 $2015.7.31$。。。。。目前没有准备更新的意思。。  

---


## 直接插入排序

直接插入排序，属于最基本的插入排序。  
基本思想就如同打扑克抓牌：  

- 寻找新抓取的牌对应的插入位置   
- 将插入点右侧的牌向右移动  
- 插入新抓取的牌   

---
> 1. 时间复杂度：  
很容易看出插入操作需要进行 $n-1$ 次。  
对于最好情况，也就是序列本身有序，如我们抓牌的顺序是 $ \{1，2，3，4，5\} $  
我们共比较了 $(n-1)$次，且没有交换次数，故时间复杂度为 $O(n)$  
对于最坏情况，也就是序列本身逆序，如我们抓牌的顺序是 $ \{5，4，3，2，1\} $  
此时比较次数为  
**$$ \sum_{i=2}^{n}\left ( i-1 \right )=1+2+3+ \cdots +n-1 = \frac{\left ( n-1 \right )n}{2}$$**  
交换次数为 $\frac{(n-1)n}{2}$  
所以总的时间复杂度约为 $O(n^2)$  
> 2. 空间复杂度:  
$O(1)$ 就不多废话了  
> 3. 稳定性：  
直接插入排序是稳定的。逐个元素依次插入，相等元素的前后顺序是不会改变的，所以显然是稳定的。  

{% highlight c++  %}

void insert_sort( int arr[], int sz ){
	int i , j , val;
	
	for( i = 1; i < sz; ++i ){
		val = arr[ i ];
		j = i - 1;
		while( j >= 0 && arr[j] > val ){
			arr[ j + 1 ] = arr[ j ];
			--j;
		}
		arr[ j + 1 ] = val;
	}
}
{% endhighlight %}

---

## 折半插入排序

很明显可以看到，，直接插入排序慢的要死（在一般情况下）。  
故有人对它进行优化。。（其实并没有什么卵用）  
直接插入排序中我们在确定插入位置的时候是逐个数进行比较。  
这里就进行了一点优化，用二分进行快速$(O(log_2^n))$定位  
（如果你还不会写二分那你可以去撞墙了）。  

> 1. 时间复杂度：  
无奈在元素的交换还是耗费了大量时间，平均的时间复杂度显然还是 $O(n^2)$  
事实上，因为二分的缘故，，，最优情况退化为$O(nlog_2^n)$  
> 2. 空间复杂度：  
$O(1)$ ，也不多废话了  
> 3. 稳定性：  
直接插入排序是稳定的，，那显然折半插入也是稳定的，，不要问我为什么。。  


{% highlight c++  %}
void b_insert_sort( int arr[], int sz ){
	int i, j, val, low, high, mid;
	
	for( i = 1; i < sz; ++i ){
		low = 0, high = i - 1;
		val = arr[ i ];
		while( low <= high ){
			mid = ( low + high ) >> 1; 
			if( val > arr[ mid ] ){
				low = mid + 1;
			}else {
				high = mid - 1;
			}
		}
		for( j = i; j > low; --j ){
			arr[ j ] = arr[ j - 1 ];
		}
		arr[ low ] = val;
	}
} 
{% endhighlight %}


## 二-路插入排序

我引用网络上好多博客都写的一句话：  

> 2-路插入排序是在折半插入排序的基础上再改进之  
 
好一个在折半插入排序的基础上再改进。。也不知道是那些博主抄来抄去还是怎么回事。  
写个烂代码根本就没有折半插入，，，还强行说自己在写“2-路插入排序”，文不对题也是NB，更猛的是下面还一群人评论，写得好，，，哪里写得好了？明显误人子弟。。
要么就写清楚自己的代码是基于折半插入排序的2路插入排序还是基于直接插入排序的2路插入排序。  
强行加一句文不对题的话是真的理解还是？？？  

看了这篇 [博客][1] 写得好，起码还有点复杂度分析，，其他那些代码是不是抄来的都不知道，复杂度分析估计博主压根不会。  

2-路插入排序需要一个辅助数组，并且这个数组是一个环状数组（循环数组）  

- 如果插入的值大于当前数组中最大的元素，则将其插入至尾部，  
- 如果插入的值大于当前数组中最小的元素，则将其插入至首部，  
- 如果插入的值在两者之间, 采用折半查找的方式,移动部分元素。  



> 1. 时间复杂度：  
虽然用了二分可以将比较的时间降为 $(O(log_2^n))$  
但是我们计算数据交换的次数为 $\frac{n^2}{8}$,所以时间复杂度还是 $O(n^2)$  
具体计算，有 $\frac{1}{2}$ 的数据不需要交换位置。   
剩下$\frac{1}{2}$ 的数据每次移动交换 $\frac{n}{2} × \frac{n}{2}$   
如果从最坏情况考虑。。还是会退化到 $O(n^2)$  
> 2. 空间复杂度：  
$O(n)$ ，需要有一个辅助数组用来存放数据  
> 3. 稳定性：  
稳定的。  
> 4. 关于取模：  
有人说这个算法的精髓在于取模，，我说如果取模都没有这个算法还搞个P，其实取模操作的耗时也是很长的，，这点在搞数论的时候深有体会。  

{% highlight c++  %}

//基于折半插入排序的2路插入排序  
void tp_insert_sort( int arr[], int sz ){
	int* d = new int[ sz ];
	d[ 0 ] = arr[ 0 ];
	int final, first, val, i, j;
	final = first = val = 0;
	
	for( i = 1; i < sz; ++i ){
		val = arr[i];
		if( val < d[ first ] ){
			first = ( first - 1 + sz ) % sz;
			d[ first ] = val;
		} else if( val > d[ final ] ){
			final = ( final + 1 + sz ) % sz;
			d[ final ] = val;
		} else{
			int low = 0, high = ( final - first + sz ) % sz;
			int end = high;
			while( low <= high ){
				int mid = ( low + high ) >> 1;
				if( val < d[ ( mid + first ) % sz ] ){
					high = mid - 1; 
				}else{
					low = mid + 1;
				} 
			}
			for( j = end; j >= high + 1; --j ){
				d[ ( j + first + 1 ) % sz ] = d[ ( j + first ) % sz ];
			}
			d[ ( high + first + 1 ) % sz ] = val;
			final = ( final + 1 + sz ) % sz;
		}
	}

	for( i = 0; i < sz; ++i ){
		arr[i] = d[ ( i + first ) % sz ];
	}
	delete [] d;
}


//直接插入排序的2路插入排序
void t_insert_sort( int arr[], int sz ){
	int* d = new int[ sz ];
	d[ 0 ] = arr[ 0 ];
	int final, first, val, i, j;
	final = first = val = 0;
	
	for( i = 1; i < sz; ++i ){
		val = arr[i];
		if( val < d[ first ] ){
			first = ( first - 1 + sz ) % sz;
			d[ first ] = val;
		} else if( val > d[ final ] ){
			final = ( final + 1 + sz ) % sz;
			d[ final ] = val;
		} else{
			int pos = ( final + 1 + sz ) % sz;
			while(  val < d[ ( pos - 1 + sz ) % sz ] ){
				d[ ( pos + sz ) % sz ] = d[ ( pos - 1 + sz) % sz ];
				pos = ( pos - 1 + sz ) % sz;
			}
			d[ ( pos + sz ) % sz ] = val;
			final = ( final + 1 + sz ) % sz;
		}
	}

	for( i = 0; i < sz; ++i ){
		arr[i] = d[ ( i + first ) % sz ];
	}
    delete [] d;
}

{% endhighlight %}

---

## 表插入排序

这东西没什么用，，就不说了。其实是我不会。。。  

{% highlight c++  %}
#define SIZE 100
#define MAX 0x7fffffff
typedef struct{
	int val;
	int next;
}SLNode,*PSLNode; 
typedef struct{
	SLNode num[ SIZE ];
	int len;
}SLinkList, *PSLinkList;

int init_link( PSLinkList Slist, int arr[], int sz ){
	if( sz >= SIZE ){
		return 0;
	}
	Slist->num[0].val = MAX;
	Slist->num[0].next = 1;
	for( int i = 1; i <= sz; ++i ){
		
		Slist->num[i].val = arr[ i - 1 ];
		Slist->num[i].next = 0;
	}
	Slist->len = sz + 1;
	return 1;
}

int table_sort( PSLinkList Slist ){
	int len = Slist->len;
	for( int i = 2; i < len; ++i ){
		int idx = 0;
		int pos = Slist->num[0].next;
		while( Slist->num[i].val > Slist->num[pos].val ){
			idx = pos;
			pos = Slist->num[pos].next;
		}
		Slist->num[i].next = pos;
		Slist->num[idx].next = i;
	}
	return 1;
}

int arrange( PSLinkList Slist ){
	int i, idx, pos;
	pos = Slist->num[0].next;
	for( i = 1; i < Slist->len; ++i ){
		while( pos < i ){
			pos = Slist->num[pos].next;
		}
		idx = Slist->num[pos].next;
		if( pos != i ){
			std::swap( Slist->num[pos], Slist->num[i] );
			Slist->num[i].next = pos;
		}
		pos = idx;
	}
}
{% endhighlight %}

---

## 希尔排序

其实shell排序很简单，就是将原数组分成若干个子序列，  
对每个子序列分别使用直接插入排序。  
最后再对全体元素进行一次直接插入排序。  
实际上这里就是有一个叫做 **步长** 的东西。  

> 1. 时间复杂度：  
时间是和所取“增量”序列的函数密切相关，通常取的步长可以是原数组的一半，  
然后不断减小直到1为止。  
平均情况下为 $O(nlog_2^n)$ ---- 注意这里我选择的步长是不断除以2  
其实我不会计算 $shellsort$ 的时间复杂度，原谅我，我太笨了  
> 2. 空间复杂度：  
$O(1)$   
> 3. 稳定性：  
不稳定。为什么不稳定？可以这样考虑，因为对数组进行了“分组”，存在相等元素位置发生改变的情况。  

{% highlight c++  %}
void shell_sort( int arr[], int sz ){
	int i, j, d, val;	
	
	d = sz >> 1;
	while( d >= 1 ){
		for( i = d; i < sz; ++i ){
			j = i - d;
			val = arr[i];
			while( j >= 0 && arr[j] > val ){
				arr[ j + d ] = arr[ j ];
				j -= d;
			}
			if( j != i - d ){
				arr[ j + d ] = val;
			}
		}	
		d >>= 1;	
	}
}
{% endhighlight %}

---

## 基本选择排序

> 1. 时间复杂度：  
这个东西真的很慢，最近一次写这个排序估计要追溯到大一了。。  
算法总共会进行 $(n-1)$ 次扫描，每次扫描会进行 $(n-2)$ 次比较  
那么时间复杂度自然是 $(n-1) × (n-2) = O(n^2)$  
> 2. 空间复杂度：  
$O(1)$   
> 3. 稳定性：  
不稳定，可能导致相等元素相对位置发生改变。  

{% highlight c++  %}
void select_sort( int arr[], int sz ){
	int i, j, pos;
	
	for( i = 0; i < sz - 1; ++i ){
		pos = i;
		for( j = i + 1; j < sz; ++j ){
			if( arr[pos] > arr[j] ){
				pos = j;
			}
		}
		if( pos != i ) {
			std::swap( arr[pos], arr[i] );	
		}
	}
} 
{% endhighlight %}



---

## 树形选择排序

这玩意又叫做“锦标赛排序”，确实很像，就是淘汰赛咯。  
我们可以将数组看成是一颗满二叉树的叶子节点（不能够成满二叉树就补全）。  
具体算法执行步骤我简要写一下吧，如果看不懂不要打我就是了。  

> 1. 建树，用数组实现的话，树根为0号单元，建树的时候从尾往前建树  
> 2. 取得最小值，然后将最小值对应的叶子节点标记为MAXX，向上更新直到树根，得到次小值  
> 3. 取得次小值，然后将最小值对应的叶子节点标记为MAXX，向上更新直到树根，得到次次小值  
> 4. 如此反复知道排序完毕  

如果你不知道我在说什么我找了一个  [PPT][2]

> 1. 时间复杂度：  
由数组构造树需要$O(n+n)$  
选择最小关键字耗时$O(1)$，以后每次选择一个次小关键字需要消耗$O(log_2^n)$  
总的时间复杂度 $O(2n+1+(n-1)log_2^n)$ = $O(nlog_2^n)$  
> 2. 空间复杂度：  
$O(2n)$  辅助空间比较多，且需要进行对此多余的比较  
> 3. 稳定性：  
它是稳定的，如果不能理解可以举一些特例，最后会发现它并不会改变相等元素的相对位置。  

{% highlight c++  %}
#define MAXX 0x7fffffff;	//int max

void tree_select_sort( int arr[], int sz ){

	int len, i, j, idx, cnt, minn;
	len = ( sz << 1 ) - 1;
	int* tree = new int[ len ];

	//精髓所在，由后往前填充，且后面的处理也是从后往前，并且是-2	
	//如果是构造数据结构的话，需要进行节点补充。 
	for( i = sz - 1, j = 0; i >= 0; --i, ++j ){
		tree[ len - 1 - j ] = arr[ i ];
	}
	
	for( i = len - 1; i > 0; i -= 2 ){
		int pos = ( i - 1 ) >> 1;
		if( tree[ i - 1 ] < tree[ i ] ){
			tree[ pos ] = tree[ i - 1 ];	
		}else{
			tree[ pos ] = tree[ i ];	
		}
	}
	cnt = 0;
	while( cnt < sz ){
		minn = tree[ 0 ];
		arr[ cnt++ ] = minn;
		idx = len - 1;
		while( tree[ idx ] != minn ){
			--idx;
		}
		tree[ idx ] = MAXX;
		while( idx > 0 ){
			if( idx & 1 ){
				tree[ idx >> 1 ] = tree[ idx ] < tree[ idx + 1 ] ? tree[ idx ] : tree[ idx + 1 ];
				idx = idx >> 1;
			}else{
				tree[ ( idx - 1 ) >> 1 ] = tree[ idx - 1 ] < tree[ idx ] ? tree[ idx - 1 ] : tree[ idx ];
				idx = ( idx - 1 ) >> 1;
			}
		} 
	}
	delete [] tree;
}
{% endhighlight %}

---


## 堆排序

这里的堆值的是二叉堆，他其实是遵循一定规律的数组。  
最大堆：所有节点的子节点比其自身小的堆。  
最小堆：所有节点的子节点比其自身大的堆。  


> 1. 时间复杂度：
由数组构建堆的时间复杂度其实并不是 $O(nlog_2^n)$
更精确的应该是线性的$(2n-2-log_2^n) =O(n)$
排序过程中，每次重新调整最大堆需要$log_2^n$的时间，总共有$n$个元素，需要调整$n-1$次，耗时 $O((n-1)log_2^n)$
总耗时 $2n-2-log_2^n+(n-1)log_2^n = O(nlog_2^n)$
具体的证明看 《算法导论》 或者 这个 [blog][3]
> 2. 空间复杂度：
$O(1)$
> 3. 稳定性：
不稳定

{% highlight c++  %}

void max_heapify( int arr[], int i, int sz ){
	int lt = ( i << 1 ) + 1, rt = ( i << 1 ) + 2;
	int lar = 0;
	
	if( lt < sz && arr[ lt ] > arr[ i ] ){
		lar = lt;
	}else{
		lar = i;
	}
	if( rt < sz && arr[ rt ] > arr[ lar ] ){
		lar = rt;
	}
	if( lar != i ){
		std::swap( arr[ i ], arr[ lar ] );
		max_heapify( arr, lar, sz );
	}
} 
void build_maxheap( int arr[], int sz ){
	for( int i = sz >> 1; i >= 0; --i ){
		max_heapify( arr, i, sz );
	}
}

void heap_sort( int arr[], int sz ){
	build_maxheap( arr, sz );
	int len = sz - 1;
	while( len >= 1 ){
		std::swap( arr[ 0 ], arr[ len ] );
		--len;
		max_heapify( arr, 0, len );
	}
}
{% endhighlight %}


---


## 冒泡排序
 
冒泡排序没什么说的，基本没用。。  

> 1. 时间复杂度：
最原始的冒泡排序的时间复杂度是$O(n^2)$,最好情况也是$O(n^2)$
改进之后（加入了flag标记），最优情况可以优化为$O(n)$
总之，平局情况算法的时间复杂度为$O(n^2)$，一般情况也不会用冒泡排序。。。
> 2. 空间复杂度：
$O(1)$
> 3. 稳定性：
临位交换必然是稳定排序。

{% highlight c++  %}
void bubble_sort2( int arr[], int sz ){
	int i, j, flag;
	for( i = 0; i < sz; ++i ){
		flag = 0;
		for( j = 1; j < sz - i; ++j ){
			if( arr[ j - 1 ] > arr[ j ] ){
				std::swap( arr[ j ], arr[ j - 1 ] ); 
				flag = 1;
			} 
		}
		if( flag == 0 ){
			break;
		}
	}
}

void bubble_sort( int arr[], int sz ){
	for( int i = 0; i < sz - 1; ++i ){
		for( int j = sz - 1; j > i; --j ){
			if( arr[ j - 1 ] > arr[ j] ){
				std::swap( arr[ j ], arr[ j - 1 ] ); 
			}
		}
	}
}
{% endhighlight %}

---


## 快速排序

快速排序是对冒泡排序的一种改进，运用的是递归的思想  
具体步骤如下：  
1. **定基准：**从数列中跳出一个元素，作为基准"pivot"（这个基准其实还是很重要的，可直接规定，也可以使用随机化）  
2. **分区操作：**对数列进行重新排序，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。  
3. **自顶向下递归调用**  


> 1. 时间复杂度：
我只记得原来看算法导论的时候书上写了好几页，用来分析时间复杂度的，，，简单理解的话就是，总共会有$log_2^n$次递归，每次进行 $n$的比较，大概来说是 $O(nlog_2^n)$
最坏情况下时间复杂度会退化为$O(n^2)$，但是在一般情况下，快速排序是相当优秀的，不然怎么能叫做快速排序呢？
详细严谨的证明最理想的就是回去翻算法导论了。我就不BB了
> 2. 空间复杂度：
平均情况需要$O(log_2^n)$的栈空间,
最坏情况下会退化到$O(n)$的栈空间,
> 3. 稳定性：
不稳定

---

### 霍尔快排

我原来学快排的时候在想为什么叫做霍尔快排。。  
当然这是废话，因为快排这个鬼东西是霍尔发明的。  
霍尔快排取数列中的第一个数为基准，  
从尾向头扫描，遇到比基准小的数则将其和low位置交换（尽量让它往左边交换）  
从尾向头扫描，遇到比基准大的数则将其和high位置交换（尽量让它往右边交换）  
最后将基准放到中间去，这样就完成了将比基准小的数放在它左边，将比基准的的数放在它右边的操作了。  

{% highlight c++  %}
int partition( int arr[], int lt, int rt ){
	int low = lt, high = rt;
	int val = arr[ lt ];
	while( low < high ){
		while( low < high && arr[ high ] >= val ){
			--high;
		}
		arr[ low ] = arr[ high ];
		while( low < high && arr[ low ] <= val ){
			++low;
		}
		arr[ high ] = arr[ low ];
	} 
	arr[ low ] = val;
	return low;
}

void quick_sort( int arr[], int lt, int rt ){
	if( lt < rt ){
		int pivot = partition( arr, lt, rt );
		quick_sort( arr, lt, pivot - 1 );
		quick_sort( arr, pivot + 1, rt );
	}
}
{% endhighlight %}

### 算法导论上的快排

我原来一开始用的是这个快排。  
当然现在变成XX了，都不会写了。  

{% highlight c++  %}
int partition( int arr[], int lt, int rt ){
	int val = arr[ rt ];
	int i = lt - 1, j;
	
	for( j = lt; j <= rt - 1; ++j ){
		if( arr[j] <= val ){
			++i;
			std::swap( arr[ i ], arr[j] );
		}
	}
	std::swap( arr[ i + 1 ], arr[ rt ] );
	return i + 1;	
}

void quick_sort( int arr[], int lt, int rt ){
	if( lt < rt ){
		int pivot = partition( arr, lt, rt );
		quick_sort( arr, lt, pivot - 1 );
		quick_sort( arr, pivot + 1, rt );
	}
}
{% endhighlight %}

---

### 随机化快排

随机化其实就是加了一个随即选择基准，代码什么的基本一样的。  

---

### 我曾经用的快排

最初这个写法是在上海交大的某个模板上学来的。  
当时觉得好短好强悍！而且这个代码很好理解！！  

{% highlight c++  %}
void quick_sort( int arr[], int beg, int end ){
	int i = beg, j = end, x= arr[ ( beg + end ) / 2 ];
	do{
		while( arr[ i ] < x ) ++i;
		while( arr[ j ] > x ) --j;
		if( i <= j ) std::swap( arr[ i++ ], arr[ j-- ] ); 
	}while( i < j );
	if( i < end ) quick_sort( arr, i, end );
	if( j > beg ) quick_sort( arr, beg, j );	
}
{% endhighlight %}

---

### 快排的优化

快排的优化相当多，，很多我不会。。就不误人子弟乱写了。  
好像有什么三平均分区法，并行快排什么的，，不懂。  

---

## 归并排序

---

### 自顶向下的归并排序
这种归并排序是用递归实现的，也是我们最常写的归并排序。  
但是显然递归会增加额外的开销，但是迭代能省下这些开销而且迭代的效率要高一些。  

递归过程，将待排序的数组一分为二，  
将子数组一分为二。  
将子数组一分为二。。  
直到待排序的子数组只剩下一个元素为止，然后不断合并两个子数组。  

> 1. 时间复杂度：  
最原始的归并排序的时间复杂度是$O(nlog_2^n)$  
> 2. 空间复杂度：  
简单理解为$O(n)$  
实际上归并排序的空间复杂度应该是$O(log_2^n + n)$，所以还是$O(n)$  
> 3. 稳定性：  
必须稳定啊。  


{% highlight c++  %}
void merge_arr( int arr[], int lt, int mi, int rt, int d[] ){
	int i = lt, j = mi + 1, k = 0;;
	while( i <= mi && j <= rt ){
		if( arr[i] <= arr[j] ){
			d[ k++ ] = arr[ i++ ];
		}else{
			d[ k++ ] = arr[ j++ ];
		}
	}
	while( i <= mi ){
		d[ k++ ] = arr[ i++ ];
	}
	while( j <= rt ){
		d[ k++ ] = arr[ j++ ];
	}
	for( i = 0; i < k; ++i ){
		arr[ lt + i ] = d[ i ];
	}
}

void merge( int arr[], int lt, int rt, int d[] ){

	if( lt < rt ){
		int mid = ( lt + rt ) >> 1;
		merge( arr, lt, mid, d );
		merge( arr, mid + 1, rt, d );
		merge_arr( arr, lt, mid, rt, d );
	}	
}

int merge_sort( int arr[], int sz ){
	int *d = new int[ sz ];
	
	if( d == NULL ){
		return 0;
	}
	merge( arr, 0, sz - 1, d );
	delete []d;
	return 1;
}
{% endhighlight %}


### 自底向上的归并排序

这种排序实际上就把递归改为迭代。  
但是明显迭代是优越的。  
这个迭代我在大三之前只写过一次。。惭愧。  
迭代的思想：  
将数组中相邻元素两两配对，将它们变为有序。  
这样会构成 $n/2$ 组长度为 $2$ 的已排序子数组段。  
然后再将相邻的长度为2的子数组段两两配对，  
排序之后变为 $n/4$组长度为 $4$ 的已排序子数组段。  
如此反复（其实就是不断增大步长）  
直到整个数组有序即可。  


	原数组（排序前）：112 2 44 33 13 44 42 0 0 444 555 235253 0 228 92 300 8 235 2  
	第一次（步长1） ：2 112 33 44 13 44 0 42 0 444 555 235253 0 228 92 300 8 235 2  
	第二次（步长2） ：2 33 44 112 0 13 42 44 0 444 555 235253 0 92 228 300 2 8 235  
	第二次（步长4） ：0 2 13 33 42 44 44 112 0 0 92 228 300 444 555 235253 2 8 235  
	第二次（步长8） ：0 0 0 2 13 33 42 44 44 92 112 228 300 444 555 235253 2 8 235  
	第二次（步长16）：0 0 0 2 2 8 13 33 42 44 44 92 112 228 235 300 444 555 235253  



{% highlight c++  %}
int it_merge_sort( int arr[], int sz ){
	int i, lt_min, rt_min, lt_max, rt_max, next;
	int *d = new int[ sz ];
	if( d == NULL ){
		return 0;
	}
	for( i = 1; i < sz; i *= 2 ){
		for( lt_min = 0; lt_min < sz - i; lt_min = rt_max ){
			rt_min = lt_max = lt_min + i;
			rt_max = lt_max + i;
			if( rt_max > sz ){
				rt_max = sz;
			}
			next = 0;
			while( lt_min < lt_max && rt_min < rt_max ){
				d[ next++ ] = arr[ lt_min ] < arr[ rt_min ] ? arr[ lt_min++ ] : arr[ rt_min++ ];
			}
			while( lt_min < lt_max ){
				arr[ --rt_min ] = arr[ --lt_max ];
			}
			while( next > 0 ){
				arr[ --rt_min ] = d[ --next ];
			}
		}
	}
	delete []d;
}
{% endhighlight %}

---

## 写在后面

> 如果你能看到这里，，真的很感谢你，我写得这么烂的这篇博客我自己都目不忍视了。  
另外，想说明几点。  
要找资料，推荐去wiki，不要上百度，，百度百科里面的东西都是老掉牙的，几乎都是从wiki搬过来的。  
而且$wiki$的更新比较快，特别是英文版的页面。  
$wiki$的末尾还会提供非常多的论文和参考文献，非常好  
所以想详细了解最好去 $wiki$。  
还有就是去阅读一些专业的参考书籍（例如算法导论之类的）。  
一般的数据结构书写得太简单，太草率，证明什么的更是完全没有。  


  [1]: http://blog.csdn.net/caroline_wendy/article/details/24267679
  [2]: http://wenku.baidu.com/link?url=jvL9c9_BdOAE5Cst76SAxuqQFNxlnVEpWxcmRnpUggC4YGwuG4AOCHfh8ZIzYJc4QJqh8MH-B5c4vECD_f1v3rRFYamwnVRYoj9AWOJEpAm
  [3]: http://blog.csdn.net/usc_su/article/details/9256497