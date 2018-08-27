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

<!-- more -->

# Succinct Tree

Goal: represent the data in close to optimal space, while supporting the operations efficiently.

这里就要谈到 `Jacobson, FOCS ‘89` 提出来的方法。

## Heap-like notation for a binary tree

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
R  : 1 2 3 4   5 6   7        8                 // use r to indicate the index
bit: 1 1 1 1 0 1 1 0 1  0  0  1  0  0  0  0  0
S  : 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  // use s to indicate the index
```

这里需要介绍针对该 bit 序列，所需要的两个基本操作：
{% note warning %} 

`rank(s)`: Count the number of element in S less or equal than s.
`select(i)`: Find the i-th smallest element in S.

1. `rank(s)`: 其实就是在 S 序列编号范围 [1,s]，bit 序列中 1 的个数。可以看到，rank(6) = 5, rank(9) = 7。这里可以理解为 S[s] 所在的 1 bit，在 R 中对应的编号。rank 是从 `S 到 R` 的映射。
2. `select(i)`: 在 S 序列编号下，在 bit 序列中找到第 i 个 1 所在的编号。可以看到，select(5) = 6, select(7) = 9。这里可以理解成为 R[i] 所在的 1 bit，在 S 中对应的编号。select 是 `R 到 S` 的映射。

{% endnote %}

这两个操作是互补的。可以看到 rank(select(5)) = 5. select(rank(9)) = 9。当然这种互补只对 internal node 成立。对于 external node 是不成立的。比如 external node 11：rank(13) = 8, select(8) = 12。

### left, right child and parent

有了 rank 和 select 这两个基本操作，我们就可以在该 `bit 序列`进行 left child，right child 和 parent 的操作了。

对于 internal node n:

```c
R  : 1 2 3 4     5  6     7            8                           // use r to indicate the index
bit: 1 1 1 1  0  1  1  0  1   0    0   1   0    0    0    0    0
S  : 1 2 3 4 (5) 6  7 (8) 9 (10) (11) 12 (13) (14) (15) (16) (17)  // use s to indicate the index, () means this number is not belonging to data set S.

假设node是如下结构：
struct node {
  bit val;
  int r; // value in R
  int s; // value in S
}

有如下关系：
  rank(n.s) = n.r
select(n.r) = n.s

-  left-child(n).s = 2 * rank(n.s)     = 2 * n.r     // 这里看出 node 的 r 编号乘二，得到其 left child 的 s 编号
- right-child(n).s = 2 * rank(n.s) + 1 = 2 * n.r + 1 // 这里看出 node 的 r 编号乘二加一，得到其 right child 的 s 编号
-      parent(n).s = select(n.s / 2)

parent 可以推出来。对于 left-child，有：
       left-child(n).s      = 2 * n.r
       left-child(n).s / 2  = n.r           // 这里看出 node 的 s 编号直接除以二，得到其 parent node 的 r 编号
select(left-child(n).s / 2) = select(n.r)
select(left-child(n).s / 2) = n.s
对 right-child 同理。

简单看来就是:
-  left-node(n).s = S[2 * n.r]
- right-node(n).s = S[2 * n.r + 1]
-     parent(n).r = R[n.s / 2]

```

{% note success %} 

**Left Child:**

internal node 6 (bit 序列中，第 6 个 1 bit 所在 node, R 中编号为 6 的 node)。
- rank(6.s) = rank(7) = 6
- left-node(6).s = 2 \* rank(6.s) = 2 \* 6 = 12
- S 编号中，12 对应的 node 是 R 中编号为 8 的 node。

{% endnote %}


{% note success %} 
**Right Child**
internal node 4 (bit 序列中，第 4 个 1 bit 所在 node, R 中编号为 4 的 node)。
- rank(4.s) = rank(4) = 4
- right-node(4).s = 2 \* rank(4.s) + 1 = 2 \* 4 = 8 + 1 = 9
- S 编号中，9 对应的 node 是 R 中编号为 7 的 node。
{% endnote %}

{% note success %} 
**Parent**
internal node 8 (bit 序列中，第 8 个 1 bit 所在 node, R 中编号为 8 的 node)。
- select(8.r) = select(8) = 12
- parent(8).r = select(8.r) / 2 = 12 / 2 = 6
- R 编号中，6 对应的 node 是 S 中编号为 7 的 node。
{% endnote %}

## Level Order Unary Degree Sequence (LOUDS)

下面对于任意的 tree 进行编码。
首先对已有的 tree 的 root 之上，添加一个 super root。给每个节点编码的方式也很简单：`该节点子节点的个数个 “1” 加上一个 “0”`。然后按照层序遍历的方式，将这些编码组成一个 `bit 序列`。 

![3](3.png)

![6](6.png)

![4](4.png)

![5](5.png)


LOUDS 是一个 bit vector。我们需要如下的基本操作

> `rank1(i)` -- returns number of '1' in the range [0, i)
> `rank0(i)` -- returns number of '0' in the range [0, i). `rank0(i) = i - rank1(i)`
> `select1(rnk)` -- returns position of rnk-th '1' in the LOUDS string, rnk = 1, 2, 3, ...
> `select0(rnk)` -- returns position of rnk-th '0' in the LOUDS string, rnk = 1, 2, 3, ...

这四个基本操作可以在 O(1) 时间复杂度下实现，这个后面我们再聊实现。这些操作可以衍生出下面的对树的操作：

Different ways of tree node numbering for LOUDS are possible, Memoria uses the simplest one. Tree node positions are coded by '1'.

- `node_num = rank1(i)` -- gets tree node number at position i;
- `i = select1(node_num)` -- finds position of a node in LOUDS given its number in the tree.

Having this node numbering we can define the following tree navigation operations:

- `fist_child(i) = select0(rank1(i)) + 1` -- finds position of the first child for node at the position i;
- `last_child(i) = select0(rank1(i) + 1) - 1`-- finds position of the last child for node at the position i;
- `parent(i) = select1(rank0(i))` -- finds position of the parent for the node at the position i;
- `children(i) = last_child(i) - first_child(i)` -- return number of children for node at the position i;
- `child(i, num) = first_child(i) + num` -- returns position of num-th child for the node at the position i, num >= 0;
- `is_node(i) = LOUDS[i] == 1 ? true : false` -- checks if i-th position in tree node.

Note that navigation operations only defined for positions i for those `is_leaf(i) == true`.

![7](7.png)

比如我想找 `node_num = 8` 的 first child 11，last child 12，parent 4：

```c
       node_num = 8
i =  select1(8) = 12

first_child(12) = select0(rank1(12)) + 1
                = select0(8) + 1
                = 19
      rank1(19) = 11

 last_child(12) = select0(rank1(12) + 1) - 1
                = select0(8 + 1) - 1
                = select0(9) - 1
                = 21 - 1
                = 20
      rank1(20) = 12

     parent(12) = select1(rank0(12))
                = select1(4)
                = 5
       rank1(5) = 4
```


# Reference
[Space-efficient Static Trees and Graphs](https://www.computer.org/csdl/proceedings/focs/1989/1982/00/063533.pdf)
[SuRF: Practical Range Query Filtering with Fast Succinct Tries](https://db.cs.cmu.edu/papers/2018/mod601-zhangA-hm.pdf)
[Advanced(Algorithmics((6EAP)](https://courses.cs.ut.ee/MTAT.03.238/2013_fall/uploads/Main/06_alg_Succinct.6up.pdf)
[Succinct Data Structures](https://cs.uwaterloo.ca/~imunro/cs840/Notes16/SuccinctDS.pdf)
[Succinct data structure](https://en.wikipedia.org/wiki/Succinct_data_structure#cite_note-jacobson1989space-4)
[Rank and Select Operations on Binary Strings (1974; Elias)](https://lra.le.ac.uk/bitstream/2381/318/4/rank-select.pdf)
[一种神奇的数据结构—小波树](http://chuansong.me/n/2035229)
[Range minimum query](https://en.wikipedia.org/wiki/Range_minimum_query)
[RRR – A Succinct Rank/Select Index for Bit Vectors](http://alexbowe.com/rrr/)