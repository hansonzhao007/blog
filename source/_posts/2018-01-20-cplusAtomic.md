---
title: "C++ Atomic"
date: 2018-01-20 20:32:03
categories: ['program']
tags:
  - multi-thread
  - levelDB
---
[What exactly is std::atomic](https://stackoverflow.com/questions/6319146/c11-introduced-a-standardized-memory-model-what-does-it-mean-and-how-is-it-g)
[C++ atomics and memory ordering](https://bartoszmilewski.com/2008/12/01/c-atomics-and-memory-ordering/)

This is used to prevent the CPU from doing the instruction reordering.

```cpp
atomic<bool> ready = false;
atomic<int> data = 0;
```
Thread 0:
```cpp
data.store(1, memory_order_release);
ready.store(true, memory_order_release);
```
Thread 1:
```cpp
if (ready.load(memory_order_acquire))
  assert (data.load(memory_order_acquire) == 1);
```
The code below will not create a memory fence.

`[memory fence](https://en.wikipedia.org/wiki/Memory_barrier)`:CPUs often execute instructions [out of order](https://en.wikipedia.org/wiki/Out-of-order_execution) to make maximum use of the available silicon (including memory read/writes). Because the hardware enforces instructions integrity you never notice this in a single thread of execution. However for multiple threads or environments with volatile memory (memory mapped I/O for example) this can lead to unpredictable behavior.

A memory fence/barrier is a class of instructions that mean memory read/writes occur in the order you expect. For example a 'full fence' means all read/writes before the fence are comitted before those after the fence.

- `memory_order_acquire`: guarantees that `subsequent loads` are not moved before the current load or any preceding loads.
- `memory_order_release`: `preceding stores` are not moved past the current store or any subsequent stores.
- `memory_order_acq_rel`: combines the two previous guarantees.
- `memory_order_consume`: potentially weaker form of memory_order_acquire that enforces ordering of the current load before other operations that are data-dependent on it (for instance, when a load of a pointer is marked memory_order_consume, subsequent operations that dereference this pointer won’t be moved before it (yes, even that is not guaranteed on all platforms!).
- `memory_order_relaxed`: all reorderings are okay.
