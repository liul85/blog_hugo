---
categories:
- docker
date: '2014-11-20'
tags:
- fig docker
title: 用fig管理docker
url: /2014/11/20/use-fig-manage-docker
---



Fig 可以非常方面的管理自己常用的容器，非常方便的定义自己的多service。
来个例子了解一下fig的方便快捷，比如项目中有多个services，如果用docker来将它玩起来，你可以这么写

```yaml
module1:
  image: java:openjdk-8
  volumes:
    - ~/project/module1:/source
    - ~/.gradle:/root/.gradle
  working_dir: /source
  links:
    - module2
    - redis
  command: ./gradlew run

module2:
  image: ruby
  volumes:
    - ~/project/module2:/source
  working_dir: /source
  command: sh -c 'bundle install --path vendor/bundle && bundle exec rake run'

redis:
  image: redis
```
  
可以看到在fig.yml中定义了3个task，module1、module2和redis，每个中都用```image```指定了docker run的用的image，用```volumes```指定了要mount的目录，```working_dir```指定了container的默认工作目录，```links```指定这个task依赖的其他jobs，将多个containers link到一起，```command```指定了container中run的命令。

如果要run这个项目，只需要跑```fig run module1```, fig会自动将link的job的container也一起run起来，这样整个项目的services就会很方便的管理起来。

访问[fig](http://www.fig.sh/)官网来了解更多yml格式和其他应用场景。