---
layout:     post
title:      "第二章-IO大法"
subtitle:   "Chapter2-IO"
date:       2017-08-16
author:     "Hanson Zhao"
header-img: "img/post/201708/HardDiskDriveStorage.png"
categories: ['Technology']
tags:
    - storage
    - 大话存储
comments:   true
---
# IO大法
## PCI
PCI是Peripheral Component Interconnect(外设部件互连标准)。其连接在`南桥`上。
`北桥`连接系统内存，CPU以及高速总线（ex. PCIE）。
PCI的`地址总线`和`数据总线`是`时分复用`（Time Division Multiplexing，TDM），即采用同一物理连接的不同时段来传输不同的信号。

数据传输时，分为传输的发起者（Master）和数据的接受者（Slave），同一时刻只有一对设备可以传输数据。

### 中断共享
硬件上，采用`电平触发`（PCI板卡设备用三极管拉低信号）
软件上，采用`中断链`（如果多个板卡共享一个中断，那么一个中断处理函数结束会指向下一个处理函数，发生中断时候，逐个检查，是则处理，不是则跳过）

## 数据通信
CPU向存储所在的地址（比如0x0A）发送命令。
-    发送读（/写）命令
-    指明LBA（硬盘逻辑区块）
-    指明读取的内容到哪一段内存。

1. 第一条指令指定了读时配置：完成是否触发中断，是否启用磁盘缓存。。。
2. 第二条指令进行磁盘的`逻辑区块`到`实际区块`查找，转到该扇区，读取数据
3. 第三条指令，在数据读出以后，会进入 DMA 操作，不需要 CPU 接入，读取结束，CPU从内存读取数据，并进行计算。
