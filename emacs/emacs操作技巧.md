---
title: emacs操作技巧
date: 2023-04-13 21:54:28
categories: emacs
author: 童荣
tags:
---

:::tip
介绍emacs的一些操作技巧
:::

<!-- more -->

## 编译 ##

emacs源码编译步骤如下：

``` shell
./autogen.sh
./configure --with-json --with-native-compilation # 用于lsp提速，需先安装jansson-devel、libgccjit-devel、texinfo
make bootstrap && make && make install
```

## 括号 ##

介绍与括号相关的光标跳转、代码折叠等操作

### 跳转 ###

| key   | operation      |
|-------|----------------|
| C-M-n | 匹配前序       |
| C-M-p | 匹配后序       |
| C-M-u | 匹配外一层前序 |
| C-M-d | 匹配内一层前序 |


### 折叠 ###

> 开启hs-minor-mode

| key       | operation        |
|-----------|------------------|
| C-c @ C-a | hs-show-all      |
| C-c @ C-t | hs-hide-all      |
| C-c @ C-s | hs-show-block    |
| C-c @ C-h | hs-hide-block    |
| C-c @ C-c | hs-toggle-hiding |


## fill ##

介绍与折行相关的操作

* auto-fill-mode: 自动折行（在markdown编辑下很有用）
* fill-paragraph: 本段折行
* fill-region: 选中文本折行
