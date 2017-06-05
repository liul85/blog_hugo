---
date: 2016-03-01T19:55:51+08:00
title: Migrate from sqlite to mysql
url: /2016/03/01/migrate-from-sqlite-to-mysql
---

在开发环境中用的一直是sqlite，side project做出来后，就赶紧上线了，然后发现公司里注册人已经好多，看来得迁移到mysql上去了，不然感觉得天天备份db文件。
™
sqlite3 有dump命令可以直接把db文件转成sql

```sh
$ sqlite3 dbname .dump > dbname.sql
```
sqlite和mysql有一些语法差异需要修改一下，可以用这个[脚本](http://www.redmine.org/attachments/download/6239/sqlite3-to-mysql.py)来实现

```sh
cat dbname.sql | python sqlite3-to-mysql.py > db_mysql.sql
```

然后在mysql中创建数据库，这里记得如果你有中文字符，一定要将数据库默认编码设置为utf-8，否则是乱码。

```sh
[mysql> CREATE DATABASE dbname CHARACTER SET utf8 COLLATE utf8_general_ci;
```

最后就是在mysql中迁移数据了。

```sh
mysql -u username -p dbname < dbname.sql
```

done!
