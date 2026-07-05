#!/bin/bash

used_space=$(df / | grep -v "Filesystem" | awk '{print $5}' | tr -d "%")
free_mem=$(free -m | grep "Mem" | awk '{print $7}')
cpu_load=$(uptime | awk '{print $10}' | tr -d "," |tr -d ".")
cpu_load_threshold=$(($(nproc)*150))
#availible_space=$((100-"$used_space"))
if [ $used_space -gt 80 ]; then
	echo "WARNING: disk is running out"
else
	echo "Availible space: $((100-$used_space))"
fi

if [ $free_mem -lt 100 ]; then
	echo "WARNING: low RAM"
else
	echo "Free RAM: "$free_mem""
fi

if [ $cpu_load -gt $cpu_load_threshold ]; then
	echo "Warning: CPU load is too high"
else
	echo "CPU load: $(echo $cpu_load | awk '{printf "%.2f", $1/100}')"
fi
