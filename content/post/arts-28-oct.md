---
title: "ARTS 28 Oct"
date: 2018-10-28T17:22:36+08:00
tags: ["ARTS"]
---

## Algorithm
bubble sorting 冒泡排序

``` java
package sort;

public abstract class AbstractSort<T extends Comparable<T>> {
    public abstract void sort(T[] collection);

    boolean lessThan(T first, T second) {
        return first.compareTo(second) < 0;
    }

    void swap(T[] collection, int i, int j) {
        T temp = collection[i];
        collection[i] = collection[j];
        collection[j] = temp;
    }
}

public class BubbleSort<T extends Comparable<T>> extends AbstractSort {
    @override
    public void sort(T[] collection) {
        int length = collection.length;

        for(int i = length -1; i > 0; i--) {
            for (int j = 0; j < i; j++) {
                if (lessThan(collection[j + 1], collection[j])) {
                    swap(collection, j, j + 1);
                }
            }
        }
    }
}
```
best case time complexity - O(n^2)

worse case time complexity - O(n^2)
## Review
[why use GraphQL](https://honest.engineering/posts/why-use-graphql-good-and-bad-reasons)

作者分析了选用GraphQL合理的原因和不make sense的原因，告诉大家在选择它时候要冷静分析，自己面对的问题是什么，用GraphQL是否一定会解决问题，不要因为GraphQL很火，追求技术潮流而去用它，要从自己实际项目需求出发。其中对与GraphQL和Rest的阐述可以好好看看，很多人都会有类似的问题和概念混淆。
## Technical/Tips
图解HTTPS对话过程

[The Illustrated TLS Connection](https://tls.ulfheim.net/)
## Share
学习一个技术的方法，帮助系统化理解和掌握.
the way to understand and master a new technology sysmatically.

> 1. 这个技术出现的背景、初衷和要达到什么样的目标或是要解决什么样的问题。  
> what's the background when this tech came out, what kind of problem it gonna to solve.
> 2. 这个技术的优势和劣势是什么。  
> what's the pros and cons.
> 3. 这个技术适用的场景。  
> the scenarios this technology works.
> 4. 这个技术的组成部分和关键点。  
> the key components.
> 5. 这个技术的底层原理和关键实现。  
> the low lever principle and implementations.
> 6. 已有的实现和它之间的对比。  
> comparasion between this new technology and existing teches. 

出自 极客时间-左耳听风-高效学习：深度，归纳和坚持实践 [原文](https://time.geekbang.org/column/article/14360)