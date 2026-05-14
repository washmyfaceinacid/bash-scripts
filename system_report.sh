#!/usr/bin/env bash
set -euo pipefail

output_file=${1:-system_report.txt}

get_external_ip() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsS https://api.ipify.org 2>/dev/null || printf 'unknown'
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- https://api.ipify.org 2>/dev/null || printf 'unknown'
    else
        printf 'unknown'
    fi
}

get_internal_ip() {
    if command -v hostname >/dev/null 2>&1; then
        hostname -I 2>/dev/null | awk '{print $1}'
    elif command -v ip >/dev/null 2>&1; then
        ip route get 1 2>/dev/null | awk '{print $7; exit}'
    else
        printf 'unknown'
    fi
}

get_distribution() {
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        printf '%s %s' "${NAME:-unknown}" "${VERSION:-}"
    elif command -v lsb_release >/dev/null 2>&1; then
        printf '%s %s' "$(lsb_release -si 2>/dev/null || printf 'unknown')" "$(lsb_release -sr 2>/dev/null || printf '')"
    else
        printf 'unknown'
    fi
}

get_ram_info() {
    if command -v free >/dev/null 2>&1; then
        free -g | awk '/^Mem:/ {printf "Total: %s GB, Free: %s GB", $2, $7}'
    else
        printf 'unknown'
    fi
}

get_cpu_info() {
    if command -v lscpu >/dev/null 2>&1; then
        local cores frequency
        cores=$(lscpu 2>/dev/null | awk -F: '/^CPU\(s\)/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
        frequency=$(lscpu 2>/dev/null | awk -F: '/CPU max MHz|CPU MHz/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
        printf 'Cores: %s, Frequency: %s MHz' "${cores:-unknown}" "${frequency:-unknown}"
    else
        printf 'unknown'
    fi
}

used_space=$(df -BG / | awk 'NR==2 {print $3}')
free_space=$(df -BG / | awk 'NR==2 {print $4}')
hostname_value=$(hostname 2>/dev/null || printf 'unknown')
current_user=$(whoami 2>/dev/null || printf 'unknown')

cat > "$output_file" <<EOF
Current date and time: $(date '+%Y-%m-%d %H:%M:%S')
Current user: $current_user
Internal IP address and hostname: $(get_internal_ip), $hostname_value
External IP address: $(get_external_ip)
Linux distribution: $(get_distribution)
System uptime: $(uptime -p 2>/dev/null || uptime 2>/dev/null || printf 'unknown')
Disk space in /: Used ${used_space:-unknown}, Free ${free_space:-unknown}
RAM: $(get_ram_info)
CPU: $(get_cpu_info)
EOF

printf 'Report written to %s\n' "$output_file"
