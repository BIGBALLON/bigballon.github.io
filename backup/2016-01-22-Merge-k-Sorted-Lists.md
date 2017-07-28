---
layout: post
title: Merge k Sorted Lists
categories: [algorithm]
tags: [leetcode,algorithm]
---

## 1. Merge Two Sorted Lists

我们先来看这个 [问题][1]：

> Merge two sorted linked lists and return it as a new list. The new list should be made by splicing together the nodes of the first two lists.

是的，这是一个非常简单链表操作问题。也许你只需要花几分种便能轻松写出代码。


## 2. Merge k Sorted Lists

我们现在来研究这个 [问题][2]：

> Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity. 

**我们假设共有 $k$ 条链表，且$k$ 条链表的结点总数为 $n$**


1. **暴力：**最直观的，我们脑海中会产生第一种做法，**暴力暴力暴暴力**  
    - 我们每次从k个链表中取出其头节点，比较之后选出其中val值最小的结点，并将该结点指向其后继结点。非常显然，，我们需要比较$nk$次，这将导致时间复杂度趋近于$O(nk)$
    - 或许你可能会有另外一种想法，按照顺序，从第1,2个链表开始，两两合并，合并用到的正是上面第一个问题所用到的``mergeTwoLists()``  函数，然而每确定一个结点仍然需要比较$k$次，而总结点数为$n$，时间复杂度仍然为$O(nk)$，并没有任何改观，事实上你应该意识到，这两种思路其实是一样的，只不过一个是横向比较，一个是纵向比较。  
2. **[最小堆][3]：** 事实上，我们每次只需要从$k$个结点中得到val值最小的结点，而并非每次都需要比较这$k$个结点，这样看来，似乎我们能找到一个能够维护最值的数据结构，来降低时间复杂度。  
    - 是的，你没有猜错，是它，就是它，我们的朋友，小哪吒。额，这个数据结构就叫做**堆$(\text{heap})$**。  
我们维护一个大小为$k$的**小顶堆**，每次pop出堆顶元素，并将其指向的链表后移，若后继结点不为空，将其push进堆，直到堆中不存在结点，算法结束。因为堆每一次modify操作只需要$O(\log{k})$的时间，所以时间复杂度降为$O(n \log{k})$，awesome。  
    - 想到**堆**，我们立马便会想到，还可以使用**优先队列**$(\text{priority_queue})$来解决这个问题，两者的效果是一样的。  
3. **分治：** 如前所述，暴力的方法有太多重复的比较，我们想到采用分治的办法来降低复杂度，是的，分而治之$(\text{Divide and   Conquer})$，我们用归并排序的思想进行归并，同样可以将[时间复杂度][4]降到$O(n \log{k})$。另外，这里可以用迭代和递归两种形式来写。  
4. 还见到了[一种方法][5]，用vector将所有的结点指针存起来，按结点val值的大小进行排序，然后将排序后的指针一次连接起来，时间复杂度是$O(n \log{n} )$，具体的就要看$n$与$k$的关系了，不过这也算是一种方法吧。  
5. 还有[一种方法][6]，用map将所有结点val值和其对应的个数映射起来，然后$O(n)$扫描，并逐个建立结点并连接起来，初一看，时间复杂度似乎是线性的，但是map的映射是需要耗时的，而结点的申请也是要耗时的，总的来说，挺巧妙的，时间复杂度应该也是在$O(n \log{k})$上下。  
  
想了想，还是放几个代码好了。  
{% highlight c++ %}
class Solution {    //priority queue
public:
    struct comp{
        bool operator()( ListNode* a, ListNode* b ){
            return a->val > b->val;
        }
    };
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        priority_queue<ListNode*, vector<ListNode*>, comp > pq;
        for( auto l: lists ){
            if( l ) pq.push( l );
        }
        ListNode* dummy = new ListNode(-1);
        ListNode* p = dummy;
        while( !pq.empty() ){
            ListNode* cur = pq.top();
            pq.pop();
            p->next = cur;
            p = p->next;
            cur = cur->next;
            if( cur ) pq.push( cur );
        }
        return dummy->next;
    }
};

class Solution {    //heap
public:
    static bool comp( ListNode* a, ListNode* b ){ return a->val > b->val; }
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        vector<ListNode*> v;
        for( auto l : lists ){
            if( l ) v.push_back( l );
        }
        make_heap( v.begin(), v.end(), comp );
        
        ListNode* dummy = new ListNode(-1), *p = dummy;
        while( !v.empty() ){
            ListNode* cur = v.front();
            pop_heap( v.begin(), v.end(), comp );
            v.pop_back();
            p->next = cur;  p = p->next;  cur = cur->next;
            if( cur ){
                v.push_back( cur );
                push_heap( v.begin(), v.end(), comp );
            }
        }
        return dummy->next;
    }
};
{% endhighlight %}

补充一下$\text{STL}$中$\text{heap}$的[操作][7]  
$\text{make_heap()}$：建堆，其中第三个参数是比较函数  
$\text{pop_heap()}$：pop_heap()不是真的把最大（最小）的元素从堆中弹出来。而是重新排序堆。它把first和last交换，然后将[first,last-1)的数据再做成一个堆  
$\text{push_heap()}$：push_heap()假设由[first,last-1)是一个有效的堆，再把堆中的新元素加进来，做成一个堆  
$\text{sort_heap()}$：sort_heap对[first,last)中的序列进行排序  


  [1]: https://leetcode.com/problems/merge-two-sorted-lists/
  [2]: https://leetcode.com/problems/merge-k-sorted-lists/
  [3]: https://leetcode.com/discuss/52745/difference-between-priority-queue-and-heap-implementation
  [4]: http://stackoverflow.com/questions/2705366/merging-k-sorted-linked-lists-analysis
  [5]: https://leetcode.com/discuss/61408/c-very-elegant-12-lines-388ms
  [6]: https://leetcode.com/discuss/79523/concise-c-solution-use-map
  [7]: http://www.cplusplus.com/reference/algorithm/