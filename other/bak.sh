#!/bin/bash
set -u
set -e

# 执行路径
EXEC_PATH="/data/ewan/uploads"
# 备份路径
BAK_PATH="/data/ewan/backups"
# 保留天数
TAG=`date -d '3 days ago' +%Y%m%d`

for dir in $(ls $EXEC_PATH)
do
    echo "开始处理:$dir"
    # 判断目录
    if [ ! -d $EXEC_PATH/$dir ];then
      echo "不是目录. 跳过"      
      continue;
    fi

    # 检查备份目录
    if [ ! -d $BAK_PATH/$dir ];then
      echo "备份目录不存在，开始创建:$dir"
      mkdir -p $BAK_PATH/$dir
    fi

    # 开始备份
    for son_dir in $(ls $EXEC_PATH/$dir)
    do
      if [ $son_dir -le $TAG ];then
        mv $EXEC_PATH/$dir/$son_dir $BAK_PATH/$dir/
      fi
    done
done

echo "success!"
