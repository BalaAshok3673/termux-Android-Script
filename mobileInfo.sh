#!/data/data/com.termux/files/usr/bin/bash


if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root (su)." >&2
    exit 1
fi


print_section() {
    echo
    echo "=== $1 ==="
}


print_hr() {
    echo "====================================================================="
}


print_section "System Information"
echo "Kernel Version:"
uname -a
echo "Uptime:"
uptime
echo "CPU Info:"
cat /proc/cpuinfo | grep 'model name' | uniq
echo "Memory Info:"
cat /proc/meminfo | grep 'MemTotal'
echo "Disk Usage:"
df -h


print_section "Network Information"
echo "IP Addresses:"
ip addr show
echo "Routing Table:"
ip route


print_section "User Information"
echo "Logged in users:"
who


print_section "Process Information"
echo "Top CPU Consuming Processes:"
ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head -n 10


print_section "Disk Space Usage (Specific Directories)"
dirs="/data /system /storage /sdcard"
for dir in $dirs; do
    echo "Disk usage for $dir:"
    du -sh $dir 2>/dev/null
done

# Retrieve battery information (if available)
print_section "Battery Information"
if [ -f "/sys/class/power_supply/battery/capacity" ]; then
    cat /sys/class/power_supply/battery/{status,capacity}
else
    echo "Battery information not available."
fi


print_section "Installed Packages"
pm list packages -f


print_section "System Log (last 20 lines)"
tail -n 20 /var/log/syslog


print_hr
