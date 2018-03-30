---
title: MongoDB M201 - How Data is stored on disk
categories:
  - database
tags:
  - MongoDB
abbrlink: 15536
date: 2018-02-15 10:33:59
---
# 配置本地环境
默认情况下，MongoDB 数据库目录的组织结构如下：
![](1.png)
- collection-*.wt: 数据库的 collection 文件
- index-*.wt: 数据库建立的 index 文件

![](2.png)
<!-- more -->
现在的数据库组织形式还是 flat 的，也就是所有数据库 collection 存储在一个目录下。

# 创建数据库子目录
我们可以使用 --directoryperdb 命令让 MongoDB 将数据库存储时候按照文件夹区分开：
首先使用命令，关闭 mongodb server。然后删除 db 目录并重新建立一个 db 目录。

```bash
	• mongo admin --eval 'db.shutdownServer()'
	• rm -rf /data/db
	• mkdir -p /data/db
```


下面对每一个 database 都创建自己的目录。
```bash
• mongod --dbpath /data/db --fork --logpath /data/db/mongodb.log --directoryperdb
```
![](3.png)

可以看到初级目录里面已经没有 collection 和 index 文件了。如果进入 local 子目录，可以看到：
![](4.png)

# 创建 collection 和 index 子目录
上面我们已经把不同的 database 放到了不同目录下，现在我们还可以将 collection 和 index 文件放在各自的目录下。

首先使用命令，关闭 mongodb server。然后删除 db 目录并重新建立一个 db 目录。
```bash
	• mongo admin --eval 'db.shutdownServer()'
	• rm -rf /data/db
	• mkdir -p /data/db
```
使用如下命令：
```bash
• mongod --dbpath /data/db --fork --logpath /data/db/mongodb.log --directoryperdb --wiredTigerDirectoryForIndexes
```

![](5.png)

可以看到 local 数据库目录下多了两个子目录，一个是 collection ，一个是 index。之所以这么做，是为了提升数据库的性能。我们可以将 collection 和 index 放在两个不同的 disk 上。这样利用两个 disk 的 parallel 读写（parallel I/O），提升 mongodb 的数据吞吐量。

![](6.png)
