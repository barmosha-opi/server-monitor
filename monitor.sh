#!/bin/bash

cd "$(dirname "$0")"

if [ -f .env ]; then
	export $(grep -v '^#' .env | xargs)
else
	echo "Error. File .env doesn't exists"
	exit 1
fi

main_mail="$EMAIL_USER"

if [ -z "$main_mail" ]; then
	echo "Error. EMAIL_USER variable is empty in .env"
	exit 1
fi

used_space=$(df / | grep -v "Filesystem" | awk '{print $5}' | tr -d "%")
free_mem=$(free -m | grep "Mem" | awk '{print $7}')
cpu_load=$(uptime | awk -F'[ ,]+' '{print $(NF-2)}' | tr -d ".")
cpu_load_threshold=$(($(nproc)*150))
has_problem=false

message="Sys Status Report\n"
message+="==========\n"

#availible_space=$((100-"$used_space"))
if [ "$used_space" -gt 80 ]; then
	#echo "WARNING - disk is running out"
	message+="WARNING - disk is at ${used_space}%\n"
	has_problem=true
else
	#echo "Available space - $((100-$used_space))"
	message+="Available space on disk -  $((100-$used_space))%\n"
fi

if [ "$free_mem" -lt 1000 ]; then
	#echo "WARNING - low RAM"
	message+="WARNING - RAM level is at ${free_mem}\n"
	has_problem=true
else
	#echo "Free RAM - ${free_mem}"
	message+="Free RAM - ${free_mem}\n"
fi

if [ "$cpu_load" -gt "$cpu_load_threshold" ]; then
	#echo "Warning - CPU load is too high"
	message+="Warning - CPU load is at $(echo ${cpu_load} | awk '{printf "%.2f", $1/100}')%\n"
	has_problem=true
else
	#echo "CPU load - $(echo $cpu_load | awk '{printf "%.2f", $1/100}')"
	message+="CPU load - $(echo ${cpu_load} | awk '{printf "%.2f", $1/100}')%\n"
fi

send_telegram() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d text="$(echo -e "$message")" > /dev/null
}

send_email() {
	echo -e "Subject: Server Status Alert\n\n$message" | msmtp "$main_mail"
}


if [ "$has_problem" = true ]; then
	case "$ALERT_CHANNEL" in
		telegram) send_telegram ;;
		email) send_email ;;
		both) send_telegram; send_email ;;
		*) echo "Unknown ALERT_CHANNELL: $ALERT_CHANNEL" ;;
	esac
fi
