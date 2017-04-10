+++
menu = ""
Categories = ["Development","Golang"]
date = "2017-04-01T08:35:21+08:00"
title = "functional programming 2"
Tags = ["development","golang"]
Description = ""

+++

# 柯里化(curry)
在了解了纯函数的概念后，我们肯定都期望后面运用函数式编程写出来的都是纯函数，我们需要一些工具来辅助我们做这些任务，柯里化(curry)就是一个非常重要的工具。

> 柯里化：只传递给函数一部分参数，然后返回一个函数来接收剩余的参数，我们可以一次性传所有参数来得到计算结果，也可以顺序传递多次参数，分多次调用得到结果。

举个例子：
```javascript
const add = R.curry((x, y) => {
  return x + y;
});

//get 3
add(1, 2)

//get a new function
const f1 = add(1)

//call the new function, get the result 3
f1(2)
```

我们定义了一个柯里化后的加法函数，可以直接传递2个参数给这个函数它会立即返回结果。也可以只传递一个参数，它会返回一个新的函数，这个函数接收一个参数，再次调用这个函数会返回最终结果。

再看一个例子：

```javascript
const formatName = R.curry((firstName, middleName, lastName) => {
  return `${firstName} ${middleName} ${lastName}`;
});

const formatDavid = formatName('David', 'M')

//get 'David M Xie'
formatDavid('Xie')

//get 'David M Dou'
formatDavid('Dou')

const formatJames = formatName('James')

//get 'James L Jones'
formatJames('L', 'Jones')
//get 'James R Paul'
formatJames('R', 'Paul')
```

会发现代码的reuse非常方便。而且我们特意把变化的数据，放在最后，函数的逻辑跟数据完全没有关系，让reuse会更方便，一会就能看到这样的好处。

最近在写一个api通过solr来作搜索查询，需要从用户的requestModel中拿到请求的条件，然后转成solr的query去solr中作search，其中用了不少柯里化，使整个代码看起来清晰不少。

```javascript
module.exports = (request) => {
 let query = solr.createClient().query()

 return R.compose(
    buildRows(request),
    buildStart(request),
    buildSearchRange('price', request.minPrice, request.maxPrice),
    buildSearchRange('area', request.minArea, request.maxArea),
    buildSearchRooms('bedroom', request.bedroom),
    buildCustomText(request),
    buildSortBy,
  )(query)
}

const buildRows = R.curry((request, query) => {
  if (request.rows) {
    query.rows(request.rows)
  } else {
    query.rows(20)
  }
  return query
})

const buildStart = R.curry((request, query) => {
  if (request.offset) {
    query.start(request.offset)
  }
  return query
})

const buildCustomText = R.curry((request, query) => {
  if (request.keyword) {
    query.q(request.keyword).df('keywords')
  }

  return query
})

const buildSearchRange = R.curry((fqField, min, max, query) => {
  if (min && max) {
    query.matchFilter(fqField, `[${min} TO ${max}]`)
    return query
  }

  if (min) {
    query.matchFilter(fqField, `[${min} TO *]`)
  }

  if (max) {
    query.matchFilter(fqField, `[* TO ${max}]`)
  }

  return query
})

const buildSearchRooms = R.curry((fqField, filterValue, query) => {
  if (filterValue) {
    query.matchFilter(fqField, filterValue)
  }

  return query
})

const buildSortBy = (query) => {
  query.sort({feature: 'desc', dorder: 'desc'})
  return query
}
```
在上面的代码中，主要逻辑是要根据requestModel中的不同field来构造不同的solr query条件，通过几个不同的函数来处理自己的逻辑，最后调用compose把她们组合起来得到最终的结果, 这几个函数都被柯里化了，在组合的时候只传给他们一部分参数，返回一个新的function，然后在组合调用最外面把最后一个参数传递进去，经过这一串的函数处理后，便得到了最终计算结果。其实compose中就是一个pipeline，我更倾向于使用pipe操作。

# 组合 (compose)

