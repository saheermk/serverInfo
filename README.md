
# 🖥️ Universal Server Info Script

A clean, cross-platform Bash script that works on **Android (Termux)**, **Linux desktops**, **servers**, **VPS**, and **embedded systems**.
It automatically detects the environment and prints easy-to-understand system information including:

* System & OS
* CPU, RAM, Storage
* Local & Public IP (IPv4 + IPv6)
* Web server status (Apache, Nginx, Lighttpd, BusyBox httpd, PHP built-in)
* SSH & FTP service status
* Open ports
* Top resource-consuming processes
* Uptime

The goal:
**Clean output. Understandable. Useful. No noise.**

---

## 🚀 Features

### ✔ Works Everywhere

* Android / Termux
* Debian / Ubuntu / Kali
* Arch / Manjaro
* Fedora / RHEL
* ARM devices (Raspberry Pi, etc.)
* Laptops, desktops, VPS

### ✔ Detects Services Automatically

* SSH (sshd)
* FTP servers (vsftpd, proftpd, pure-ftpd, pyftpdlib, etc.)
* Apache / httpd
* Nginx
* Lighttpd
* BusyBox httpd
* PHP built-in server

### ✔ Network Smart Detection

* All local IPv4 addresses
* Public IPv4
* Public IPv6
* All open ports (TCP + UDP)

### ✔ Clean Summary Output

Readable by *humans*, not just sysadmins.

---

## 📦 Installation

Clone or copy the script into any directory:

```bash
git clone https://github.com/yourusername/universal-server-info
cd universal-server-info
```

Make it executable:

```bash
chmod +x server-info.sh
```

Run it:

```bash
./server-info.sh
```

Works with:

* Bash
* Zsh
* Termux shell

---

## 📝 Example Output (Style B — Clean & Readable)

```
=====================================
      UNIVERSAL SERVER INFO
=====================================
Time: Mon Feb 17 18:22:03

--- SYSTEM ---
OS     : Android 12
Device : Xiaomi Redmi Note 8
Kernel : 4.14.190-perf+
Arch   : aarch64
Host   : localhost

--- CPU ---
Cores  : 8
Model  : Qualcomm Technologies, Inc SM6125

--- RAM ---
Total: 3613MiB | Used: 1820MiB

--- STORAGE ---
Filesystem      Size  Used Avail
/               56G    18G   38G

--- NETWORK ---
Local IPs:
  192.168.1.22 on wlan0
Public IPv4: 45.120.xxx.xxx
Public IPv6: 2409:xxxxx

=== SERVICES & PORTS ===

--- SSH ---
Installed: YES
Running  : YES
Port(s)  : 8022

--- FTP ---
FTP Server: pyftpdlib
Status: Running
Port(s): 2121

--- WEB SERVERS ---
Apache: Installed
Running: YES
Port(s): 8080

Nginx: Not installed

--- ALL OPEN PORTS ---
tcp 0.0.0.0:22
tcp 0.0.0.0:8080
tcp 0.0.0.0:2121

--- UPTIME ---
up 5 hours, 13 minutes

--- TOP PROCESSES ---
PID   CMD                CPU   MEM
1234  apache2            18%   4.2%
1222  php                12%   3.1%
...
```

---

## 🛠️ Script Contents

The script is fully self-contained with:

* Service detection tools
* Port analysis
* Cross-platform checks
* Fallback logic for missing commands
* IPv4/IPv6 explicit detection
* Clean formatted layout

---

## 🌐 Public IP Notes

Mobile networks often use:

* **IPv6-only**
* **NAT64 / DNS64**
* **CGNAT**

This means:

* Public IPv4 may be *unavailable*
* Only IPv6 is globally reachable

The script still shows:

* `Public IPv4` (forced)
* `Public IPv6` (forced)

---

## 📄 License

MIT License.
Free to use, modify, and distribute.

---

## 🤝 Contributing

Feel free to open PRs for:

* More service detection
* Docker / container info
* GPU info
* Temperature sensors
* Network speed test
* JSON output mode
