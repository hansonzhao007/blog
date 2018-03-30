---
title: review on Geospatial Performance Improvements in MongoDB 3.2
categories:
  - database
tags:
  - MongoDB
abbrlink: 21963
date: 2018-01-15 18:13:02
---
[link](https://www.mongodb.com/blog/post/geospatial-performance-improvements-in-mongodb-3-2)

In mongoDB version before v3.2, `$geoNear` operation was sometimes slow for queries on dense datasets.

After version v3.2, this algorithm had been upgrade. This is a brief explanation about the upgrade.

The `$geoNear` algorithm iteratively expands its search in distance `intervals` (the red annulus shown below), aiming to have a few hundred documents per interval. Searching all documents in an interval is accomplished by finding an index `cell covering`. This covering ensures that all of the documents in the interval can be found using an index scan. The documents in the covering but not in the interval are filtered out afterwards. After all of the documents in an interval are found, they are sorted and returned.
<!-- more -->
![](1.png)

Problem is that the cell covering may have overlaps in different iterations (Also called stages).

![](2.png)

![](3.png)

The original $geoNear algorithm did not account for this problem. At every interval, it would create a covering independent of what was already covered during searches of previous intervals. The `repeated index scans` could become very expensive in dense datasets where the search intervals were thin.

`new $geoNear algorithm`
- buffer the documents in current covering but not in current iteration's interval, and provide them for next iteration.
- current iteration(or stage) only fetch the documents in current coverings that has no overlap with previous iteration. (the new fetched documents with the buffered documents from previous iteration will be used)

![](4.png)

![](5.png)

Since the algorithm now only needs to visit the cells that have not been visited before, the number of index scans required in large queries drops dramatically
