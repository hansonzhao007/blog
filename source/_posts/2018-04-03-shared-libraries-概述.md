---
title: Shared Libraries 概述
mathjax: false
comments: true
author: XS Zhao
categories:
  - linux
tags:
  - make
image: 'http://hansonzhao007.github.io/blog/images/infinite6.gif'
abbrlink: 2914
date: 2018-04-03 10:30:57
subtitle:
keywords:
description:
---

最近使用 `make` 编译代码的时候，遇到了和 Shared Libraries 相关的一些问题，做一下总结。

# 什么是 Shared Libraries
Shared Libraries 是程序在运行的时候才装载的 libraries，换句话说，就是这些代码并没有编译链接到可执行文件中。

# Shared Libraries name
Shared Libraries 有两种名字：
**soname**: `lib`+ `library name` + `.so` + `version number`
比如：libleveldb.so.1.20。在 linux 系统中，soname 是 shared libraries 的 real name 的 symlink。

```bash soname示例
$ ls -al | grep level
-rw-r--r--  1 root root 789K 2018-04-03 01:42 libleveldb.a
lrwxrwxrwx  1 root root   `18` 2018-04-03 01:42 libleveldb.so -> libleveldb.so.1.20*
lrwxrwxrwx  1 root root   `18` 2018-04-03 01:42 libleveldb.so.1 -> libleveldb.so.1.20*
-rwxr-xr-x  1 root root `459K` 2018-04-03 01:42 libleveldb.so.1.20*
```
<!-- more -->
可以看到 `libleveldb.so` 和 `libleveldb.so.1`都是 `libleveldb.so.1.20*` 的 symlink。

**real name**: 

# 参考
1. [Program Library HOWTO](http://www.tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html)
