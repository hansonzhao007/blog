---
title: mongoDB index 与 performance
date: 2018-01-10 13:58:50
categories: ['database']
tags:
  - MongoDB
---
- [Introduce to NoSql](https://www.youtube.com/watch?v=qI_g07C_Q5I)

# Single Field indexes
对 collection 里的某一个 field 创建的 index 就是 sigle  field indexes。它的特点：
- keys from only one Field
- can find a single value for the indexes field
- can find a range of values
- can use dot notation to index field in subdocuments
- can be used to find several distinct values in a single query
<!-- more -->
首先下载 [people](https://university.mongodb.com/static/MongoDB_2018_M201_January/handouts/people.json) 文件。然后利用下面的命令导入数据库。
```bash
mongoimport -d m201 -c people --drop people.json
```

然后执行查询命令(进入 mongo shell 中)
```bash
db.people.find({"ssn":"720-38-5636"}).explain("executionStats")
```
可以看到总共检查了 50474 个（people collection 的总 document 数量就是 50474，也就是遍历了整个数据库） documents，返回了 1 个结果。效率很低。
![result1](result1.png)

接下来我们给 people collection 的 ssn field 创建 indexes。
```
> db.people.createIndex({ssn:1})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
```

可以创建一个 object 用于观察查询结果：
```
> exp = db.people.explain("executionStats")
Explainable(m201.people)
> exp.find({"ssn":"720-38-5636"})
```

可以看到有了 index 以后，检索的 document 变成了 1。并且 query 时间从 32ms 变成了 4ms。

![res2](result2.png)

# Sorting
任何一次 query 的结果都可以被排序，如下：
```bash
# 找到所有 James 并按照 first name 排序
exp.find({first_name:"James"}).sort({first_name:1})
```

有两种排序方式：
1. 从 disk 里面读取 documents，然后做 in memory 排序。
2. 根据 field 生成 index，index 是排序的。

1.当我们对没有建立 index 的 field query 后（以上面的first_name 查找排序为例）进行排序。mongoDB 会首先从 collection 里面遍历，完成 query 操作，这会 touch 到所有的 documents。然后 filter 以后的结果，在 memory 中进行排序。如果 query 得到 documents 很多，那么该过程会很费时(mongoDB 会避免超过 32GB 的 in memory 排序)。

![sm](sort-in-memory.png)

可以看到这组语句 touch 了所有的 document，并且耗时33ms。

2.如果是 query 建立了 index 的 field 并且再进行排序，比如 ssn。为了保证对比结果在同样的条件，我们限制其 query 结果只用 751条，和上面的相同：
```bash
exp.find({ssn:{$gte:"200-00-1000"}}).limit(751).sort({ssn:-1})
```

![](sort-index.png)

可以看到在同样 751 结果排序，有 index 的只耗费 2ms。这是因为 mongoDB 在对有 index 的 field 进行 query 过程中，是按照已经建立的 index 去 fetch 的，而不是按照 document 的原始顺序。所以即使我们不对 query 结果进行排序，得到的结果也是排好序的（按照当初建立 ssn index 的顺序）。如果我们按照和当初建立 index 的顺序的相反顺序去 sort 结果（建立时候 accending，sort 时候 decending），那么mongoDB 自动就会从后往前去查找 index，这样 query 后的顺序仍然是满足要求的，不需要额外排序（query 时候从 forward 变成了 backward 顺序）。

# Compound Index
对多个 field 建立 index 并组合在一起使用，有点像多级排序。比如第一级按照 first name accending，第二级按照 last name accending。

比如在没有建立任何 index 时候，进行如下 query：
![noindex](noindex.png)

可以看到为了查到 Jasmine Frazier，遍历了整个 document，耗时62ms。

然后建立 last_name 的 index，重复查询：
![1index](1index.png)

可以看到只检查了 31 个 document，耗时 0ms。效率明显提升。

接下来我们建立 compound index：
![cpindex](cpindex.png)

然后重复查询：
![cpresult](cpresult.png)

可以看到在 compound index 下，只 touch 了一个 document。效率更高。

# Multikey index
# Partial index
# Text index
