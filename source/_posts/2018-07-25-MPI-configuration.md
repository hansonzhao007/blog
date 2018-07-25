---
title: MPI configuration
mathjax: false
comments: true
author: XS Zhao
categories:
  - other
tags:
  - null
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
date: 2018-07-25 01:02:06
subtitle:
keywords:
description:
---

# Install MPI in each node server
http://mpitutorial.com/tutorials/installing-mpich2/

# Run hello world.
这里只是简单的把编译程序复制到用户的 home 目录下，然后执行。
```bash
# replace hello.c with your own source code file name
filename=hello.c
output=hello

master=10.0.0.10
slave1=10.0.0.15
slave2=10.0.0.16
slave3=10.0.0.18

# compile the source code
mpicc -o $output $filename 

# copy the executable file to other slaves
scp $output $USER@$slave1:~/ 
scp $output $USER@$slave2:~/ 
scp $output $USER@$slave3:~/ 

# deploy the program to 4 nodes
mpirun -n 4 -H $master,$slave1,$slave2,$slave3 ./$output

```

```c
// Author: Wes Kendall
// Copyright 2011 www.mpitutorial.com
// This code is provided freely with the tutorials on mpitutorial.com. Feel
// free to modify it for your own use. Any distribution of the code must
// either provide a link to www.mpitutorial.com or keep this header intact.
//
// An intro MPI hello world program that uses MPI_Init, MPI_Comm_size,
// MPI_Comm_rank, MPI_Finalize, and MPI_Get_processor_name.
//
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
  // Initialize the MPI environment. The two arguments to MPI Init are not
  // currently used by MPI implementations, but are there in case future
  // implementations might need the arguments.
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

  // Get the name of the processor
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  MPI_Get_processor_name(processor_name, &name_len);

  // Print off a hello world message
  printf("Hello world from processor %s, rank %d out of %d processors\n",
         processor_name, world_rank, world_size);

  // Finalize the MPI environment. No more MPI calls can be made after this
  MPI_Finalize();
}
```