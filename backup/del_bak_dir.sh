#!/bin/bash
set -u 
set -e

# 备份路径
BAK_PATH="/data/ewan/backups"
# 保留天数
TAG=`date -d '3 days ago' +%Y%m%d`

for dir in $(ls $BAK_PATH)
do
    echo "开始处理:$dir"
    # 判断目录
    if [ ! -d $BAK_PATH/$dir ];then
      echo "不是目录. 跳过"      
      continue;
    fi

    # 是否过旧
    for son_dir in $(ls $BAK_PATH/$dir)
    do
      if [ $son_dir -le $TAG ];then
        rm -rf $BAK_PATH/$dir/$son_dir
      fi
    done
done

echo "success!"
