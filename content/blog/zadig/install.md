# Zadig Install 


## Prerequision

- 需要以 Root 用户安装，不能用 sudo
- 可以使用 curl/sudo 命令
- 关闭 Swap 交换
- 关闭 SELinux
- 该服务器防火墙配置开放 30000 - 32767 的端口段，用于外部访问
- 如果是以 SSH 方式登入机器，为防止脚本等待安装时间过长导致 SSH 连接断开，建议在客户端本地~/.ssh/config中添加一行 ServerAliveInterval 60

## Install Scripts

- For existing k8s cluster 
```sh
curl -LO https://github.com/koderover/zadig/releases/latest/download/install.sh 
chmod +x ./install.sh
```

- all in one k8s cluster installation

```sh
curl -LO https://github.com/koderover/zadig/releases/latest/download/install_with_k8s.sh
chmod +x ./install_with_k8s.sh
```

