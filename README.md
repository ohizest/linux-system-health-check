## SysGuard: Modular Linux System Health Checker

This is a customizable, modular Bash-based tool that performs detailed health checks on Linux systems. Designed for system administrators, DevOps engineers, and cloud professionals, it offers clean, readable output, optional reports, and baseline comparison features to identify issues before they become critical.

## Features

- Modular design – enable only the checks you need
- Monitors CPU, memory, disk, services, and network
- Color-coded terminal output for quick scanning
- Output options: terminal, log file, JSON, and HTML (in progress)
- Optional email or webhook alerts on critical issues (in progress)
- Cron-ready for scheduled system health audits (in progress)
- Compare system health to a saved healthy baseline (in progress)

## Modular Architecture
Each system check is handled by its own script in the /modules folder, making it easy to add or remove specific checks.

```
├── healthcheck.sh
├── modules/
│ ├── cpu.sh
│ ├── memory.sh
│ ├── disk.sh
│ ├── network.sh
│ └── services.sh
├── config/
│ └── services.conf
└── README.md

```
## Run Health Checks

```bash
./healthcheck.sh --cpu --memory --disk --network --services

```
Check specific modules:
```
./healthcheck.sh --disk --services

```
## Configure Services to Monitor
```
# One service name per line
nginx
docker
mysql
ssh
```

## Installation 
```
git clone https://github.com/ohizest/linux-system-health-check.git sysguard
cd sysguard
chmod +x healthcheck.sh modules/*.sh
```
Add alias to ```.bashrc:```
```
alias sysguard="$PWD/healthcheck.sh"
```
Then use it anywhere:

```
sysguard --cpu --disk
```
