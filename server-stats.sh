#!/usr/bin/env bash

# Define Colors
R="\e[0m"
U="\e[4m"
Y="\e[33m"
RED="\e[1;31m"
W="\033[97m"

# User
USER=$(whoami)

banner() {
    local DAY DATE TIME
    DATE=$(date +%m/%d/%Y)
    TIME=$(date +%k:%M:%S)
    DAY=$(date +%A)
    echo ----------------------------------------------------------------------
    echo -e "$RED" DAY: "$R"$DAY "$RED"'\t'DATE: "$R"$DATE "$RED"'\t'TIME: "$R"$TIME"$R"
    echo ----------------------------------------------------------------------
}

gather_stats() {
    UPTIME_S=$(uptime -s)
    UPTIME_P=$(uptime -p)
    UPTIME="$UPTIME_S $UPTIME_P"
    MEMORY_USAGE=$(free -m | awk '/Mem:/ {print $3}')
    MEMORY_FREE=$(free -m | head -n 2 | tail -n 1 | awk '{print $4}')
    CPU_IDLE=$(vmstat 1 2 | sed -n '/[0-9]/p' | sed -n '2p' | awk '{print $15}')
    CPU_USAGE=$(top -bn2 | grep '%Cpu' | tail -1 | awk '{print 100-$8}')
    DISK_FREE=$(df -h / | awk '{b = $4} END {print b}')
    DISK_USED=$(df -h / | awk '{c = $3} END {print c}')
    TOP_5_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | column -t)
    TOP_5_MEMORY=$(ps -eo pid,user,comm,%mem --sort=-%mem | head -6 | column -t)
}

print_top_5_cpu_table() {
    local count
    mapfile -t CPU_LINES <<< "$TOP_5_CPU"
    echo -e "${R}TOP 5 CPU PROC.:${R}\t${W}|${R}"
    for ((count=0; count<${#CPU_LINES[@]}; count++)); do
        printf "\t\t\t%b|%b\t%b%s%b\n" \
            "$W" "$R" "$Y" "${CPU_LINES[count]}" "$R"
    done
}

print_top_5_mem_table() {
    local count
    mapfile -t MEMORY_LINES <<< "$TOP_5_MEMORY"
    echo -e "${R}TOP 5 MEM. PROC.:${R}\t${W}|${R}"
    for ((count=0; count<${#MEMORY_LINES[@]}; count++)); do
        printf "\t\t\t%b|%b\t%b%s%b\n" \
            "$W" "$R" "$Y" "${MEMORY_LINES[count]}" "$R"
    done
}

print_stats() {
    echo -e "$R"WELCOME:"$R"'\t\t|\t'"$Y"$USER
    echo -e "$R"UPTIME: "$R"'\t\t|\t'"$Y"$UPTIME
    echo -e "$R"CPU USAGE:"$R"'\t\t|\t'"$Y"$CPU_USAGE "%"
    echo -e "$R"CPU IDLE:"$R"'\t\t|\t'"$Y"$CPU_IDLE "%"
    echo -e "$R"MEMORY USAGE:"$R"'\t\t|\t'"$Y"$MEMORY_USAGE "MB"
    echo -e "$R"MEMORY FREE:"$R"'\t\t|\t'"$Y"$MEMORY_FREE "MB"
    echo -e "$R"USED DISK SPACE:"$R"'\t|\t'"$Y"$DISK_USED
    echo -e "$R"FREE DISK SPACE:"$R"'\t|\t'"$Y"$DISK_FREE
    print_top_5_cpu_table
    print_top_5_mem_table
}

while true; do
    gather_stats
    clear && banner
    print_stats
    echo "Press 'q' to quit: "
    sleep 1
done   