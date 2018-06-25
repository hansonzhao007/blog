---
title: >-
  Paper Review: A Comparative Study of Secondary Indexing Techniques in
  LSM-based NoSQL Databases
mathjax: false
comments: true
author: XS Zhao
categories:
  - review
tags:
  - database
  - nosql

image: 'http://hansonzhao007.github.io/blog/images/infinite1.gif'
abbrlink: 31235
date: 2018-06-24 13:58:34
subtitle:
keywords:
description:
---

# Summary

NoSql databases have fast write throughput and fast lookup on primary key. And they also have good scalability and reliability.

However, in order to search non-primary attributes, `secondary index` should be maintained and this could hurts `write performance`.

This paper compares two types of secondary index:

- Embedded Indexes: lightweight filters embedded inside the primary table

- Stand-Alone Indexes: separate data structure

by implementing 2 `Embedded Indexes` and 3 `Stand-Alone Indexes` on top of LevelDB.

They conclude that : the `embedded indexes` offer superior `write throughput` and are more space efficient, whereas the `stand-alone secondary indexes` achieve `faster query` response times. So the optimal choice depends on the application workload.

# Details

## Stand-Alone Indexes

Using tweets as example: `PUT(t1, {u1, text1})`

- t1: tweet id
- u1: user id
- text1: tweet content

There are `three types` of Stand-Alone Indexes update:

![](1.png)

- `Eager updates`: Earlier version of Cassandra
to execute `PUT(t4, {u1, text4})` on an Eager Index, we must retrieve the list for u1, add t4 and save it back.
**Draw Back**: degrades the write performance.

- `Lazy updates`:
simply issue a PUT(u1, {t4}) on the user id index table without retrieving the existing posting list for u1. The old postings list of u1 is merged with (u1, {t4}) later, during the periodic compaction phase.

- `Composite`: [AsterixDB](https://asterixdb.apache.org/) and [Spanner](https://ai.google/research/pubs/pub39966)
each entry in the secondary indexes is a composite key consisting of (secondary key + primary key). The secondary lookup is a prefix search on secondary key, which can be implemented using regular `range search` on the index table.
Write and compaction can be faster than `Lazy`, but the secondary attribute lookup may be slower because of range scan.

## Embedded Secondary Indexes
There is no separate secondary index structure,  secondary attribute information is stored inside the original (primary) data blocks. As shown in figure (b).









