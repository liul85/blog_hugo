+++
date = "2016-02-04T17:17:47+08:00"
description = ""
title = "opsschool_unix"

+++

## Unix fundamentals 101
---  
Just a test



## Unix fundamentals 201
---  
#### Kernel tuning
占位符
#### Signals
Signals 是在应用POSIX的系统如linux，unix或者类似unix系统上的进程间通信的一种形式。signal是总是由kernel来传递，可以是由kernel，进程自己，或其他进程产生。signals经常是一些列的信号，经常用它们的名字或者数字值来表示。比如SIGKILL，也可以用9来表示。

当一个进程收到一个signal时候，如何去处理取决于这个程序，最常用也最简单的是遵循默认的signal处理方法。也有一些情况下程序是有自己自定义的处理方式，并不一定遵循默认的。比如，很多守护进程在收到SIGHUP信号后会重新加载配置，其实默认的处理是挂起这个程序。

无论程序如何处理，当它收到一个signal之后它都会立即去处理这个信号，如果进程正在做一些原子操作，比如mv或者file locks等，它会等这个操作操作结束后理解执行收到的signal。

一般用 `kill` 命令来向某个进程发送signal  

```sh
kill -SIGINT <PID>
kill -s SIGNAL <PID>
```

也可以通过键盘来发送比如`ctrl+c`发送SIGINT，`ctrl+Z`发送SIGTSTP

#### Syscalls
我们写的程序都是会要跟系统内核去发一些请求来请求一些它不能处理的任务，比如读取文件，socket链接，建立进程等。system call就是程序和内核之间通信的接口。

看这个脚本
``` sh
#strace_sample.sh
#!/bin/bash
echo "one line of text" > my_input.txt
while read line
do
    echo $line > my_output.txt
done < my_input.txt
rm my_input.txt
```
我们来执行它，通过
```sh
strace -o my_trace.log -ff ./strace_sample.sh
```
在log中可以看到每一个fork出来的进程的输出，



