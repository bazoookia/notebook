---
title: shell常用命令
date: 2023-04-13 16:24:03
categories: toolkit
author: 童荣
tags:
---

:::tip
介绍一些shell常用命令
:::

<!-- more -->

## curl ##
  * 发送二进制请求
  
  ``` shell
  curl --data '@file_name'
  ```
  * 获取执行信息

  ``` shell
  curl -w '%{time_total}' -w '%{http_code}' 
  ```
  * 添加请求头

  ``` shell
  curl -H 'Content-Type: application/json'
  ```
  * 查看返回头

  ``` shell
  curl -I
  ```
  * dump header

  ``` shell
  curl -D
  ```
  * follow redirect

  ``` shell
  curl -L
  ```
  
## git ##
  * 查询包含指定commit id的分支

  ``` shell
  git branch --contains commitid
  ```
  * clone大规模repo

  ``` shell
  git clone --depth 1
  git remote set-branches origin '*' or git remote set-branches origin branch_name # 关联远程分支
  git fetch branch_name
  git checkout branch_name
  ```
  * git查看指定commit id修改的文件

  ``` shell
  git show commitid --name-only
  git log -name-only
  ```
  * 配置全局ignore

  ``` shell
  git config --global core.excludesfile ~/.gitignore
  ```
  * 将文件标记为已解决

  ``` shell
  git add -u
  ```
  * merge回滚

  ``` shell
  git revert current_commit -m [1|2] # 回滚一次merge
  git merge --abort # 终止merge
  ```
  
## gdb ##
  * 汇编代码

  ``` shell
  set disassemble-next-line on  # set
  disassemble					# 查看汇编代码
  si							# step
  i r $xx						# 查看寄存器中的值
  ```

  * 多线程
  
  ``` shell
  set scheduler-locking step	# set
  t xx							# 切换线程
  info t						# 查看线程
  ```
  
  * 信号

  ``` shell
  signal xx						# 向调试程序发送信号
  ```
  
  * 记录调试日志

  ``` shell
  set logging file xx
  set logging on
  ```

## llvm ##

  * 编译成可读指令文件(.ll)

  ``` shell
  clang++ -std=c++20 -emit-llvm -g 1.cc -S -o 1.ll
  ```

  * 编译成bitcode(.bc)

  ``` shell
  clang++ -std=c++20 -emit-llvm -g 1.cc -o 1.bc
  ```

  * .bc to .ll

  ``` shell
  llvm-dis 1.bc
  ```
  
  * .ll to .bc

  ``` shell
  llvm-as 1.ll
  ```
  
  * .bc to .s

  ``` shell
  clang++ -S 1.bc -o 1.s
  ```
