---
title: 'Review: SuRF: Practical Range Query Filtering with Fast Succinct Tries'
mathjax: false
comments: true
author: XS Zhao
categories:
  - review
tags:
  - leveldb
  - bloomfilter
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 47833
date: 2018-07-18 09:54:00
subtitle:
keywords:
description:
---

# Succinct Data Structure

Succinct: expressed clearly and in a few words. 中文意思就是简洁明了的。首先看一下 wiki 引用对于 succinct data structure 的描述：
> In computer science, a succinct data structure is a data structure which uses an amount of space that is "close" to the information-theoretic lower bound, but (unlike other compressed representations) still allows for efficient query operations.

Suppose that Z is the information-theoretical optimal number of bits needed to store some data. A representation of this data is called:

- `implicit`: if it takes Z+O(1) bits of space,
- `succinct`: if it takes Z+o(Z) bits of space,
- `compact`: if it takes O(Z) bits of space.

For example, a data structure that uses 2Z bits of storage is compact, Z + \sqrt{Z} bits is succinct,  Z+lgZ bits is also succinct, and Z+3 bits is implicit.

# Succinct Tree

Goal: represent the data in close to optimal space, while supporting the operations efficiently.

这里就要谈到 `Jacobson, FOCS ‘89` 提出来的方法。

## binary tree notation

### 结构扩展

首先看二叉树的示例：
![1](1.png)

对一个二叉树，我们给每一个 leaf node 添加 external node。然后，所有 external node 赋值 0，internal node 赋值 1。按照层序遍历，将所有的值生成一个 `bit 序列`。我们就使用该序列代表整个树的结构。

那么有了该序列，应该怎样实现树的基本操作呢？诸如：parent, left-children, right-children。

![2](2.png)
首先给原本的树 internal node 进行编号，编号从 1 开始，层序顺序。这样树的 8 个 node 就被依次编号为 1-8。
然后给所有 node，包括 external node 进行编号，编号从 1 开始，层序遍历。这样 17 个 node 就被依次编号为 1 - 17。

### rank & select

```c
M  : 1 2 3 4   5 6   7        8                 // use m to indicate the index
bit: 1 1 1 1 0 1 1 0 1  0  0  1  0  0  0  0  0
S  : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  // use s to indicate the index
```

这里需要介绍针对该 bit 序列，所需要的两个基本操作：

1. rank(s): 在 S 序列编号范围 [1,s]，bit 序列中 1 的个数。可以看到，rank(6) = 5, rank(9) = 7。这里可以理解为 S[s] 所在的 1 bit，在 M 中对应的编号。
2. select(i): 在 S 序列编号下，在 bit 序列中找到第 i 个 1 所在的编号。可以看到，select(5) = 6, select(7) = 9。这里可以理解成为 M[i] 所在的 1 bit，在 S 中对应的编号。

这两个操作是互补的。可以看到 rank(select(5)) = 5. select(rank(9)) = 9。当然这种互补只对 internal node 成立。对于 external node 是不成立的。比如 external node 11：rank(13) = 8, select(8) = 12。

### children

```c
M  : 1 2 3 4   5 6   7        8                 // use m to indicate the index
bit: 1 1 1 1 0 1 1 0 1  0  0  1  0  0  0  0  0
S  : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  // use s to indicate the index
```

有了 rank 和 select 这两个基本操作，我们就可以在该 `bit 序列`进行 left child，right child 和 parent 的操作了。

对于 internal node n:
- left-node(n).s  = 2 * rank(n.s)
- right-node(n).s = 2 * rank(n.s) + 1

比如：

internal node 6 (第 6 个 1 bit 所在 node, M 中编号为 6 的 node)。
- rank(6.s) = rank(7) = 6
- left-node(6).s = 2 \* rank(6.s) = 2 \* 6 = 12
- S 编号中，12 对应的 node 是 M 中编号为 8 的 node。

internal node 4 (第 4 个 1 bit 所在 node, M 中编号为 4 的 node)。
- rank(4.s) = rank(4) = 4
- right-node(4).s = 2 \* rank(4.s) + 1 = 2 \* 4 = 8 + 1 = 9
- S 编号中，9 对应的 node 是 M 中编号为 7 的 node。


更简洁的看就是：
1. left-node(n).s  = S[2 * n.m]
2. right-node(n).s = S[2 * n.m + 1]

parent(n).m     = M[n.s / 2]




# Reference
[Space-efficient Static Trees and Graphs](https://www.computer.org/csdl/proceedings/focs/1989/1982/00/063533.pdf)
[SuRF: Practical Range Query Filtering with Fast Succinct Tries](https://db.cs.cmu.edu/papers/2018/mod601-zhangA-hm.pdf)
