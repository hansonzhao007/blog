---
title: 13 The Abstraction Address Spaces
date: 2017-09-17 15:39:18
categories: ['OS']
tags:
  - memory
---

# Early Systems
Early machines didn’t provide much of an abstraction to users.

![][1]

The OS was a set of routines (a library, really) that sat in memory (starting at physical address 0 in this example), and there would be one running program (a process) that currently sat in physical memory (starting at physical address 64k in this example) and used the rest of memory.

# Multiprogramming and Time Sharing
After a time, because machines were expensive, people began to share machines more effectively. Thus the era of `multiprogramming` was born [DV66], in which multiple processes were ready to run at a given time, and the OS would switch between them, for example when one decided to perform an I/O. Doing so increased the effective utilization of the CPU. Such increases in efficiency were particularly important in those days where each machine cost hundreds of thousands or even millions of dollars.

Soon enough, however, people began demanding more of machines, and the era of `time sharing` was born.

![][2]

In the diagram, there are three processes (A, B, and C) and each of them have a small part of the 512KB physical memory carved out for them. Assuming a single CPU, the OS chooses to run one of the processes (say A), while the others (B and C) sit in the ready queue waiting to run.

# The Address Space
In particular, allowing multiple programs to reside concurrently in memory makes` protection`an important issue.

OS create a easy to use abstraction of physical memory: ` address space`

`code` live in memory
`stack` is used to keep track and pass parameters, return value to and from rountines
`heap` is used for dynamically-allocated

Process A in tries to perform a load at address 0 (which we will call a `virtual address`), somehow the OS, in tandem with some hardware support, will have to make sure the load doesn’t actually go to physical address 0 but rather to physical address 320KB。

# Goals
`Transparency:` make program not aware of the fact that the memory is virtualized
'Efficiency': time and space, rely on hardware support, including features such as `TLBs`
`Protection`: protect process from one another. So we could deliver property of isolation among processes.

[1]: Selection_001.png
[2]: Selection_002.png
