#!/bin/bash
if [[ $# -ne 4 ]]; then
	echo "Usage: $0 opcode协议号 文件，开始时间，结束时间"
	exit -1
fi
#抓取协议
opcode=$(sed -n "/$3/,/$4/p" $2)
opcode=$(echo "$opcode"|grep "(opcode=$1)"|cut -d' ' -f2,8,9)
opcode=$(echo "$opcode"|sed -e 's/ ms,exec=/|/g'  -e 's/,delay=/|/g' -e  's/^[ \t]*//g' -e 's/ /|/g'  -e 's/[a-z]*//g'  -e 's/(=*//g'  -e 's/)//g')
#消息总次数
opcode_count=$(echo "$opcode"|wc -l)
#总调用时间
#sumTime=$(echo "$opcode"|cut -d'.' -f1 |uniq -c|wc -l)
#总延迟时间
sumDelayTime=$(echo "$opcode"|awk  -F '|' '{sum += $3};END {print sum}')
#总运行时间
sumRunTime=$(echo "$opcode"|awk  -F '|' '{sum += $4};END {print sum}')
avgDelayTime=$(awk -v m1=$sumDelayTime  -v m2=$opcode_count 'BEGIN{printf "%.2f",m1/m2}')
avgRunTime=$(awk -v m1=$sumRunTime  -v m2=$opcode_count 'BEGIN{printf "%.2f",m1/m2}')
echo 消息总次数:$opcode_count
#echo 总调用时间:$sumTime
echo 总延迟时间:${sumDelayTime}ms
echo 总运行时间:${sumRunTime}ms
echo 平均延迟时间:${avgDelayTime}ms
echo 平均运行时间:${avgRunTime}ms
