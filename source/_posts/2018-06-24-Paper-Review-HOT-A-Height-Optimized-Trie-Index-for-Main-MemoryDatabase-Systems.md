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

# Details

![Dynamic Insertion](4.png)

## Terminology

- `BiNode` denote a node in a binary Patricia trie.
- Term `node` stands for a compound node.
- Here maximum node fanout of k = 3.

## Algorithm

- `normal case`
Insertion is performed by locally modifying the BiNode structure of the affected node. More precisely, and as shown in `Figure 4b`, a new discriminating BiNode, which discriminates the new key from the keys contained in the subtree of the mismatching BiNode, is created and inserted into the affected node.

- `leaf-node pushdown`: This involves `creating a new node` instead of adding a new BiNode to an existing node.
If the mismatching BiNode is a leaf and the affected node is an inner node (h(n) > 1), we replace the leaf with a new node.
This case is triggered when the key 010 is inserted into the tree shown in Figure 4b. Leaf-node pushdown does not affect the maximum tree height as can be observed in Figure 4c: Even after leaf-node pushdown, the height of the root node (and thus the tree) is still 2.

- `overflow`: fanout is bigger than k = 3.
An overflow happens when neither leaf-node pushdown nor normal insert are applicable. As Figure 4d shows, such an invalid intermediate state occurs after inserting 0011000.

- Two ways to resolve `overflow`:
  - `Parent Pull Up`: Figure 4e
  Moving the `root BiNode of the overflowed node` into its parent node. This approach is taken when growing the tree “downwards” would increase the tree height, and it is therefore better try to grow the tree “upwards”. More formally, parent pull up is triggered when the height of the overflowed node n is “almost” the height of its parent: `h(n) + 1 = h(parent(n))`. Overflow handling therefore needs to be `recursively` applied to the affected parent node. Similar to a B-tree, the overall height of HOT only increases when a new root node is created.
  - `intermediate node creation`:
  `Root BiNode` of the overflowed node is moved into a `newly created intermediate node`. Intermediate node creation is only applicable if adding an additional intermediate node does not increase the overall tree height, which is the case if: `h(n) + 1 < h(parent(n))`. As shown in Figure 4g.

The paper also conjecture the HOT trie has the property that that any given set of keys results in the same structure, regardless of the insertion order.

## Design

`Key idea`: Linearizing a k-constrained trie to a compact bit string that can be search in parallel using `SIMD instructions`. To achieve this, this paper store the discriminative bits of each key consecutively.

![desing](5.png)

- using `bit position` to form discriminative bits which is called `partial key (dense)`
- maximum fanout is k = 32 so as to utilizing the cache and fast update.
- partial keys is aligned to enable SIMD operations.
- key extraction (`PEXT` instruction: [_pext_u64](https://www.felixcloutier.com/x86/PEXT.html) and [link](https://software.intel.com/sites/landingpage/IntrinsicsGuide/#text=_pext_u64&expand=3893,4072)): 
![PDEP](6.png)
key extraction is done for every node to extract bits from the search key bit-by-bit to form the comparison key (partial key).




