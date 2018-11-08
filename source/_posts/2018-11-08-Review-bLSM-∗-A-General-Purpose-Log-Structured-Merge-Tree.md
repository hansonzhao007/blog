---
title: 'Review: bLSM:* A General Purpose Log Structured Merge Tree'
mathjax: false
comments: true
author: XS Zhao
categories:
  - review
tags:
  - LSM tree
  - kv
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 4011
date: 2018-11-08 09:14:52
subtitle:
keywords:
description:
---

# Big question

LSM tree will sacrifice read performance with write performance. This paper, `bLSM` ( a Log Structured Merge (LSM) tree with the advantages of B-Trees and log structured approaches), claims to have near optimal `read` and `scan` performance, and a bounded `write latency` with `spring and gear` merge scheduler.

# Background

bLSM is designed as a backing storage for Yahoo's geographically distributed key-value storage system, and Walnut, a elastic cloud storage system.

![summary](result.png)

# Specific question

## Reduce read amplification

It seems like they are using fractal tree structure. But the design seems not clear to me. I haven't get a clue about how they implement the idea.

## Write pause

`level scheduler`: A merge scheduler.

The explanation in the paper is not clear to me. Hard to understand.

