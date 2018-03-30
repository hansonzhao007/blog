---
layout: post
title: 构建tensorflow开发环境
subtitle: Install tensorflow development environment
author: Hanson Zhao
image: 'https://www1-lw.xda-cdn.com/files/2017/05/google-tensorflow-android.png'
categories:
  - Technology
tags:
  - tensorflow
  - machine-learning
comments: true
abbrlink: 21100
date: 2017-04-09 00:00:00
---

笔者使用的是windows 10 系统。下面会使用docker来安装 tensorflow。

# 安装 docker
对于window下docker 的安装，直接进入官网 https://www.docker.com/docker-windows 下载安装包。需要注意的是，docker for windows 支持的是 `64bit` 操作系统。所以 `32bit` 的系统的环境，暂时这种方式还不支持。

# 安装 tensorflow
使用命令
```c
docker run -it -p 8888:8888 gcr.io/tensorflow/tensorflow
```
就会自动从 http://gcr.io 上，下载 `tensorflow` 的镜像并运行，等待下载安装结束，直接在浏览器中输入 `localhost:8888` 进行访问。
![tensorflow](/img/post/201704/ff1427c2-3dbf-4f54-84c4-ac5a3a5f823d.png)

<!-- more -->
就会进入 [`Jupyter Notebook`](https://jupyter.org/) 应用。Jupter Notebook 是一个开源的 web 应用，是一款交互式的笔记。它可以在线运行输入的代码，并实时显示结果。所以我们可以在 Jupter Notebook 中，编写我们的 tensorflow 代码，同时可以直接看到代码运行结果。

# 代码编写
这里我们尝试修改例程 `1_hello_tensorflow_ipynb` 的代码，并用快捷键 `ctrl+Enter` 查看代码运行结果。
![原代码](/img/post/201704/71d000d8-57c3-4678-866e-ff0d56fda55b.png)


我们这里尝试修改 `input2` 的向量为 `[2, 2, 4]` ，并使用快捷键 `ctrl+Enter` 查看二者相加的结果：
![修改后](/img/post/201704/bc16f459-722e-426e-8aa3-6429e0a369da.png)

 可以看到 `input1` 和 `input2` 相加的结果已经变成了 `[3, 3, 3, 5]` 。

# 参考
- [Jupter Notebook](https://jupyter.org/)
- [Jupyter Notebook 快速入门](http://www.tuicool.com/articles/a6JRr2Y)
