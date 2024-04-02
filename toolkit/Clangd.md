---
title: Clangd
date: 2024-04-02 14:10:11
categories: toolkit
author: 童荣
tags:
---
:::tips Clangd -- linux下最趁手的C++ LSP ::: <!-- more -->

## 为什么选Clangd ##

目前用过的C++的lsp主要有ccls和clangd。力挺clangd的原因，主要是llvm下有
个clangd-indexer的存在，在大项目中非常有用。

### clangd-indexer ###

#### 简介 ####

实际使用lsp类的插件时，总会遇到一个问题：当项目较大时，使用
find-refrence功能时总会漏掉一些代码位置（尤其是未打开过的文件）。此时
就需要clangd-indexer登场。

按照官方说法，clangd-indexer是一个调试工具，用来根据compile db生成全量
的index索引。这个功能配合clangd的load cache选项，正好决上面的问题。但
是由于定位是一个调试工具，因此并未在发行的tools-extra中包含，需要源码
编译。而且之前发现一个比较坑的地方，是clangd的版本需要和clangd-indexer
的版本对应。


#### 使用 ####

``` shell
# 生成cache
clangd-indexer --executor=all-TUs --execute-concurrency=256
compile_commands.json > ./clangd.dex

# 加载cache
clangd --index-file=./clangd.dex
```

### 配置clangd ###

clangd支持单独配置编译选项等，可以方便的解决诸如"too many errors
emitted, stopping now"后停止解析的问题。

可以全局配置（$XDG_CONFIG_HOME/clangd/config.yaml），也可以分项目配置
（${PROJECT_ROOT}/.clangd）。

比如遇到上面的问题，可以进行如下配置：

``` shell
CompileFlags:
  Add: -ferror-limit=0
```

### compile db的朋友们 ###

clangd依赖的compile_command.json并不一定是存在的，也不一定是可靠的。比
如，用makefile构建的项目不会生成compile_command.json；而即使用cmake构
建，由于各种原因，有些头文件也没有包含在compile_command.json中。这会导
致clangd抛出诸如"cannot find include file"的抱怨，然后停止工作。

compdb和bear是compile db的实用工具。实际实用时，可能更多会用到
compdb（不少工作系统可能查不到bear的发行包，而源码编译依赖了太多的
github三方库而困难重重）。

#### compdb的安装及使用 ####

``` shell
# 安装
sudo pip install compdb

# 使用
compdb -p ./build list > ./compile_commands.json
```


