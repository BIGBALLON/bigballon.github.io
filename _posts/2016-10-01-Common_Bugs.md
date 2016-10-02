---
layout: post
title: Common Bugs in C Programming
categories: [C]
tags: [C]
---



Most of the contents are directly from or modified from Prof. [Liu Pangfeng’s blog][1]. Most credits should go to him. 

For all the following problems, answer the output message of the code, unless they are specified differently. If there are any exception(s) (or segmentation faults), indicate where it is (or they are). Most importantly, you need to explain the reason. 


### Problem 1:

```
//case 1
#include <string.h>
int main(void)
{
  char *start = "this is a string";
  char *start2 = strtok(start, " ");
  return 0;
}
```

```
//case 2
#include <string.h>
int main(void)
{
  char start[] = "this is a string";
  char *start2 = strtok(start, " ");
  start2 = "this is a string";
  start2[4] = '\0';
  return 0;
}
```

What happens and why? 

#### Hint 1:


Maybe you can get an answer from [here][2]， [here][3] and [here][4].     

```
"this is a string" in char *start = "this is a string" 
is stored in the code segment。
It can not be modified, so the program will cause a runtime error.  
For case 1, modified ``char *start``to ``char start[]``
```

### Problem 2:

```
#include <stdio.h>
int division(int *a, int *b)
{
  return *a/*b /* a simple division */;
}
int main()
{
  int a = 6;
  int b = 2;
  int *aptr = &a;
  int *bptr = &b;
  printf("%d\n", division(aptr, bptr));
}
```

What's wrong? How to fix it? 

#### Hint 2:

```
modify return *a/*b /* a simple division */;  
to return (*a)/(*b) /* a simple division */;
```

### Problem 3:

```
#include <stdio.h>
#include <string.h>
int main(void)
{
  char string[] = "this is a string";
  char *start;
  start = string;
  start = strtok(start, " ");
  while (start != NULL) {
    printf("%s\n", start);
    start = strtok(NULL, " ");
  }
  start = string;
  start = strtok(start, " ");
  while (start != NULL) {
    printf("%s\n", start);
    start = strtok(NULL, " ");
  }
  return 0;
}
```

Show output and explain the difference of the two loops. 

#### Hint 3:

See the definition of function [strtok()][5] 


### Problem 4:

```
#include <stdio.h>
int main(void)
{
  FILE *fp;
  char c;
  int count;
  int i;
  fp = fopen("file", "wb");
  for (i = 0; i < 256; i++)
    fputc(i, fp);
  fclose(fp);
  fp = fopen("file", "rb");
  count = 0;
  while ((c = fgetc(fp)) != EOF)
    count++;
  printf("count = %d\n", count);
  return 0;
}
```

Explain why one is missing. 

#### Hint 4:

Check the ASCII number of the EOF

### Problem 5:

```
#include <stdio.h>
int main()
{
  float a = 1.134;
  float b = 3.402;
  if (a * 3 == b)
    printf("yes");
  else
    printf("no");
}
```

What happens and why? 

#### Hint 5:

```
printf( "\n%.10f %.10f", a*3, b ); 
then you maybe find the difference.
```

### Problem 6:

```
#include <stdio.h>
int main()
{
  long int lab_tel = 035731603;
  printf("my lab’s telephone number is %ld\n", lab_tel);
  return 0;
}
```

Why is our lab number incorrect? 

#### Hint 6:

Octal & Decimal

### Problem 7:

```
#include <stdio.h>
int main()
{
  int a[10];
  if (a == &a)
    printf("yes\n");
  else
    printf("no\n");

  if (a + 1 == &a + 1)
    printf("yes\n");
  else
    printf("no\n");
}
```

What happens and why? 

#### Hint 7:

```
printf("%d\n%d\n",&a,&a+1);
```

### Problem 8:

```
#include <stdio.h>
int main(void)
{
  FILE *fp;
  fp = fopen("file", "w");
  fputs("hello\n", fp);
  fputs("hello", fp);
  fputs("hello\n", fp);
  fclose(fp);
  return 0;
}
```

Answer the lengths of “file” in Unix and Windows, and explain. 

#### Hint 8:

```
Windows: \CR\LF
Unix: \LF
```

### Problem 9:

```
#include <stdio.h>
int main(void)
{
  FILE *fp;
  char c;
  fp = fopen("file", "wb");
  for (c = 0; c < 256; c++) {
    fputc(c, fp);
  }
  fclose(fp);
  return 0;
}
```

#### Hint 9: 

NEVER NEVER run this. Otherwise, your hard disk will crash.   
Just tell what is wrong with this program. 


### Problem 10:

```
#include <stdio.h>
#define inc(x) ((x)++)
#define square(x) (x * x)
int main()
{
  int i = 3;
  int j = 4;
  printf("%d\n", square(i + j));
  printf("%d %d\n", square(inc(i)), i);
}
```

Explain the result, and how to fix it. 

### Problem 11:

```
struct csie {
  char c;
  short s;
  int i;
  double e;
};  
struct ceis {
  char c;
  double e;
  int i;
  short s;
};  
int main(void)
{
  printf("csie = %d\n", sizeof(struct csie));
  printf("ceis = %d\n", sizeof(struct ceis));
  return 0;
}
```

Explain the result.   
Hint: this is very very important to the program development in our lab. 

### Problem 12:

```
#include <stdio.h>
#include <string.h>
int main(void)
{
  char source[] = "This is a string.";
  char destination[4];
  int i = 5;
  strcpy(destination, source);
  printf("i is %d\n", i);
  printf("source is [%s]\n", source);
  printf("destination is [%s]\n", destination);
  return 0;
}
```

What happens and why? How to fix it? 

### Problem 13: (The examples are given by Ting-Fu Liao.)

```
/// header.h
#include <stdio.h>
static int val = 0;
void set(int x) ;
```

```
/// impl.c
#include "header.h"
void set(int x)
{ 
  val = x ;
}
```

```
/// main.c
#include "header.h"
int main() {
  set(100);
  if ( val == 100 ) 
    printf("val == 100\n");
  else
    printf("val != 100\n");
  return 0;
}
```
Separate them into three files. What happens and how to fix it? 


#### Hint 13: 

You should know External variable.

### Problem 14:

```
#include <stdio.h>
int main()
{
  char filename[80];
  FILE *fp;
  printf("input file name: ");
  fgets(filename, 79, stdin);
  fp = fopen(filename, "r");
  // try assert(fp != NULL);
  fclose(fp);
}
```

Why can’t you open the file? How to fix it. 

#### Hint 14: 

See the definition of [fgets()][6]

### Problem 15:

```
int main()
{
  int i = 2147483647;
  unsigned int ui = 2147483647;
  if (i + 1 < 0)     
    printf("i + 1 < 0\n");   
  if (ui + 1 > 0)
    printf("ui + 1 > 0\n");
  if (ui + 1 > i + 1)
    printf("ui + 1 > i + 1\n");
  return 0;
}
```

why?

### Problem 16:

```
int main()
{
  unsigned int ui = 2147483647;
  if (ui + 1 > 0)
    printf("ui + 1 > 0\n"); 
  if (ui + 1 < -1)
    printf("ui + 1 < -1\n");
  return 0;
}
```

why?

### Problem 17:

```
#include <stdio.h>
int main()
{
  int i = -13;
  if ((i / 2) == (i >> 1))
    printf("yes\n");
  else
    printf("no\n");
  return 0;
}
```

why?

### Problem 18:

```
// for qsort, read http://www.cplusplus.com/reference/clibrary/cstdlib/qsort/
/* qsort example */
#include <stdio.h>
#include <stdlib.h>
int values[] = {-2147483640, 50, 100};
int compare (const void * a, const void * b)
{
  return ( *(int*)a - *(int*)b );
}

int main ()
{
  int n;
  qsort (values, 3, sizeof(int), compare);
  for (n = 0; n < 3 ; n++)
     printf ("%d ",values[n]);
  return 0;
}
```

What happens and why? How to fix it? 

#### Hint 18:

Integer overflow.


### Problem 19:

```
#include <stdio.h>
#include <assert.h>
int main(void)
{
  FILE *fp;
  int c;
  fp = fopen(__FILE__, "r");
  assert(fp != NULL);
  while ((c = fgetc(fp)) != EOF)
    putchar(c);
  fclose(fp);
  return 0;
}
```

What is the output? 

#### Hint 19:

use "gcc –E test.c"  to see what happens. 

### Problem 20:

```
#include <stdio.h>
#define SWAP(x, y) x ^= y ^= x ^= y

main()
{
  int i = 3;
  int j = 5;
  printf("%d\n", i);
  printf("%d\n", j);
  SWAP(i, j);
  printf("%d\n", i);
  printf("%d\n", j);
  SWAP(i, i);
  printf("%d\n", i);
}
```

What happens and why? Is strange skills good? 

#### Hint:

Don't zuosi!

### Problem 21:

```
#include <stdio.h>
main()
{
  int i = 3;
  i = i++ + ++i;
  printf("%d\n", i);
}
```

#### Hint 21: 

Try this in both Visual C++ 6.0 and gcc. 

### Problem 22:

```
#include <stdio.h>
int main()
{
  int type = 10;
  int i =10;
  switch (type) {
  case 1:
    i = 0;
    printf("i = %d\n", i);
    break;
  case 2:
    i = 4;
    printf("i = %d\n", i);
    break;
  defualt:
    i = 5;
    printf("i = %d\n", i);
    break;
  }
  return 0;
}
```

What happens ? why??? amazing?? 

### Problem 23:

```
#include <stdio.h>
int *bar(int t)
{
  int i = t;
  int *temp = &i;
  printf("temp is %d, (*temp) is %d\n", temp, *temp);
  return temp;
}

void foo(int a, int b)
{
  int i;
  int *temp = &i;
  *temp = a+b; 
}

int main()
{
  int *a;
  a = bar(10);
  printf("a is %d, (*a) is %d \n", a, *a);
  foo(10, 20);
  printf("a is %d, (*a) is %d \n", a, *a);
}
```

What happens and how to fix it? 

### Problem 24:

```
#include <stdio.h>
int main()
{
  char i = 1;
  char j;
  scanf("%d", &j);
  if (i & j)
    printf("yes.\n");
  else
    printf("no.\n");
  return 0;
}
```

Input    
3  

What happens and how to fix it? 


### Problem 25:

The sub1 below may result in a run-time error. Why?

```
int& sub1 ( int& a , int& b ){
    int c = a − b ;
    return c ;
}
```

The sub2 below does not result in a run-time error, but there may be some other
problem. What is the problem?


```
int& sub2 ( int& a , int& b ){
    int ∗ pc = new int ;
    ∗pc = a − b ;
    return (∗ pc ) ;
}
```

#### Hint 25:

stack & heap

### Problem 26:

```
#include <iostream>
#include <cstdio>
#include <map>
#include <string>
using namespace std;
typedef void(*fn)();
map<string, fn> m;
#define FuncDef(cmd) void cmd_##cmd() { printf("cmd: "#cmd"\n"); }
#define RegFunc(cmd) m[#cmd] = cmd_##cmd;
FuncDef(quit);
FuncDef(help);
int main()
{
        RegFunc(quit);
        RegFunc(help);
        string cmd;
        while ( getline(cin,cmd) ){
                if ( m.count(cmd) ) (*m[cmd])();
                else printf("Not support %s\n", cmd.c_str());
        }
        return 0;
}
```

Show the output of the translated program, and run it. Also importantly, you need to give a scenario when/where you would use it in this way. Another small case is as below. (The examples are given by Ting-Fu Liao.)

```
#define test(x) x _x=a; pr##x##f(#x" %d",_x);
#include <stdio.h>
int main(a)
{
	test(int);
	return 0;
}
```



  [1]: http://pangfengliu.blogspot.com
  [2]: http://bbs.csdn.net/topics/390440590
  [3]: http://www.cnblogs.com/skynet/archive/2011/03/07/1975479.html
  [4]: http://www.geeksforgeeks.org/memory-layout-of-c-program/
  [5]: http://www.cplusplus.com/reference/cstring/strtok/?kw=strtok
  [6]: http://www.cplusplus.com/reference/cstdio/fgets/?kw=fgets