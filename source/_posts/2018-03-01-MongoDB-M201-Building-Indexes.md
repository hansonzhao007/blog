---
title: 'MongoDB M201 - Building Indexes '
date: 2018-03-01 15:46:20
categories: ['database']
tags:
  - mongoDB
image: https://docs.mongodb.com/manual/_images/compass-create-index-button.png
---
# Building Indexes

两种方式：
- forground indexes: 建立时候会 block user input，导致这段时间 DB 不可用。这在产品中不可接受。
- background indexes: 后台建立 index，不会 block operation，代价是build 的时间更长。
<!-- more -->

# 导入数据
```bash
mongoimport -d m201 -c restaurants --drop restaurants.json
```

```bash
mac@macs-MacBook  ~/Desktop  mongoimport -d m201 -c restaurants --drop restaurants.json
2018-03-01T14:45:48.743-0600	connected to: localhost
2018-03-01T14:45:48.745-0600	dropping: m201.restaurants
2018-03-01T14:45:51.732-0600	[######..................] m201.restaurants	40.0MB/144MB (27.9%)
2018-03-01T14:45:54.731-0600	[#############...........] m201.restaurants	78.9MB/144MB (54.9%)
2018-03-01T14:45:57.731-0600	[###################.....] m201.restaurants	115MB/144MB (80.1%)
2018-03-01T14:45:59.862-0600	[########################] m201.restaurants	144MB/144MB (100.0%)
2018-03-01T14:45:59.862-0600	imported 1000000 documents
```

# Build background index
默认建立的 index 都是 forground 的，所以为了不 block operation，这里使用 mongo shell 创建 index：
```bash
db.restaurants.createIndex({"cuisine":1,"name":1,"address.zipcode":1},{"background":true})
```

这个建立过程虽然不会 block db operation，但是会 block 当前的 mongo shell。我们可以打开另一个 mongo shell 使用 `db.currentOp()` 去查看当前状态。

```bash
"opid" : 2381,
"secs_running" : NumberLong(2),
"microsecs_running" : NumberLong(2389863),
"op" : "command",
"ns" : "m201.$cmd",
"command" : {
	"createIndexes" : "restaurants",
	"indexes" : [
		{
			"key" : {
				"cuisine" : 1,
				"name" : 1,
				"address.zipcode" : 1
			},
			"name" : "cuisine_1_name_1_address.zipcode_1",
			"background" : true
		}
	],
	"$db" : "m201"
},
"msg" : "Index Build (background) Index Build (background): 280957/1000000 28%",
"progress" : {
	"done" : 280958,
	"total" : 1000000
},
```

可以看到当前状态是 db 正在 background 的方式建立 index，进行了 28%。
记住 opid，我们可以使用 `db.killOp(opid)` 命令来 kill operation before it finish。

index 建立结束以后的状态如下：
```bash
> db.restaurants.createIndex({"cuisine":1,"name":1,"address.zipcode":1},{"background":true})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
```
