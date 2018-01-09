---
title: mongo-beginner
date: 2018-01-08 21:19:04
tags:
- storage
---
# Basic
- NoSQL 数据库
- compass app: 连接 mongodb atlas 的官方 app
- mongod: mongoDB 的 database application
- mongo: 提供和 database 进行交互的 shell 接口 application
- 向 mongodb atlas 上传数据
```bash
mongoimport --type csv --headerline --db mflix --collection movies_initial --host "cluster0-shard-00-00-1cvum.mongodb.net:27017,cluster0-shard-00-01-1cvum.mongodb.net:27017,cluster0-shard-00-02-1cvum.mongodb.net:27017" --authenticationDatabase admin --ssl --username hansonzhao007 --password XXXXXX --file movies_initial.csv
```

# Aggregation Framework
## pipeline
![pipeline](pipeline.png)
从 collection 里面获得数据，并输入到后面的 stages，每个都进行不同的操作。这些输入输出都是 documents。

## stages
![stages](stages.png)
stage 里面可以定义自己对 document 的操作。可以是 reshape，accumulation 等等。

![stage-function](stage-function.png)
这里的 stage1 可以用来过滤输入数据，不用对每个数据都处理。stage2 可以用来自定义一些数据操作；stage3 可以再次过滤一下。

## write a pipeline
下图是python 写 mongodb pipeline 的图例：
![python-pipeline](pipeline-python.png)

```python
import pymongo
from pymongo import MongoClient
import pprint
from IPython.display import clear_output

client = MongoClient("mongodb+srv://hansonzhao007:yourpassword@cluster0-1cvum.mongodb.net")

pipeline = [
    # group stage
    {
        '$group':{
            '_id':{"language":"$language"},
            'count':{'$sum': 1}
        }
    },
    # sort stage
    {
        '$sort':{'count': -1} # decending order, 1 is accending order
    }
]

# # a simplify version is:
# pipeline = [
#   {
#     '$sortByCount':"$language"
#   }
# ]

clear_output()
pprint.pprint(list(client.mflix.movies_initial.aggregate(pipeline)))
```

```bash
[{'_id': {'language': 'English'}, 'count': 25325},
 {'_id': {'language': 'French'}, 'count': 1784},
 {'_id': {'language': 'Italian'}, 'count': 1480},
 {'_id': {'language': 'Japanese'}, 'count': 1290},
 {'_id': {'language': ''}, 'count': 1115},
 {'_id': {'language': 'Spanish'}, 'count': 875},
 {'_id': {'language': 'Russian'}, 'count': 777},
 ...
 ```

## faceted search
