#!/usr/bin/env python
#-*- coding:utf8 -*-

# 关键问题：
# - 什么时候共享变量
# - 会不会阻塞


# multiprocessing
# https://docs.python.org/2/library/multiprocessing.html

## process 之间传递数据
# 这个Queue是线程&&进程安全的
from multiprocessing import Queue

# Pipe的特点是它是双工的, TODO: 这个和两个队列有什么区别呢
from multiprocessing import Pipe

# 这个锁可以用于同步
from multiprocessing import Lock

# 共享内存
from multiprocessing import Value, Array

# 似乎是个新东西
# 1) 支持丰富的数据，由server process 管理，其他进程可以共享。
# 2) 可以通过网络共享
# 3) 速度比Value 和 Array慢一点
# 有下面的地方不懂
# 1) 什么叫 allows other processes to manipulate them using proxies ?????? 什么叫 proxies
# 2) Also, a single manager can be shared by processes on different computers over a network. 居然支持不同机器的进程之间通信，太强大了吧 ????
# 3) 什么叫 server process
# 要注意的地方
# 1) proxy object是进程安全的，但是不是线程安全的。
from multiprocessing import Manager
Manager()


## multiprocessing编程的原则
# multiprocessing 假设所有的子进程都可以 import父进程的 main module, 所以如果父进程无法被import进来，那么会报错
# 1. 主要不要产生僵尸进程
# 1. 使用Queue的process会卡在那里，join时会导致调用join的进程也被卡主，最终产生死锁。
# 1. 虽然在Unix下可以 不要使用全局变量在父子进程中实现共享，但是windows不行， 而且父进程相应的全局变量被回收会导致子进程出问题。
# 1. multiprocessing会把stdin close掉，对它读取可能会出错