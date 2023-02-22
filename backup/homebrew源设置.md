---
title: homebrew源设置
date: 2020-07-12 23:16:07
categories: fantastic
tags:
description: 给homebrew换源，解决install时homebrew update卡住的问题
---

在使用homebrew安装软件时，会先卡在Updating Homebrew这里。解决方案有两种：

*   使用ctrl+c跳过update
*   给homebrew换一个国内源

homebrew国内的源有很多，主要有中科大、清华、阿里等等。试了下，发现中科大的源在稳定性及更新速度上有优势。因此以下叙述换中科大源的步骤（ 参考：https://lug.ustc.edu.cn/wiki/mirrors/help/brew.git ）。

### 更换
```shell
# 替换brew.git
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

# 替换homebrew-core.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

# 替换bottles源
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile
```

### 重置（回滚到官方源）
```shell
# 重置brew.git
cd "$(brew --repo)"
git remote set-url origin https://github.com/Homebrew/brew.git

# 重置homebrew-core.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://github.com/Homebrew/homebrew-core.git

# 重置bottles源
# step1. 在~/.bash_profile中删掉HOMEBREW_BOTTLE_DOMAIN配置
# step2. 重置变量
unset HOMEBREW_BOTTLE_DOMAIN
```
