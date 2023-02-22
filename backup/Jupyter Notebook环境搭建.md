---
title: Jupyter Notebook环境搭建
date: 2020-05-25 16:08:28
categories: fantastic
tags:
description: 在服务器上搭建Jupyter Notebook服务
---

## 安装Jupyter
直接用pip就可以安装
```
pip install jupyter
```

如果遇到依赖库已安装但版本过旧，使用pip进行升级
```
pip install six -U
```

## 配置Jupyter
生成配置文件
```
jupyter notebook --generate-config
```

修改配置文件（~/.jupyter/jupyter_notebook_config.py）
```
c.NotebookApp.allow_remote_access = True
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 10086
c.ContentsManager.root_dir = '~/notebook'
```

## 启动Jupyter
用nohup在后台挂起
```
nohup jupyter notebook &
```

注意，启动后nohup.out中会显示token信息，用于在登录输入
```
The Jupyter Notebook is running at:
xxxxxx:10086/?token=xxxxxxxxxxxxxx
```

Now, enjoy it
