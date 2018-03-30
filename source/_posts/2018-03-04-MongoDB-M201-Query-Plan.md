---
title: MongoDB M201 - Query Plan
mathjax: false
comments: true
author: XS Zhao
categories:
  - database
tags:
  - MongoDB
image: 'http://hansonzhao007.github.io/blog/images/infinite7.gif'
abbrlink: 19708
date: 2018-03-04 16:06:28
subtitle:
---
# 什么是 Quary Plan
当发起一个 query 请求时，当有多个约束条件，就会形成一个 query plan，本质上是怎么样去组织 pipeline 的 stage，使得 query 更有效率。

比如有下面的一个 query 请求：

```bash
// 找出 zip code 大于 50000，并且`cuisine` field 包含 `Sushi`的 documents `stars` 降序排序
db.restaurants.find({"address.zipcode": {$gt:'50000'}, cuisine: 'Sushi'}).sort({"stars": -1})
```

那么我们应该怎样组织 query 过程呢？是先找到 documents 然后排序，还是先排序，然后再找 document？

使用什么样的 query plan 是跟我们建立的 index 相关的。使用不同的 index，则会得到不同的 query plan。

比如当index分别为如下两个时候：
```bash
{address.zipcode: 1, cuisine: 1}
{cuisine: 1, stars: 1}
```
<!-- more -->
1)的 index 下，query plan 是：IXSCAN -》FETCH -》SORT
2)的 index 下，query plan 是：IXSCAN -》FETCH。因为已经按照 stars 升序排序了，MongoDB 会反向scan，得到 stars 降序的结果。节省了一次 sort 过程。

# 怎样选择 Query Plan
还是上面的 query 请求：
```bash
db.restaurants.find({"address.zipcode": {$gt:'50000'}, cuisine: 'Sushi'}).sort({"stars": -1})
```

但是当同时存在多个 index，如下：
```bash
{_id: 1}
{name: 1, cuisine: 1, stars: 1}
{"address.zipcode": 1, cuisine: 1}
{"address.zipcode": 1, stars: 1}
{cuisine: 1, stars: 1}
```

那么 query plan 应该怎么安排才能够更有效利用这些 index，是的 query 的耗时更短呢？

`第一次调用` 该 query 时候，MongoDB 首先会扫描已有的 index，并从中找出能够利用的 index（which indexes are viable to satisfy the query），作为 `candidate indexes`。在这里，candidate index 是这几个：
```diff
    {_id: 1}
    {name: 1, cuisine: 1, stars: 1}
+   {"address.zipcode": 1, cuisine: 1}
+   {"address.zipcode": 1, stars: 1}
+   {cuisine: 1, stars: 1}
```

然后根据 `candidate indexed`， MongoDB 的 `query optimizer` 会生成 `candidate plans`。同时，MongoDB 有一个 `empirical query planer`，它会对每个 candidate plan，运行一小段时间（trial run），然后从这些测试中，找出 performance 最好的一个。

对本 query 而言，最好的 plan 如下：
![](1.png)


之后，MongoDB 会 `cache` 该 query 下的 best plan，我们把这个 cache 称为 `plan cache`。
我们形容相同的 query 具有相同的 `query shape`。那么下次，具有相同的 query shape 的 query 进来以后，就会直接从 `plan cache` 里面调用对应的 query plan。

# Evict a plan
随着时间，数据库的 collection 数据会发生变化，index 也是如此。所以有时候，plan cache 需要剔除某些 query plan，这个过程叫做 `evict`。
下面这些情况下，会 evict：
![](2.png)

- Server restart
- Rebuild index
- Create/Drop indexes
