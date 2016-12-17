---
layout: post
title: CPE Solution
categories: [icpc]
tags: [icpc]
---

## 2016-10-04 CPE

---

### 11192: Group Reverse

> 分组，翻转

### 1587: Box

> 题意： 多组数据，每组数据给定6个长方形的长和宽，问，这6个长方形是否能拼成长方体
> 分析：

- 分情况讨论：

1. 3种不同长度的边，每种边各4条$(1,2)(2,3)(3,1)$
2. 2种不同长度的边，$(1,2)(2,2)(2,2)$
3. 正方体，$(2,2)(2,2)(2,2)$

- 排序：
对所有边进行降序排序，两两比较，全部当作第一种情况考虑，因为排序的缘故，只有一种配对可能。
PS：读入的时候需要将进行适当的交换(短边在前，长边在后)

```
#include <iostream>
#include <cstring>
#include <cstdio>
#include <map>
#include <algorithm>
using namespace std;

struct pallet{
    int x, y;
}p[11];

int cmp( pallet a, pallet b ){
    if( a.x == b.x )
        return a.y < b.y;
    return a.x < b.x;
}

int ok(){
    if( p[0].x != p[1].x || p[0].y != p[1].y ) return 0;
    if( p[2].x != p[3].x || p[2].y != p[3].y ) return 0;
    if( p[4].x != p[5].x || p[4].y != p[5].y ) return 0;

    if( p[0].x == p[2].x && p[0].y == p[4].x && p[2].y == p[4].y ) return 1;

    return 0;
}
int main(){
    while( ~scanf( "%d %d", &p[0].x, &p[0].y ) ){

        if( p[0].x > p[0].y ) swap( p[0].x, p[0].y );
        for( int i = 1; i < 6; ++i ){
            scanf( "%d %d", &p[i].x, &p[i].y );
            if( p[i].x > p[i].y ) swap( p[i].x, p[i].y );
        }
        sort( p, p + 6, cmp );
        if( ok() ) puts( "POSSIBLE" );
        else puts( "IMPOSSIBLE" );
    }

    return 0;
}
```

### 10415: Eb Alto Saxophone Player

> 题意： 萨克斯有$c,d,e,f,g,a,b,C,D,E,F,G,A,B$个音调，每个音调需要若干个手指按压来实现，给定一个曲谱，问每个手指头按了多少次？
> 分析： 看清题意简单模拟即可


### 11344: The Huge One

> 大数除以小数，简单模拟

### 12694: Meeting Room Arrangement

> greedy..时间安排问题，对结束时间升序排序，然后$O(n)$扫一遍

### 439: Knight Moves

> 骑士遍历问题，裸bfs

### 11624: Fire!

> bfs预处理 + bfs or 两个bfs合并(多源BFS)

```
#include <iostream>
#include <cstring>
#include <cstdio>
#include <queue>
#include <algorithm>
using namespace std;

int dir_x[] = { 1,0,0,-1 };
int dir_y[] = { 0,1,-1,0 };
char g[1111][1111];
char f[1111][1111];
int ti[1111][1111];
int vis[1111][1111];
int sx, sy;
int n, r, c;
struct node{
    int x, y;
    int step;
    node( int xx, int yy, int ss ){
        x = xx;
        y = yy;
        step = ss;
    }
};
queue<node> fq;

void pre(){
    memcpy(f,g,sizeof(g));
    while( !fq.empty() ){
        node t = fq.front();
        fq.pop();
        for( int i = 0; i < 4; ++i ){
            int xx = t.x + dir_x[i];
            int yy = t.y + dir_y[i];
            int ss = t.step + 1;
            if( xx > r || xx < 1 || yy > c || yy < 1 ) continue;
            if( f[xx][yy] == '#' ) continue;
            if( f[xx][yy] == 'F' ) continue;
            f[xx][yy] = 'F';
            fq.push( node(xx,yy,ss) );
            ti[xx][yy] = ss;
        }
    }
}
int bfs(){
    queue<node> q;
    q.push( node(sx,sy,0) );
    vis[sx][sy] = 1;
    while( !q.empty() ){
        node cur = q.front();
        q.pop();
        for( int i = 0; i < 4; ++i ){
            int xx = cur.x + dir_x[i];
            int yy = cur.y + dir_y[i];
            int ss = cur.step + 1;
            if( vis[xx][yy] ) continue;
            if( g[xx][yy] == '#' ) continue;
            if( g[xx][yy] == 'F' ) continue;
            if( ti[xx][yy] != -1 && ti[xx][yy] <= ss ) continue;
            if( g[xx][yy] == 0 ) return ss;
            q.push( node(xx,yy,ss) );
            vis[xx][yy] = 1;
        }
    }
    return 0;
}
int main(){
    scanf( "%d", &n );
    while( n-- ){
        scanf( "%d %d", &r, &c );
        memset( g, 0, sizeof(g) );
        memset( ti,-1,sizeof(ti) );
        memset( vis,0,sizeof(vis) );
        while(!fq.empty()) fq.pop();
        for( int i = 1; i <= r; ++i ){
            getchar();
            for( int j = 1; j <= c; ++j ){
                scanf( "%c", &g[i][j] );
                if( g[i][j] == 'F' ){
                    fq.push(node(i,j,0));
                    ti[i][j] = 0;
                }
                if( g[i][j] == 'J' ){
                    sx = i;
                    sy = j;
                }
            }
        }
        pre();
        int cnt = bfs();
        if( cnt ) printf( "%d\n", cnt );
        else puts( "IMPOSSIBLE" );
    }

    return 0;
}
```