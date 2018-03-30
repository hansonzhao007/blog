---
title: 'MongoDB M201 - Single Field Indexes '
categories:
  - database
tags:
  - MongoDB
image: 'http://hansonzhao007.github.io/blog/images/infinite1.gif'
abbrlink: 24521
date: 2018-02-15 10:46:46
---
# 导入数据

首先到 https://s3.amazonaws.com/m312/people.json 下载数据。然后导入本地 MongoDB 数据库里。
```bash
  mongoimport -d m201 -c people --drop people.json
```
MongoDB 启动以后（即 mongod 运行），使用 MongoDB compass 链接本地数据库，查看：
![](1.png)
<!-- more -->
然后可以进入 mongo shell 使用如下命令查看 m201 的数据。
```bash
  db.people.count({ "email" : {"$exists": 1} })
```

# 查询分析
首先 在 mongo shell 中使用一条查询命令：
```bash
  db.people.find({"ssn":"720-38-5636"}).explain("executionStats")
```
这里 explain 是用于显示查询的过程的，也可以使用 compass 的 explain 窗口显示：
![](2.png)


可以看到这次查询耗费 21ms。为了返回一个结果，检查了所有的 document。效率很低。

# 创建 index
使用命令：
```bash
  db.people.createIndex({ssn:1})
```
![](3.png)


可以看到 index 创建成功。下面重新重复上次的查询。
![](4.png)

可以看到因为 index 的加速，只 touch 了一个 document，并且查询时间为 0ms。

我们可以创建一个 explain 的查询器，以方便观察呢每次 query 的过程：
```bash
  exp = db.people.explain("executionStats")
```
