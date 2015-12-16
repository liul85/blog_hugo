---
categories:
- articles
date: '2013-08-04'
description: some pygments skills
tags:
- jekyll
- pygments
title: 使用pygments在博客中让代码高亮
url: /2013/08/04/highlighting-code-in-jekyll-with-pygments
---


在天津出差无聊期间又折腾了一下博客，换掉了以前的octopress，用jekyll搭建了轻量的静态博客，最近来杜塞，闲暇时间又在看ruby，中间会写一些笔记，发现在blog中代码没有高亮，于是研究了下jekyll的官方[documentation](http://jekyllrb.com/docs/templates/)，做了一下代码高亮。

### 在本地安装pygments

由于mac上默认已经安装了python，我们只需要去[python](https://pypi.python.org/pypi/Pygments)网站上下载Pygments-1.6.tar.gz.
下载解压后在本地安装
```python
$ sudo python setup.py install
```

### 查看pygments中的代码高亮样式

```python
>>> from pygments.styles import STYLE_MAP
>>> STYLE_MAP.keys()
['monokai', 'manni', 'rrt', 'perldoc', 'borland', 'colorful', 'default', 'murphy', 'vs', 'trac', 'tango', 'fruity', 'autumn', 'bw', 'emacs', 'vim', 'pastie', 'friendly', 'native']
```

### 将选择的样式转成css到blog目录中
```sh
$ cd /Blog/xxxx.github.com/
$ pygmentize -S colorful -f html > assets/themes/twitter/css/pygments.css
```

其中-S 后面参数是你选择的样式,可以去css目录下查看生成了pygments.css

### 在blog的layout中引用刚才生成的css
由于我使用了bootstrap的twitter主题，我的目录是在_includes/themes/twitter/下，打开default.html文件，添加css
```html
<link href="{{ ASSET_PATH }}/css/pygments.css" rel="stylesheet">
```

这样就基本ok了，可以在本地看下代码高亮效果。

对了，在Markdown中高亮后面带上linenos，就可以显示行号，参考jekyll的[文档](http://jekyllrb.com/docs/templates/)

```ruby
def foo
    puts 'foo'
end
```