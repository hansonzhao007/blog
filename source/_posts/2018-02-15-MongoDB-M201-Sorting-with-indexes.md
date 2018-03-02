---
title: MongoDB M201 - Sorting with indexes
date: 2018-02-15 10:52:14
categories: ['database']
tags:
  - mongoDB
---

任何一次 query 的结果都可以被排序，如下：
```bash
exp.find({first_name:"James"}).sort({first_name:1})
```

有两种排序方式：
	1. 从 disk 里面读取 documents，然后做 in memory 排序。
	2. 根据 field 生成 index，index 是排序的。

当我们对没有建立 index 的 field query 后（以上面的first_name 查找排序为例）进行排序。mongoDB 会首先从 collection 里面遍历，完成 query 操作，这会 touch 到所有的 documents。然后 filter 以后的结果，在 memory 中进行排序。如果 query 得到 documents 很多，那么该过程会很费时(mongoDB 会避免超过 32GB 的 in memory 排序)。
<!-- more -->
# Compound index sorting
index prefix: 当使用 compound index 的时候，如果 query 的 field 组成了一个 compound index 的 prefix，那么就可以利用 index 输出 sorting 的结果。

![](1.png)
因为选中的三项都可以构成 compound index 的 prefix，所以可以用来同时做 filter 和 sorting。
- 第一项不是 prefix，只是中间的某个子集，所以不行。
- 第四项因为跳过了 address.state ，所以也不是子集，用不了 compound index 去 filter 和 sorting。只能做 memory sorting。
