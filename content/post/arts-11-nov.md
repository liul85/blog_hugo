---
title: "Arts 11 Nov"
date: 2018-11-12T13:47:24+08:00
tags: []
---

# Algorithm
1. 链表反转
```java
    public SingleLinkedList reverse() {
        if (head == null) {
            return new SingleLinkedList<T>(null);
        }

        Node<T> current = new Node<>(head.data, head.next);
        Node<T> prev = null;
        Node<T> headNode = null;

        while (current != null) {
            Node<T> nextNode = current.next;
            if (nextNode == null) {
                headNode = current;
            }
            current.next = prev;
            prev = current;
            current = nextNode;
        }

        return new SingleLinkedList<T>(headNode);
    }
```
代码[在这](https://github.com/liul85/algorithms/blob/master/src/main/java/Y2018/Nov/A11th/SinglyLinkedList.java#L81)

2. 链表中环的检测
```java
    public boolean circled() {
        if (head == null) return false;

        Node slow = head;
        Node fast = head.next;

        while (slow != null && fast != null) {
            if (slow == fast) {
                return true;
            }

            slow = slow.next;
            fast = fast.next.next;
        }

        return false;
    }
```
代码[在这](https://github.com/liul85/algorithms/blob/master/src/main/java/Y2018/Nov/A11th/SinglyLinkedList.java#L115)

3. 有序链表的合并
```java
    public SinglyLinkedList<T> sortedMerge(SinglyLinkedList<T> rightLinkedList) {
        Node<T> rightHead = rightLinkedList.getNodeByIndex(0);
        if (rightHead == null) {
            return this;
        }

        if (head == null) {
            return rightLinkedList;
        }

        Node<T> lHead = new Node<>(head.data, head.next);
        Node<T> rHead = new Node<>(rightHead.data, rightHead.next);
        Node<T> newHead;

        if (lHead.data.compareTo(rHead.data) < 0) {
            newHead = lHead;
            lHead = lHead.next;
        } else {
            newHead = rHead;
            rHead = rHead.next;
        }

        Node<T> temp = newHead;

        while (lHead != null && rHead != null) {
            if (lHead.data.compareTo(rHead.data) < 0) {
                temp.next = new Node<>(lHead.data, lHead.next);
                lHead = lHead.next;
            } else {
                temp.next = new Node<>(rHead.data, rHead.next);
                rHead = rHead.next;
            }

            temp = temp.next;
        }

        if (lHead != null) {
            temp.next = new Node<>(lHead.data, lHead.next);
        } else {
            temp.next = new Node<>(rHead.data, rHead.next);
        }

        return new SinglyLinkedList<>(newHead);
    }
```
代码[在这](https://github.com/liul85/algorithms/blob/master/src/main/java/Y2018/Nov/A11th/SinglyLinkedList.java#L133)

4. 删除链表倒数第n个节点
```java
    public void deleteNth(int i) {
        Node fast = head;
        int p = 1;
        while (fast != null && p < i) {
            fast = fast.next;
            p++;
        }

        if (fast == null) return;

        Node slow = head;
        Node prev = null;

        while (fast.next != null) {
            fast = fast.next;
            prev = slow;
            slow = slow.next;
        }

        if (prev == null) {
            head = null;
            return;
        }

        prev.next = prev.next.next;
    }
```
代码[在这](https://github.com/liul85/algorithms/blob/master/src/main/java/Y2018/Nov/A11th/SinglyLinkedList.java#L192)
5. 找链表的中间节点
```java
    public Node findMiddleNode() {
        if (head == null) return null;

        Node<T> slow = head;
        Node<T> fast = head;

        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }

        return slow;
    }
```
代码[在这](https://github.com/liul85/algorithms/blob/master/src/main/java/Y2018/Nov/A11th/SinglyLinkedList.java#L178)

# Review
[Learning programming is different from learning a programming language](https://phpocean.com/blog/article/learning-programming-is-different-from-learning-a-programming-language/80)

这篇文章作者阐述了一个非常普遍的现象，很多程序员在学习programming的时候太关注某个语言的细节以及框架，认为掌握这门语言就是编程高手，牛逼的程序员。不可否认由于软件行业的发展带来的要求以及编程门槛的降低，很多从业者都只是在一两种语言及其生态中工作，堆砌业务代码，即是我们俗称的“码农”，导致programming的本质被忽视，好多程序员感到自己工作好多年仍然没有质的提升，可能都跟这个有关系。作者讲道CS专业的课程上学习的都是算法和数学，而非学习计算机，CS其实就是学习用软件用programming的方式解决问题的技能。

`We solve problems with programming and programming languages are tools which help us do that.`



# Tech/Tips
如何写出更牛逼的bash script -> [pure-bash-bible](https://github.com/dylanaraps/pure-bash-bible)

# Sharing
技术领导力的体现:

>
* 能够发现问题
* 能够提供解决问题的思路和方案，提出各种方案的优缺点，选择适合当前项目情况的方案
* 能够激发团队成员的积极性和潜力，正确的人做正确的事。
* 不断创新

如何拥有：

>
* 稳固扎实的基础知识（编程和计算机系统能力）
* 持续学习的能力（学习的途径，方法）
* 坚持用正确的方法做正确的事（在我之前的项目中深有体会)
* 与人沟通能力（别以为技术牛逼就没事了，任何事情都离不开跟人打交道，你有牛逼的技术还得带领团队去实现，沟通少不了）
* 不断提升自我要求

参考：[左耳听风](https://time.geekbang.org/column/intro/48)