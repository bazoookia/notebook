---
title: 使用tmux管理开发环境
date: 2020-09-08 13:56:32
categories: fantastic
tags:
description: 使用tmux管理开发环境
---

## 能解决什么问题

如果你经历过下面的场景:

1.  在服务器上开发运行时，由于断网死机等原因引起终端窗口关闭，经营多年的窗口工作区毁于一旦
2.  在开发或者自测diff时，被拆分后的多套环境部署搞的晕头转向，终端窗口打开一堆
3.  在测试工具中输入开发机IP地址时，频繁hostname -i或者翻记事本（也可以通过修改PS1，缺点是容易淹没在标准输出中）

那可以使用tmux。作为跑在服务器上的终端管理工具，tmux能方便的进行会话管理，解决上面遇到的问题（参见[场景使用](#场景应用)）。


## 安装

```shell
sudo yum -y install tmux
```

## 命令介绍 

tmux包含了session、window和pane。一个session可以开多个window，一个window可以开多个pane。

### 操作session

1.  进入session
从终端进入tmux，主要有两个命令

    * tmux new-session: 创建新的session并进入
    * tmux attach-session: 进入创建好的session中

```shell
# -s: session名称
tmux new-session -s dev

# -t: sessiion名称
tmux attach-session -t dev
```

2.  杀掉session

```shell
# 杀掉指定的session。 -t: session名称
tmux kill-session -t dev
# 杀掉tmux
tmux kill-server
```

3.  切换session

快捷键|功能
-|-
c-b d|detach，回到默认的终端环境
c-b s|显示session，在该界面使用j,k,h,l或者[n]选择不同的session，回车进入

### 操作window

快捷键|功能
-|-
c-b c|在当前session中新建窗口
c-b ,|更改当前窗口名称
c-b x|关闭当前窗口（在没有分屏的情况下)
c-b [n]|在当前session中切换不同编号的窗口
c-b w|预览window（相当于c-b s的展开）

### 操作pane（分屏）

快捷键|功能
-|-
c-b %|竖向分屏（宽屏福音）
c-b "|横向分屏（小屏必备）
c-b x|关闭当前pane
c-b o|切换到不同的pane

### 加载tmux配置

tmux的默认配置文件为~/.tmux.conf，启动时自动加载。或使用如下命令手动加载:

```
c-b :
source ~/.tmux.conf
```

## 场景应用

### 快速恢复窗口工作区: 适用于断网或者电脑重启后

登陆到服务器上，然后tmux attach到任意一个session即可。从此可以告别nohup，不用担心后台还偷跑着上次启动后没杀掉的进程（如果要统计输出还是nohup好）

### 管理环境: 适用于跑diff，多环境部署

在跑diff时，可以创建2个session（每个session对应一套环境），每个session中有3个window（每个window对应一个应用），结构如下:

```
#(0) - DEV: 3 windows
#(1) ├─> + 0: rb (2 panes)
#(2) ├─> + 1: rs (2 panes)
#(3) ├─>   2: tbt* (1 panes)
#(4) - ORI: 3 windows
#(5) ├─> + 0: rb (2 panes)
#(6) ├─>   1: rs* (1 panes)
#(7) └─>   2: tbt- (1 panes)
```

上面的结构有两个优势:

1.  快速预览当前环境中每个应用部署的分支

      在~/.tmux.conf中添加:

      ```
	  set -g window-status-format '#I:#(pwd="#(basename #{pane_current_path})"; gp="#(cd #{pane_current_path} && basename \`git rev-parse --show-toplevel\`)"; gbr="#(cd #{pane_current_path} && git symbolic-ref --short HEAD)"; echo #F\${gp:=\${pwd}}\\(\${gbr:=#W}\\))'
	  set -g window-status-current-format '#I:#(pwd="#(basename #{pane_current_path})"; gp="#(cd #{pane_current_path} && basename \`git rev-parse --show-toplevel\`)"; gbr="#(cd #{pane_current_path} && git symbolic-ref --short HEAD)"; echo #F\${gp:=\${pwd}}\\(\${gbr:=#W}\\))'
	set -g status-interval 1
      ```

      PS: 上面的配置缺点是刷新慢，简陋，优点是配置简单。有需要可以自行寻找插件。


2.  一键checkout并build

    * 依赖条件

      在~/.tmux.conf中添加:

      ```
      # 在当前session下的所有pane的命令行执行命令
      bind e command-prompt -p "Command:" "run \"tmux list-windows -F '##S:##W' | xargs -I window tmux send-keys -t window '%1' C-m \""
      ```

    * 使用

      ```
      c-b e git checkout dev      # 所有window切换到dev分支，omz用户可以使用gco dev
      c-b e git submodule update  # 更新proto，omz用户可以使用gsu
      c-b e ./build.sh            # 一键build
      ```

### 在状态栏中显示开发机IP

在~/.tmux.conf中添加:

```
set -g status-right '#[fg=black]#(hostname -i) %H:%M %d-%b-%y'
```


### 分屏时进入与当前pane相同的目录: 适合查找日志，修改配置等等

在~/.tmux.conf中添加

```
bind '"' split-window -c "#{pane_current_path}"
bind '%' split-window -h -c "#{pane_current_path}"
```
