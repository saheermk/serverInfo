#!/bin/bash

echo "==============================="
echo "        SERVER INFO"
echo "==============================="
echo "Time: $(date)"
echo

###############################################
# SYSTEM
###############################################
echo "--- SYSTEM ---"

if command -v getprop >/dev/null 2>&1; then
    OS="Android $(getprop ro.build.version.release)"
    DEVICE="$(getprop ro.product.manufacturer) $(getprop ro.product.model)"
else
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS="$NAME $VERSION"
    else
        OS="$(uname -o)"
    fi
    DEVICE="$(hostname)"
fi

echo "OS: $OS"
echo "Device: $DEVICE"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo

###############################################
# CPU
###############################################
echo "--- CPU ---"
CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
[ -z "$CPU_MODEL" ] && CPU_MODEL=$(grep -m1 "Hardware" /proc/cpuinfo | cut -d: -f2 | xargs)

echo "Cores : $(nproc)"
echo "Model : ${CPU_MODEL:-Unknown}"
echo

###############################################
# MEMORY
###############################################
echo "--- RAM ---"
free -h
echo

###############################################
# STORAGE
###############################################
echo "--- STORAGE ---"
df -h / | sed '1d'
echo

###############################################
# NETWORK
###############################################
echo "--- NETWORK ---"

# Local IPs
echo "Local IPs:"
ip -4 addr | grep inet | awk '{print " - "$2" on "$7}' | sed 's/\/.*//'
echo

# Public IP
# Public IPs (force IPv4 + IPv6)
echo "--- PUBLIC IP ---"

# IPv4
if command -v curl >/dev/null 2>&1; then
    PUBLIC_IP4=$(curl -4 -s https://ipv4.icanhazip.com || echo "Unavailable")
    PUBLIC_IP6=$(curl -6 -s https://ipv6.icanhazip.com || echo "Unavailable")
elif command -v wget >/dev/null 2>&1; then
    PUBLIC_IP4=$(wget -qO- --inet4-only https://ipv4.icanhazip.com || echo "Unavailable")
    PUBLIC_IP6=$(wget -qO- --inet6-only https://ipv6.icanhazip.com || echo "Unavailable")
else
    PUBLIC_IP4="curl/wget missing"
    PUBLIC_IP6="curl/wget missing"
fi

echo "Public IPv4: $PUBLIC_IP4"
echo "Public IPv6: $PUBLIC_IP6"
echo


###############################################
# HELPERS
###############################################
service_exists() {
    command -v $1 >/dev/null 2>&1
}

proc_running() {
    pgrep -x "$1" >/dev/null 2>&1
}

get_ports() {
    ss -tulnp 2>/dev/null | grep "$1" | awk '{print $5}' | sed 's/.*://'
}

###############################################
# SERVICES
###############################################
echo "--- SERVICES ---"

############ SSH ############
if service_exists sshd; then
    echo "- SSH: Installed"
    if proc_running sshd; then
        echo "  Status: Running"
        echo "  Ports : $(get_ports sshd)"
    else
        echo "  Status: Not running"
    fi
else
    echo "- SSH: Not installed"
fi
echo

############ FTP ############
echo "- FTP servers:"
FTP_SERVERS=("vsftpd" "proftpd" "pure-ftpd" "pyftpdlib" "tcpsvd")
FOUND_FTP=0

for srv in "${FTP_SERVERS[@]}"; do
    if service_exists "$srv"; then
        FOUND_FTP=1
        if proc_running "$srv"; then
            echo "  $srv: Running (port $(get_ports "$srv"))"
        else
            echo "  $srv: Installed but not running"
        fi
    fi
done

[ $FOUND_FTP -eq 0 ] && echo "  None installed"
echo

############ WEB SERVERS ############
echo "- Web servers:"

# Apache
if service_exists apache2 || service_exists httpd; then
    if proc_running apache2 || proc_running httpd; then
        echo "  Apache: Running (ports $(get_ports apache2) $(get_ports httpd))"
    else
        echo "  Apache: Installed but not running"
    fi
fi

# Nginx
if service_exists nginx; then
    if proc_running nginx; then
        echo "  Nginx: Running (ports $(get_ports nginx))"
    else
        echo "  Nginx: Installed but not running"
    fi
fi

# Lighttpd
if service_exists lighttpd; then
    if proc_running lighttpd; then
        echo "  Lighttpd: Running (ports $(get_ports lighttpd))"
    else
        echo "  Lighttpd: Installed but not running"
    fi
fi

# BusyBox httpd
if command -v busybox >/dev/null && busybox httpd -h >/dev/null 2>&1; then
    if pgrep -f "busybox httpd" >/dev/null; then
        PORTS=$(ss -tulnp | grep httpd | awk '{print $5}' | sed 's/.*://')
        echo "  BusyBox httpd: Running (ports $PORTS)"
    else
        echo "  BusyBox httpd: Installed but not running"
    fi
fi

# PHP built-in server
if pgrep -f "php -S" >/dev/null; then
    PORTS=$(ss -tulnp | grep php | awk '{print $5}' | sed 's/.*://')
    echo "  PHP server: Running (ports $PORTS)"
fi

# If none installed
if ! service_exists apache2 &&
   ! service_exists httpd &&
   ! service_exists nginx &&
   ! service_exists lighttpd &&
   ! busybox httpd -h >/dev/null 2>&1; then
    echo "  None installed"
fi

echo



###############################################
# UPTIME
###############################################
echo "--- UPTIME ---"
uptime -p
echo

###############################################
# TOP PROCESSES
###############################################
echo "--- TOP PROCESSES (CPU) ---"
ps -eo pid,cmd,%cpu,%mem --sort=-%cpu | head -n 10
echo

echo "==============================="
echo "        END OF REPORT"
echo "==============================="
