---
layout: post
title: Something about Giraffe (II)
date: 2017-02-27 23:48
---


先解決老師留的幾個問題再說吧，23333 XD.
[Giraffe][1] 是一個將 Deep Reinforcement Learning 和 Neural Network 结合到一起的Chess AI 程式。
作者 [Matthew Lai][2] 是一個了不起的人，目前就職於 Google Deepmind.

隨著AlphaGo席捲全球，隨著Deep learning在這幾年越炒越熱，幾乎同一時間所有其他game AI都在尋求新的突破辦法或者是嘗試。

但是有些許不同的是AlphaGo由於狀態空間太大幾乎無法用傳統的heuristic function來搜尋，前些年甚至連9*9的棋盤也很難有突破，不得不說，MCTS的出現以及CNN的崛起，造就了AlphaGo的成功，另外一個不得不提的就是，AlphaGo團隊的每一位都是在這個領域研究了幾年甚至十幾年，他們應該獲得足夠的尊重，老實說，現在終於明白，其實如果僅僅讀一個碩士的話，，基本上在學術上不會有太大的建樹，但是如果要繼續讀博的話，時間，經歷，以及是否真的願意投身科研，都是需要考慮的問題，在這個浮躁而又金錢至上的社會，沉下心來搞學術的人真的不多了。


## Investigate features (363) related to bitboard (or map), rules? 


作者在bitbucket上最新的Version，總共有368個features.
大致來看確實僅僅包括一些簡單的Rule.

- number of each piece
- static exchange evaluation material tables
- check or not
- side to move
- king's position
- castle right
- White/Black pawn's position & threat $$[5*2*8]$$
- White/Black queen's position & threat $$[(5+9)*2]$$
- White/Black rook's position & threat & castle $$[((5+5+1)*2)*2]$$
- White/Black bishop's position & threat $$[((5+1)*2)*2]$$
- White/Black knight's position & threat
- Attack Map $[64*2]$


## Search nodebudget (256? Quiescence search? Probabilistic Search?), epoch moves (64? or 12?)

- 在進行TDLeaf(lambda)的training的時候，最多會走64個move, 也就是TDLeaf的$D=64$。
另外search時候的限制的節點數SearchNodeBudget確實是$256$，新版的code是$512$

- 在實際search中，使用的是Iterative Deepning，步長擴大倍數SearchNodeBudget為$4$

- Quiescence search? 答案是有用到Q-Search


```
	//NumIterations = 1000000000;
	//TDLambda = 0.5f
	//PositionsPerIteration = 1000000;
	//HalfMovesToMake = 64;  (12)
	//SearchNodeBudget = 512; (256)
	// PositionsFirstIteration = 100000;
	//const static int64_t SearchNodeBudget = 512;
	//const static float NodeBudgetMultiplier = 4.0f;
```

## Verify whether it does run Probabilistic Search?

我的理解是訓練的時候沒有Probabilistic Search，或者是可用也可不用？
因為如果沒有訓練好的net的話，使用的是static evaluation。



  [1]: https://arxiv.org/pdf/1509.01549.pdf
  [2]: http://matthewlai.ca/resume/