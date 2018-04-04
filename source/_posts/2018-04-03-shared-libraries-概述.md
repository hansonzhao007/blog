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
Shared Libraries 有下面三种名字：

## soname
`lib`+ `library name` + `.so` + `period` + `version number`
比如：libleveldb.so.1.20。在 linux 系统中，soname 是 shared libraries 的 real name 的 symlink。
```bash :soname示例
$ ls -al | grep level
-rw-r--r--  1 root root 789K 2018-04-03 01:42 libleveldb.a
lrwxrwxrwx  1 root root   18 2018-04-03 01:42 libleveldb.so -> libleveldb.so.1.20* # linker name
lrwxrwxrwx  1 root root   18 2018-04-03 01:42 libleveldb.so.1 -> libleveldb.so.1.20* # soname
-rwxr-xr-x  1 root root 459K 2018-04-03 01:42 libleveldb.so.1.20* # real name
```
<!-- more -->

可以看到 `libleveldb.so` 和 `libleveldb.so.1`都是 `libleveldb.so.1.20*` 的 symlink。从文件大小就能看出不同。

## real name
每一个 shared library 都有一个 `real name`，real name 下的文件才是真正包含源代码的文件。real name 会在 soname 后面添加 period，minor number，[another period，release number]，后面两个是 optional 的。

## linker name
就是不包含任何 version number 的 soname。这个就是我们在 compile 的时候用到到的 name。

管理 shared library 的关键在于区分好这些 name。程序应该只列出它们想要用到的 soname。当我们创建一个 shared library 后，应该给它命名一个包含 version information 的 name。然后将创建的 shared library 安装（复制）到指定目录（比如 `/usr/local/lib` `/usr/lib` ），然后运行 `ldconfig` 命令。 ldconfig 会检测目录中已存在的files，并给他们的 real name 创建对应的 soname。并设置 cache file: `/etc/ld.so.chache`。

`ldconfig` 并不会设置 linker name。linker name 的创建一般在 library installation 的时候，并且 linker name 只是对最新的 soname 或者 real name 创建一个 symlink。

# 参考
1. [Program Library HOWTO](http://www.tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html)
