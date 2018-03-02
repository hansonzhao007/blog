---
title: 【TP】18 Introduction to Paging
date: 2017-10-01 15:22:49
mathjax: true
categories: ['OS']
tags:
  - memory
---
将 memory 分割成 fixed-sized 块，这就叫 `paging`

We divide address space into fixed-sized units, each of which we call a `page`. Correspondingly, we view physical memory as an array of fixed-sized slots called `page frames`.
#  A Simple Example And Overview
OS may find free spaces from a `free list` to your program, and there will be a mapping relationship between physical address and virtual address.

![](Selection_001.png)
To record where each virtual page of the address space is placed in physical memory, the operating system usually keeps a `per-process` data structure known as a `page table`.
<!-- more -->
The major role of the page table is to store `address translations` for each of the virtual pages of the address space.

It is important to remember that this page table is a per-process data structure (most page table structures we discuss are per-process structures; an exception we’ll touch on is the `inverted page table`).

`page table entry (PTE)`

![](Selection_002.png)
- A `valid bit` is common to indicate whether the particular translation is valid
- `protection bits`, indicating whether the page could be read from, written to, or executed from
- A `present bit` indicates whether this page is in physical memory or on disk (i.e., it has been swapped out). We will understand this machinery further when we study how to swap parts of the address space to disk to support address spaces that are larger than physical memory; swapping allows the OS to free up physical memory by moving rarely-used pages to disk.
- A `dirty` bit is also common, indicating whether the page has been modified since it was brought into memory
- A `reference` bit (a.k.a. `accessed bit`) is sometimes used to track whether a page has been accessed, and is useful in determining which pages are popular and thus should be kept in memory; such knowledge is critical during page replacement
# Paging can be slow

![](Selection_003.png)
For every memory reference (whether an instruction fetch or an explicit load or store), `paging` requires us to `perform one extra memory reference` in order to first fetch the translation from the page table. That is a lot of work! Extra memory references are costly, and in this case will likely slow down the process by a factor of two or more.

看下面一段代码：

![](Selection_006.png)
汇编后的：

![](Selection_005.png)
%edi holds the base address of the array, whereas %eax holds the array index (i);

![](Selection_004.png)
When it runs, each instruction fetch will generate two memory references:
- one to the page table to find the physical frame that the instruction resides within
- one to the instruction itself to fetch it to the CPU for processing
- there is one explicit memory reference in the form of the mov instruction; this adds another page table access first (to translate the array virtual address to the correct physical one) and then the array access itself.

图解：
1. assume we have a linear (array-based) page table and that it is located at physical address 1KB (1024).
2. the page size is 1KB, virtual address 1024 resides on the second page of the virtual address space (VPN=1, as VPN=0 is the first page). Let’s assume this virtual page maps to physical frame 4 (VPN 1 → PFN 4).
3. array itself. Its size is 4000 bytes (1000 integers), and we assume that it resides at virtual addresses 40000 through 44000
4. Let’s assume these virtual-to-physical mappings for the example: (VPN 39 → PFN 7), (VPN 40 → PFN 8), (VPN 41 → PFN 9), (VPN 42 → PFN 10)

there are 10 memory accesses per loop, which includes four instruction fetches, one explicit update of memory, and five page table accesses to translate those four fetches and one explicit update.

# Reference
[Introduction to Paging](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-paging.pdf)
