---
title: MongoDB in Python
categories:
  - database
tags:
  - MongoDB
image: 'http://hansonzhao007.github.io/blog/images/infinite3.gif'
abbrlink: 49849
date: 2018-03-01 15:03:58
---

# 导入数据
## 导入一个 collection
https://s3.amazonaws.com/edu-static.mongodb.com/lessons/coursera/building-an-app/getting-data-into-mongodb/movies_initial.csv

after create MongoDB Altas cluster, import movies_initial.csv file to the cluster.

```bash
mongoimport --type csv --headerline --db mflix --c movies_initial --host "mflix-shard-00-00-1cvum.mongodb.net:27017,mflix-shard-00-01-1cvum.mongodb.net:27017,mflix-shard-00-02-1cvum.mongodb.net:27017"--authenticationDatabase admin --ssl --username hansonzhao007 --password Zxsh3017568 --file movies_initial.csv
```

<!-- more -->
# 导入所有 collection
首先从这里 https://s3.amazonaws.com/edu-static.mongodb.com/lessons/coursera/building-an-app/mflix.zip 下载压缩文件并解压。
```bash
# 进入mflix文件夹，并安装依赖环境
pip3 install -r requirements.txt
```

After installing all the dependencies you can import the data required by mflix into your MongoDB Atlas cluster.
To import this data you'll first need to paste your connection URI (from the Atlas UI) into env.sh (or env.bat on Windows).
After you've update env.sh (or env.bat on Windows) with your Atlas connection URI you can run init.sh (or init.bat on Windows) to import all the required data:
On Windows your env.bat should look like this:
![](1.png)

导入过程如下：
![](2.png)

最终数据如下：
![](3.png)

# 环境配置
除了安装 MongoDB ，要使用 python 来操作 mongoDB，需要使用 PyMongo plugin。安装过程见[这里](https://api.mongodb.com/python/current/installation.html)。

# 链接 MongoDB atlas

因为创建的 atlas cluster 是基于 mongoDB 3.4 的，所以链接的 URI 如下：
![](4.png)

然后使用如下 code 测试链接效果：
![](5.png)

可以看到没有 error 输出，表示链接成功。

# MongoDB aggregation
下面测试 mongodb 的 pipeline stage。在连接 mongodb cluster 以后：

```python
import pprint
from IPython.display import clear_output
# 这里是 MongoDB pipeline stage 的语法写法。
pipeline = [
    # group stage
    {
        '$group':{
            '_id':{"language":"$language"},
            'count':{'$sum':1}
        }
    },
    # sort stage
    {
        '$sort':{'count':-1}
    }
]
# 上面等同于这里：作用是根据 language 聚类，统计数量，并按照由多到少的顺序排列
# pipeline = [
#     {
#         '$sortByCount': "$language"
#     }
# ]
pprint.pprint(list(client.mflix.movies_initial.aggregate(pipeline)))
```

# Facet
这里facet 的作用是接受上一个 stage 的输入，将当前 stage 拆分成并列的 pipeline，输出多个结果。

```python
pipeline = [
    {
        '$sortByCount':'$language'
    },
    {
        '$facet':{
            'top language combination':[{'$limit':100}],
            'unusual combinations shared by':[
                {
                    '$skip':100
                },
                {
                    '$bucketAuto':{
                        'groupBy': '$count',
                        'buckets': 5,
                        'output': {
                            'language combinations':{'$sum':1}
                        }
                    }
                }
            ]
        }
    }
]
pprint.pprint(list(client.mflix.movies_initial.aggregate(pipeline)))
```
![](6.png)

# Filter on Scalar Field
```python
filter = {'language':'Korean, English'}
projection = {'language':1,'title':1}

pprint.pprint(list(client.mflix.movies_initial.find(filter,projection)))
```

# Geospatial queries
```python
import pymongo
import pprint

# Replace XXXX with your connection URI from the Atlas UI
course_cluster_uri = "mongodb://hansonzhao007:<PASSWORD>@mflix-shard-00-00-1cvum.mongodb.net:27017,mflix-shard-00-01-1cvum.mongodb.net:27017,mflix-shard-00-02-1cvum.mongodb.net:27017/test?ssl=true&replicaSet=mflix-shard-0&authSource=admin"

course_client = pymongo.MongoClient(course_cluster_uri)
theaters = course_client['mflix']['theaters']

theater = theaters.find_one({})

pprint.pprint(theater)

pprint.pprint(theater['location']['geo'])

EARTH_RADIUS_MILES = 3963.2
EARTH_RADIUS_KILOMETERS = 6378.1
example_radius = 0.1747728893434987

radius_in_miles = example_radius * EARTH_RADIUS_MILES

print(radius_in_miles)

query = {
  "location.geo": {
    "$nearSphere": {
      "$geometry": {
        "type": "Point",
        "coordinates": [-73.9899604, 40.7575067]
      },
      "$minDistance": 0,
      "$maxDistance": 10000
    }
  }
}
projection = {"location.address":1}

for theater in theaters.find(query,projection).limit(5):
    pprint.pprint(theater)
```
