---
title: bthread和pthread
date: 2023-05-05 17:29:59
categories: brpc
author: 童荣
tags:
---
:::tip
记录一次pthread和bthread使用不当导致服务hang的问题
:::

<!-- more -->

线上服务使用brpc框架处理请求。一次看似寻常的修改，导致服务hang住。简略代码如下：

``` c
int Process() // 请求处理函数入口
{
    ...
    // 并行访问下游服务，使用async实现
    int outer_svc_req_num {5};
    std::vector<std::future<bool>> res(outer_svc_req_num);
    for (int i = 0; i < outer_svc_req_num; ++i) {
        res[i] = std::async(std::launch::async, &RequestRemoteSvc, ...);
    }
    ...
    for (int i = 0; i < outer_svc_req_num; ++i) {
        res[i].get();
    }
}

bool RequestRemoteSvc(...)
{
    ...
    channel->CallMethod(...); // 此处调用brpc的CallMethod方法请求下游服务那结果
    ...
}
```

小流量测试时，并未发现异常。但在预发环境下，服务hang住，各接口均不可用。经过分析，原因是这种写法会导致运行bthread的task group被打满并处于wait状态，导致无法再调度bthread。这要从bthread的运行和调度机制说起。

## bthread的运行/调度机制 ##

bthread由task control负责调度，在brpc初始化时，首先创建了concurrency个pthread worker，用于运行bthread。每个worker对应一个task group（tls_task_group），该结构维护两个任务队列：remote queue和stealing queue，每次在队列中获取一个bthread并执行。

## hang住的原因 ##

brpc启动的worker线程是有限的，默认情况下与机器核数相同。当大量并发请求到来时，worker线程会被填满。根据上面的代码，每个worker线程还会通过std::async创建后台线程，通过这些后台线程又创建了一系列的bthread task（通过RequestRemoteSvc）。然后问题就来了。worker线程卡在join创建出来的线程上，而这些通过async创建的线程又在等待bthread的返回（channel->CallMethod），而bthread又在等待worker线程调度，形成了一个完美的闭环，锁死了。

## 如何解决 ##

解决方案并不复杂，将std::async换成bthread即可解决该问题。

