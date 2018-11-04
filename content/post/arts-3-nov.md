---
title: "ARTS 3 Nov"
date: 2018-11-03T20:32:29+08:00
tags: [ARTS]
---
## Algorithm

__Longest Substring Without Repeating Characters__ [leetcode](https://leetcode.com/problems/longest-substring-without-repeating-characters/)

大家都应该会想到这个最容易却最慢的算法,时间复杂度应该是O(n^2)
```Java
public int lengthOfLongestSubString(String s) {
    ArrayList<Character> subString = new ArrayList<>();
    ArrayList<Character> tempSubstr = new ArrayList<>();
    for (int i = 0; i < s.length(); i++) {
        tempSubstr.clear();
        for (int j = i; j < s.length(); j++) {
            char c = s.charAt(j);
            if (!tempSubstr.contains(c)) {
                tempSubstr.add(c);
            } else {
                break;
            }
        }
        if (tempSubstr.size() > subString.size()) {
            subString = tempSubstr;
        }
    }

    return subString.size();
}

```

有一个比较好的用区间来标识的算法(slide window)，设置一个可以滑动的半开半闭区间[i, j)来标识当前扫描的没有重复的subString，这个区间的右边会一直往右延伸，每扫描一个因为右边延伸而增加的字符，会判断是否在当前substring里，如果没有，则把它加进到Set中，然后计算最大未重复的数量为max(sizeOf(set), j - i),有重复的话，那么就从Set中删掉左边区间的值，左边区间往右挪。
``` java
public int lengthOfLongestSubString(String s) {
    HashSet<Character> subStr = new HashSet<>();
    int longestSubStrLength = 0, slideWindowLeft = 0, slideWindowRight = 0;

    while (slideWindowLeft < s.length() && slideWindowRight < s.length()) {
        if (!subStr.contains(s.charAt(slideWindowRight))) {
            subStr.add(s.charAt(slideWindowRight));
            slideWindowRight++;
            longestSubStrLength = Math.max(longestSubStrLength, slideWindowRight - slideWindowLeft);
        } else {
            subStr.remove(s.charAt(slideWindowLeft));
            slideWindowLeft++;
        }
    }

    return longestSubStrLength;
}

```

上面的算法中，如果往右延伸拿到一个新字符，在当前的substr里如果有重复的，但是不是在i的位置，那么会循环多次删除左边界i位置的字符直至那个重复的被删掉，比较低效。下面是一个改进的算法，利用hashmap来存储每个字符的位置，如果发现当前的subStr里已经包含当前检查的字符，则设置i为当前subStr中该字符的位置和当前i这两个的最大的那个，相当于直接跳过重复字符位置之前的其他字符。

``` java
public int lengthOfLongestSubString(String s) {
    HashMap<Character, Integer> subStr = new HashMap<>();
    int longestSubStrLength = 0;

    for (int i = 0, j = 0; j < s.length(); j++) {
        if (subStr.containsKey(s.charAt(j))) {
            i = Math.max(subStr.get(s.charAt(j)) + 1, i);
        }

        longestSubStrLength = Math.max(longestSubStrLength, j - i + 1);
        subStr.put(s.charAt(j), j);
    }

    return longestSubStrLength;
}

```

## Review
github.com 在21号发生了由于网络分区导致的一系列服务暂停的事故，事后github blog发布了[这篇文章](https://blog.github.com/2018-10-30-oct21-post-incident-analysis/)，来向用户透明的解释这次事故的时间窗，原因和后续改进措施。

在这篇blog里我们可以看到这次事故的直接原因是由于日常维护更换100G光纤设备导致东海岸和西海岸的数据中心通信中断大概43秒，在网络分区的43秒里管理mysql集群的内部工具Orchestrator根据配置策略发生了fail over，primary从东海岸切换到了西海岸，导致两个数据中心各有在中断期间写入的数据没有同步到对方，数据发生不一致，最终他们采取了一系列操作，在24小时之后终于解决了这次事故带来的影响，两个数据中心数据一致。

在这次事故中有一些点我觉得值得学习:

1. On-call响应非常快。从发生网络分区开始15分钟内，网站状态就从绿色->黄色->红色，更多的工程师加入解决问题。
2. 清晰决策很重要。在收到alarm后，意识到incident比较严重，即刻锁定所有部署流水线，防止更多的变更引入到prod。进一步分析定位后发现是由于fail over导致分区导致数据不一致，必须停止写操作，为了保证数据完整性，停止了webhook和Github Page build等，在这里选择C over A
3. 在分析清楚incident之后，制定了可行的计划来恢复数据，这部分里体现出日常的演习备份恢复非常重要。
4. 恢复之后及时输出技术改进点，例如调整Orchestrator的配置；在出现incient后以更清晰的status report来向用户提供当前状态，类似像AWS[这样](https://status.aws.amazon.com/); 加快master-master的技术方案和实施进度等。
5. 以报告的形式公开这次事故的详细情况，对于建立和修复用户信任非常重要。

看完之后想想自己这两年做的几个项目，都有通过多region来支持HA，有做的好的也有不好的。例如最近就发生过一次，我们一个region的API发生了比较诡异的问题，在收到pager后发现短期无法解决，立即将API切换到了另外一个healthy的region去，没有影响prod业务，在那个region的问题修复后，再切回去。 有些做的不好的，例如：prod DB备份的数据是否能够成功的恢复，整个恢复的时间大概需要多久，并不是经常会做，可能一年只做了一次。如果一个region发生宕机，如何快速切换到写入到另外一个region，在恢复之后另外一个region的数据如何同步保持一致，没有标准的流程文档，这些都是需要改进的。

## Technical/Tips
去年在客户的一个项目上工作，跟客户那边的工程师设计的REST API打交道(后来又工作在那个上面)非常的痛苦，例如，所有操作http status都返回200，不管成功失败，然后在response body里面有个自定义的code，谁也不知道那个自定义的每个代表什么意思。URL也是很乱，完全代表不了某个resource的状态和转移，这里有一篇ruanyifeng的[文章](http://www.ruanyifeng.com/blog/2018/10/restful-api-best-practices.html)描述REST API的最佳实践，也算是基础了。
## Share
分享一片关于工作流程和实践的思考 -> [如何在几十个 Repo 中游刃有余？](https://mp.weixin.qq.com/s/jyURunuToRyLwOFyeMrcQA)，我当时读完感觉启发和收获都很大，陈天的文章质量都非常高，推荐关注和订阅。