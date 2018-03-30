---
title: How the append-only btree work
mathjax: true
categories:
  - Technology
tags:
  - storage
abbrlink: 21757
date: 2017-08-23 11:50:17
---

原文：http://www.bzero.se/ldapd/btree.html

该 tree 也被称为 Copy-On-Write Tree
考虑下图的这个3层 b tree.
![3levelbtree](http://www.bzero.se/ldapd/how-the-btree-works.png)
该树由两层的 branch page（root 也是一个 branch page）和 5 个 leaf page 组成。key 和 data 都存储在 leaf page 里面。
<!-- more -->
这里，leaf chaining（叶节点之间的指针连接）并没有被支持，也就是叶子节点之间的顺序 access 特性不被支持（即没有指针从一个 leaf 指向下一个 leaf），这是因为该特性的实现，会要求每次 update 都去 rewrite 整个 tree。

该 tree 的 page 在 database 文件中，被顺序存储着。添加 page numbers 也只是意味着增加 file 的 offset（类似于给vector数组后面添加一个位置一样）。

meta page ？包括：
- 一个指向 root page 的指针
- 一个 SHA1 hash
- 一个静态计数器（全局计数器）？

当一个 file 被打开，它将会被从尾部的 page 开始扫描，直到找到一个有效的 meta page，从而根据上述的指针，找到 root page。

![sequential-page-view](http://www.bzero.se/ldapd/sequential-page-view.png)

比如现在要更新 leaf page 8 上的值，不同于直接在该 page 上进行更改覆写，这里会直接产生一个具有 new value 的 page，并 append 到 file 尾部。如下图中的 page 12。

![updated-btree](http://www.bzero.se/ldapd/updated-btree.png)

因为原本作为 leaf page 8 的位置，修改到了 page 12，它的每个 parent page 都需要更新对应的指针。

leaf 7 没有被影响。而 branch 6 作为被修改 leaf 的 parent，其指针值被影响了，所以一个新的 page 被创建出来 -- branch page 11，同时一个新的 root 也被创建出来 -- root 13，更新后的 tree 如上图所示。

这样，任何拥有 root page 9 的用户，仍然能够跟踪到没有被修改之前的值。这就是 database 自己的一个 snapshot。

在该 database file 中，新 page 只是不断的被 append 到 file 尾部，已经写入值的 page 并不会被影响。

修改一次数据后，当每个相关的 page 都被更新完毕，就会产生一个新的 meta page，指向新的 root page，如下图：

![flattened-btree-page-structure](http://www.bzero.se/ldapd/flattened-btree-page-structure.png)

从结果上看，对一个page的修改（修改 leaf page 8），会导致 4 个新 page 被 append 到 file 尾部。这在一定程度上浪费了磁盘空间，但是这样顺序写操作，能够非常大的提升随即写性能。并且这里并不需要再记录 transaction log，用于数据恢复，该 database file 本身，就是一个 transaction log。
