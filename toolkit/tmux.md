---
title: tmux
date: 2024-05-10 17:32:25
categories: toolkit
author: 童荣
tags:
---

:::tip
介绍tmux的常用操作和配置
:::
<!-- more -->

## iterm2直接进入tmux ##

``` shell
ssh user@host -t "tmux attach-session -t ALPHA || tmux new-session -s ALPHA"
```

## 常用快捷键 ##

| 分类    | 快捷键 | 功能         |
|:--------|:-------|:-------------|
| pane    | c-b %  | 竖向分屏     |
|         | c-b "  | 横向分屏     |
|         | c-b x  | 关闭当前pane |
|         | c-b o  | 切换pane     |
| window  | c-b c  | 新建窗口     |
|         | c-b ,  | 更改名称     |
|         | c-b p  | 前一个窗口   |
|         | c-b n  | 后一个窗口   |
|         | c-b w  | 预览window   |
| session | c-b s  | 预览session  |
| command | c-b :  | 执行tmux命令 |


## 配置运行的shell ##

``` shell
set -g default-shell /bin/zsh
```

## 状态栏配置 ##

``` shell
# 为每个窗口显示编号
bind c new-window -n '#{session_name}:#{window_index}'

# 设置右侧状态栏显示IP和时间
set -g status-right '#[fg=black]#(hostname -i) %H:%M %d-%b-%y'

# 设置非活动窗口的窗口名为git仓库名/目录名
set -g window-status-format '#I#F:[#(cd #{pane_current_path} &&
basename `git rev-parse --show-toplevel 2>/dev/null || pwd`)]'

# 设置活动窗口的窗口名为git仓库名/目录名
set -g window-status-current-format '#I#F:[#(cd #{pane_current_path}
&& basename `git rev-parse --show-toplevel 2>/dev/null || pwd`)]'

# 每秒刷新
set -g status-interval 1
```

## 将命令发送到当前session的所有窗口 ##

``` shell
bind e command-prompt -p "Command:" "run \"tmux list-windows -F '##S:##W' | xargs -I window tmux send-keys -t window '%1' C-m \""
```

## 一键清屏 ##

``` shell
# 在清屏的同时会设置分隔线，快捷方便
bind -n C-] send-keys -R\; send-keys "============ ******* ============\n"
```

## 分屏时仍进入当前目录 ##

``` shell
bind '"' split-window -c "#{pane_current_path}"
bind '%' split-window -h -c "#{pane_current_path}"
```

> **注意：**
> pane_current_path得到的路径是follow symbol link的。因此在某些
> 使用ccache的应用中，会出现分屏后需要重新删掉ccache才能再次编译的情况。
> 这个问题可以通过将cd命令映射为cd -P来解决（即cd时亦follow symbol
> link）

## 使用vi模式复制 ##

``` shell
set-window-option -g mode-keys vi
bind-key    -T copy-mode-vi C-u               send-keys -X page-up
```

> **注意：**
> 若要将复制结果粘贴到剪切板，需要iterm2中设置Applications in terminal
> may use clipboard（settings->general->selection）




