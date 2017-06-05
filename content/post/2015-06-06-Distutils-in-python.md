---
categories:
- python
date: '2015-06-06'
tags:
- distutils
- python
title: Distutils in Python
url: /2015/06/06/distutils-in-python
---


总结一下使用python的distutils来分发自己的python程序。
# writing setup script
在你要分发的项目根目录中创建一个setup.py, 一个最基本的setup.py文件:

```python
from distutils import setup

setup(
    name = 'foo',
    version = '0.1',
    author = 'Zhang San',
    author_email = 'szhang@github.com',
    description = 'Python Distutils',
    packages = ['bar']
)
```

程序目录如下

```sh
├── MANIFEST.in
├── README
├── script
│   ├── __init__.py
│   └── hello.py
└── setup.py
```

- 我们可以看到在要分发的包的所有信息都是通过关键参数传给setup函数的，
- 关键参数分为2类，
  - 一类是包的metadata，包括name, version, number.
  - 另一类是包内包含内容的信息，比如packages, scripts.
  
#### 声明所有模块
packages关键参数可以告诉distutils处理所有的python包, packages写成一个list来声明包。比如packages=['foo','bar'], 那么你必须保证有`foo/__init__.py` and `bar/__init__.py`这个文件, 这是一个约定. 

如果你不想用这种约定的方式也可以，你可以再添加上package_dir来告诉distutils你的分发中有哪些package, 比如在根目录下的lib目录包含所有代码，根目录的包在lib下，foo包下的模块也都在lib/foo目录下,那可以这么写 `package_dir={'':'lib'}`

```sh
├── MANIFEST.in
├── README
├── lib
│   ├── __init__.py
│   ├── hello.py
│   └── foo
│           ├── __init__.py
│           └── module_foo.py
└── setup.py
```

另外一种可能的就是foo包在lib目录下，foo.bar包在lib/bar目录下，那么需要写成`package_dir={'foo':'lib'}`
  
#### 安装包里的数据
有些跟包相关的数据文件经常需要也被安装，用`package_data`来声明：

例如这样一个包
```sh
setup.py
src/
    mypkg/
        __init__.py
        module.py
        data/
            tables.dat
            spoons.dat
            forks.dat
```

```sh
setup(
    ...,
    packages=['mypkg'],
    package_dir={'mypkg':'src/mypkg'},
    package_data={'mypkg':['data/*.dat']}
    )
```

`data_files`用来声明一些配置文件，消息分类文件，数据文件等等。
```python
setup(...,
      data_files=[('bitmaps', ['bm/b1.gif', 'bm/b2.gif']),
                  ('config', ['cfg/data.cfg']),
                  ('/etc/init.d', ['init-script'])]
     )
```

#Creating source distribution

use `python setup.py sdist` to create a source distribution.
sdist 只会将你在setup.py中声明的一些文件打进去， 它们是：
- 在`py_module`和`packages`中写的Python代码文件
- 在`ext_module`中写的所有C源码
- 在`scripts`中写的程序
- README.txt, setup.py, setup.cfg
- `package_data`中的文件
- data_files中的文件

#### 在MANIFEST.in中添加文件
在MANIFEST.in中写的文件会在执行sdist打包的时候也打进去
一个例子：
```python
include *.txt
recursive-include examples *.txt *.py
prune examples/sample?/build
```

常用的命令有
`include part1`
`exclude part1`
`recursive-include dir part1`
`recursive-exclude dir part1`
`prune dir`
