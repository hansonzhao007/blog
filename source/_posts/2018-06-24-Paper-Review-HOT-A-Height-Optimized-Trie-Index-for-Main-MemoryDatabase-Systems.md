---
title: >-
  Paper Review:HOT: A Height Optimized Trie Index for Main-Memory Database
  Systems
mathjax: false
comments: true
author: XS Zhao
categories:
  - review
tags:
  - index
image: 'http://hansonzhao007.github.io/blog/images/infinite2.gif'
abbrlink: 60274
date: 2018-06-24 19:34:58
subtitle:
keywords:
description:
---

# Backgroud

## [Patricia Tree or Radix Tree or Compact Prefix Tree](https://en.wikipedia.org/wiki/Radix_tree)

![Radix Tree](1.png)
A trie that each node which is the only child is merged with its parent.

## Adaptive Radix Tree (ART)

![ART](2.png)
The adaptive radix tree is a radix tree variant that integrates `adaptive node sizes` to the radix tree. One major drawback of the usual `radix trees` is the use of space, because it uses a `constant node` size in every level. The `major difference` between the radix tree and the adaptive radix tree is `its variable size for each node` based on the number of child elements, which grows while adding new entries. Hence, the adaptive radix tree leads to a better use of space without reducing its speed.

{% note danger %} 
既然是动态增加的，node 本身的 memory 分配也应该是动态的，那么 memory 不连续，可能会导致 cache miss 问题。这个需要看原文 paper 看是否存在。[link](https://db.in.tum.de/~leis/papers/ART.pdf)
{% endnote %}
<!-- more -->
# Summary

![HOT](3.png)

- Each trie depicted in Figure 2 stores the same 13 keys, all of which are 9 bits long.
- The shape with the same color represent a node.
- Compound nodes are surrounded by solid lines.
- Dots in the figures represent either leaf values or bit positions in compound nodes which are used to distinguish between different keys.

**Height Optimized Trie**

- HOT combines multiple nodes of a binary Patricia trie into compound nodes having a `maximum node fanout` of a predefined value k
- Thus each node uses a custom span suitable to represent the discriminative bits of the combined nodes.
- Adaptive node sizes (same as ART) are used to reduce memory consumption
- Figure 2f shows a Height Optimized Trie with a maximum node fanout ofk = 4 that has 4 compound nodes and an overall height of 2 to store the same 13 keys as the other trie structures

This paper want to minimize the over height of the trie such that `maximum number of partitions along a path` from the root node `to any leaf node` is minimized.

[Partitioning of trees for minimizing height and cardinality](https://www.sciencedirect.com/science/article/pii/S0020019003005118) solves this optimization in static tree. This paper present a `dynamic algorithm`, which is able to preserve the height optimized partitioning `while new data is inserted`.
