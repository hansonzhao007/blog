---
layout:     post
title:      "inode相关命令"
subtitle:   "inode related commands"
date:       2017-08-20
author:     "Hanson Zhao"
header-img: "img/post/201708/inode_with_signatures.jpg"
categories: ['Technology']
tags:
    - storage
    - linux-cmd
comments:   true
---


​![inode1](inode1.png)
`touch`：新建文件
`ls -i`：显示文件的inode
`stat filename`：显示文件的所有状态信息，包括大小，inode id，link 数目，创建时间，修改时间等
`ln file1 filelink1`：给file1创建一个名字叫做filelink1的链接，具有相同的 inode id
![inodeid](1503226895173.png)
如果有一个文件名很奇怪，无法使用正常的 rm 命令删除，比如：“ab*  
那么可以使用 `find . -inum xxxx -delete` 命令删除    
![findcmd](findcmd.png)
`df -i`：查看inode资源的使用情况
![dfi](dfi.png)
可以清楚看到inode的最大使用数目。
<!-- more -->
也可以使用 find 命令找出文件所在目录
![dir](dir.png)
