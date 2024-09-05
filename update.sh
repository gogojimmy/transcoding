#!/bin/bash

# 默認不在背景執行
DETACH_MODE=""

# 解析參數
while getopts "d" opt; do
  case $opt in
    d)
      DETACH_MODE="-d"
      ;;
    \?)
      echo "無效的參數: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# 拉取最新的版本
echo "拉取最新的版本..."
git pull origin main

# 重建並重啟 Docker 容器
echo "重建並重啟 Docker 容器..."
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up --build $DETACH_MODE

echo "操作完成。"