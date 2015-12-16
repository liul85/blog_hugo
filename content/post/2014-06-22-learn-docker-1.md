---
categories:
- docker
date: '2014-06-22'
tags:
- docker
title: Docker 入门
url: /2014/06/22/learn-docker-1
---


#### 什么是docker？
docker 是一个基于 linux container 的应用程序执行容器，类似于虚拟机的概念，但是比起虚拟机有轻量级的优势，

* 虚拟机技术是建立于物理硬件之上的，与本机操作系统共用硬件；而docker是利用 [LXC](https://linuxcontainers.org/) 技术构建在操作系统之上.
* 虚拟机大家一般都会理解到操作系统镜像，运行起操作系统后一个虚拟机可以做很多事情；作为docker，非常轻量，一般一个容器只会部署少量应用，比如一个redis服务，易于管理。
* 虚拟化技术构建操作系统时候比较复杂，而且启动慢，作为docker速度非常快。

#### docker 入门
可以参考官方[User Guide](http://docs.docker.com/userguide/)来学习。
我们简单介绍一下docker的安装

#### 用HomeBrew 安装 docker
首先用homebrew安装cask
{% highlight sh %}
$ brew tap phinze/homebrew-cask
$ brew install brew-cask
{% endhighlight %}
在OSX上运行docker还需要virtual box

{% highlight sh %}
$ brew cask install virtualbox
{% endhighlight %}

然后我们可以安装[boot2docker](https://github.com/boot2docker/boot2docker), boot2docker是一个linux下轻量级的运行docker的工具，用来管理docker的守护进程。

{% highlight sh%}
$ brew install boot2docker
$ boot2docker init
$ boot2docker up
$ export DOCKER_HOST=tcp://x.x.x.x:2375
{% endhighlight %}

然后我们就可以安装docker了

{% highlight sh %}
brew install docker
{% endhighlight %}

Done!

#### docker 简单应用

docker装好了，我们来做一些简单的事情吧。

不免俗套来个Hello World

{% highlight sh %}
$ docker run ubuntu /bin/echo 'Hello World'
Unable to find image 'ubuntu' locally
Pulling repository ubuntu
e54ca5efa2e9: Download complete
511136ea3c5a: Download complete
d7ac5e4f1812: Download complete
2f4b4d6a4a06: Download complete
83ff768040a0: Download complete
6c37f792ddac: Download complete
Hello World
{% endhighlight %}

```docker run``` 命令是运行一个docker容器，我们指定image是ubunt，然后docker会在本地寻找，如果本地没有，docker会去[Docker Hub](https://hub.docker.com/)上找，然后下载到本地，ubuntu这个容器起来后就会运行 ```/bin/echo 'Hello World‘``` 命令。

### docker常用命令  

- ```docker ps``` 查看当前运行的docker容器

- ```docker logs``` 查看一个容器的输出log，后面可以带上容器ID。

- ```docker stop``` 停止一个运行中的容器

- ```docker images``` 查看当前已有的image

docker run 的一些常用参数  

- ```-t``` 分配虚拟TTY终端  
- ```-i``` 保持std输出  
- ```-v``` 将本地目录mount到container中  
- ```-w``` 指定container run起来之后的默认工作目录  
- ```--rm``` run完后container自动删除  
- ```-e``` 指定container的环境变量  

下面这个命令run一个java8的container将本地的~/.gradle和~/src mount到指定目录，设置环境变量JAVA_TOOL_OPTIONS并执行gradlew run命令, run完之后自己删除container.
{% highlight sh%}
docker run -it -v ~/.gradle:/root/gradle -v ~/src:/root/source -w /root/source --rm -e JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8 java:openjdk-8 ./gradlew run
{% endhighlight%}