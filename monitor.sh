#!/bin/bash

used_space=$(df / | grep -v "Filesystem" | awk '{print $5}' | tr -d "%")
free_mem=$(free -m | grep "Mem" | awk '{print $7}')
cpu_load=$(uptime | awk -F'[ ,]+' '{print $(NF-2)}' | tr -d ".")
cpu_load_threshold=$(($(nproc)*150))
main_mail=vladimir.korotaev10@gmail.com
has_problem=false

message="Sys Status Report\n"
message+="==========\n"

#availible_space=$((100-"$used_space"))
if [ $used_space -gt 80 ]; then
	#echo "WARNING - disk is running out"
	message+="WARNING - disk is at ${used_space}%\n"
	has_problem=true
else
	#echo "Available space - $((100-$used_space))"
	message+="Available space on disk -  $((100-$used_space))%\n"
fi

if [ $free_mem -lt 100 ]; then
	#echo "WARNING - low RAM"
	message+="WARNING - RAM level is at ${free_mem}\n"
	has_problem=true
else
	#echo "Free RAM - ${free_mem}"
	message+="Free RAM - ${free_mem}\n"
fi

if [ $cpu_load -gt $cpu_load_threshold ]; then
	#echo "Warning - CPU load is too high"
	message+="Warning - CPU load is at $(echo ${cpu_load} | awk '{printf "%.2f", $1/100}')%\n"
	has_problem=true
else
	#echo "CPU load - $(echo $cpu_load | awk '{printf "%.2f", $1/100}')"
	message+="CPU load - $(echo ${cpu_load} | awk '{printf "%.2f", $1/100}')%\n"
fi

if [ $has_problem = "true" ]; then
	echo -e "$message" | msmtp $main_mail
fi
