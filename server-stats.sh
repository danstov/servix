#!/usr/bin/env bash

#  Define Output Log-File (or not)

OUTPUT_LOG=~/sys-log.txt

#  Define Colors

  R="\e[0m" #reset
  U="\e[4m" #underline
  Y="\e[33m" #yellow
  RED="\e[1;31m" #light red

#  Format Date and Time

DATE=$(date +%m/%d/%Y)
TIME=$(date +%k:%M:%S)
DAY=$(date +%A)

#  User Logged In

USER=$(whoami)

#  System Uptime

UPTIME_S=$(uptime -s)
UPTIME_P=$(uptime -p)
UPTIME=$(uptime -s && uptime -p)

# Memory Usage

MEMORY_USAGE=$(free -m | awk '/Mem:/ {print $3}')

#  Free Memory

MEMORY_FREE=$(free -m | head -n 2 | tail -n 1 | awk {'print $4'})

#  CPU Idle

CPU_IDLE=$(vmstat 1 2 | sed -n '/[0-9]/p' | sed -n '2p' | awk '{print $15}')

# CPU Usage

CPU_USAGE=$(top -bn2 | grep '%Cpu' | tail -1 | awk '{print 100-$8}')

#  Free Disk Space

DISK_FREE=$(df -h / | awk '{b = $4} END {print b}')

# Used Disk Space

DISK_USED=$(df -h / | awk '{c = $3} END {print c}')

# Top 5 processes by CPU usage

TOP_5_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | column -t)

function print_top_5_cpu_table() {
    local count=0
    mapfile -t CPU_LINES <<< "$TOP_5_CPU"
    echo -e "$R"TOP 5 CPU PROC.:"$R"'\t|\t'"$Y"
    for ((count=0; count<${#CPU_LINES[@]}; count++)); do
        printf "\t\t\t|\t%s\n" "${CPU_LINES[count]}"
    done
}

# Top 5 processes by memory usage

TOP_5_MEMORY=$(ps -eo pid,user,comm,%mem --sort=-%mem | head -6 | column -t)

function print_top_5_mem_table() {
    local count=0
    mapfile -t MEMORY_LINES <<< "$TOP_5_MEMORY"
    echo -e "${R}TOP 5 MEM. PROC.:${R}\t|\t""$Y"
    for ((count=0; count<${#MEMORY_LINES[@]}; count++)); do
        printf "\t\t\t|\t%s\n" "${MEMORY_LINES[count]}"
    done
}

#  Define banner to print

  banner() {

    echo ----------------------------------------------------------------------
    echo -e "$RED" DAY: "$R"$DAY "$RED"'\t'DATE: "$R"$DATE "$RED"'\t'TIME: "$R"$TIME"$R"
    echo ----------------------------------------------------------------------
}

#  Define nice-print stats

  print_stats() {

    echo -e "$R"WELCOME:"$R"'\t\t|\t'"$Y"$USER

    echo -e "$R"UPTIME: "$R"'\t\t|\t'"$Y"$UPTIME

    echo -e "$R"CPU USAGE:"$R"'\t\t|\t'"$Y"$CPU_USAGE %

    echo -e "$R"CPU IDLE:"$R"'\t\t|\t'"$Y"$CPU_IDLE %

    echo -e "$R"MEMORY USAGE:"$R"'\t\t|\t'"$Y"$MEMORY_USAGE MB

    echo -e "$R"MEMORY FREE:"$R"'\t\t|\t'"$Y"$MEMORY_FREE MB

    echo -e "$R"USED DISK SPACE:"$R"'\t|\t'"$Y"$DISK_USED

    echo -e "$R"FREE DISK SPACE:"$R"'\t|\t'"$Y"$DISK_FREE

    print_top_5_cpu_table

    print_top_5_mem_table
}

#  Define One-Line output log

  output() {

    echo "$DATE | $TIME | $USER | $UPTIME_S | $UPTIME_P | $FREE MB | $SWAP MB | $CPU % | $SPACE"
}

### ### ###

#  Execute Defined Functions

  clear && banner           # Print Banner

  print_stats               # Print Stats

#  output >> $OUTPUT_LOG     # Save Output (or not)