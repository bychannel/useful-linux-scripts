#!/bin/bash
#set -u
#set -e
if [ $# -lt 2 ] ;then
	echo "Usage: $0 opcode协议号 文件，[开始时间]，[结束时间]"
	exit -1
fi
if [[ $# -ne 4 ]]; then
all_time_opcode=$(cat $2)
else
all_time_opcode=$(sed -n "/$3/,/$4/p" $2)
fi
#抓取协议
all_opcode=$(echo "$all_time_opcode"|grep "(opcode="|cut -d' ' -f2,8,9)
all_opcode=$(echo "$all_opcode"|sed -e 's/ ms,exec=/|/g'  -e 's/,delay=/|/g' -e  's/^[ \t]*//g' -e 's/ /|/g'  -e 's/[a-z]*//g'  -e 's/(=*//g'  -e 's/)//g')
echo "$all_opcode"
opcode=$(echo "$all_time_opcode"|grep "(opcode=$1)"|cut -d' ' -f2,8,9)
opcode=$(echo "$opcode"|sed -e 's/ ms,exec=/|/g'  -e 's/,delay=/|/g' -e  's/^[ \t]*//g' -e 's/ /|/g'  -e 's/[a-z]*//g'  -e 's/(=*//g'  -e 's/)//g')
#消息总次数
opcode_count=$(echo "$opcode"|wc -l)
#所有消息总次数
all_opcode_count=$(echo "$all_opcode"|wc -l)
#总调用时间:
sumTime=$(echo "$all_opcode"|cut -d'.' -f1 |uniq -c|wc -l)
opcode_sumTime=$(echo "$opcode"|cut -d'.' -f1 |uniq -c|wc -l)
#总延迟时间
sumDelayTime=$(echo "$all_opcode"|awk  -F '|' '{sum += $3};END {print sum}')
opcode_sumDelayTime=$(echo "$opcode"|awk  -F '|' '{sum += $3};END {print sum}')
#总运行时间
sumRunTime=$(echo "$all_opcode"|awk  -F '|' '{sum += $4};END {print sum}')
opcode_sumRunTime=$(echo "$opcode"|awk  -F '|' '{sum += $4};END {print sum}')
avgDelayTime=$(awk -v m1=$sumDelayTime  -v m2=$all_opcode_count 'BEGIN{printf "%.2f",m1/m2}')
opcode_avgDelayTime=$(awk -v m1=$opcode_sumDelayTime  -v m2=$opcode_count 'BEGIN{printf "%.2f",m1/m2}')
avgRunTime=$(awk -v m1=$sumRunTime  -v m2=$all_opcode_count 'BEGIN{printf "%.2f",m1/m2}')
opcode_avgRunTime=$(awk -v m1=$opcode_sumRunTime  -v m2=$opcode_count 'BEGIN{printf "%.2f",m1/m2}')
let qps=$all_opcode_count/$opcode_sumTime
let opcode_qps=$opcode_count/$sumTime
echo 消息号:$1
echo 消息总次数:$opcode_count
echo 总调用时间:$sumTime
echo 总延迟时间:${opcode_sumDelayTime}ms
echo 总运行时间:${opcode_sumRunTime}ms
echo 平均延迟时间:${opcode_avgDelayTime}ms
echo 平均运行时间:${opcode_avgRunTime}ms
echo 单消息qps:${opcode_qps}
echo "------------------时间短内所有消息统计---------------"
echo 消息总次数:$all_opcode_count
echo 总调用时间:$sumTime
echo 总延迟时间:${sumDelayTime}ms
echo 总运行时间:${sumRunTime}ms
echo 平均延迟时间:${avgDelayTime}ms
echo 平均运行时间:${avgRunTime}ms
echo qps:${qps}
