#!/bin/bash

used_space=$(df / | grep -v "Filesystem" | awk '{print $5}' | tr -d "%")
#availible_space=$((100-"$used_space"))
if [ $used_space -gt 80 ]; then
	echo "WARNING: disk is running out"
else
	echo "Availible space: $((100-$used_space))"
fi
