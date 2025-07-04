## SysGuard: Modular Linux System Health Checker

This is a customizable, modular Bash-based tool that performs detailed health checks on Linux systems. Designed for system administrators, DevOps engineers, and cloud professionals, it offers clean, readable output, optional reports, and baseline comparison features to identify issues before they become critical.

## Features

- Modular design – enable only the checks you need
- Monitors CPU, memory, disk, services, and network
- Color-coded terminal output for quick scanning
- Output options: terminal, log file, JSON
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
## Screenshots of Sysguard's check on a Google Cloud VM Instance
Check Services Before

![shot nginx before](https://github.com/user-attachments/assets/652c04bf-5f7d-4c2d-870d-e822d85df96f)


Check Services After Ngninx Installation

![shot nginx after](https://github.com/user-attachments/assets/096f837d-2460-4cb4-8e81-eb34ae4e6855)

Cpu and disck check

![shot 3](https://github.com/user-attachments/assets/b69e57ad-28bc-4ad0-abb1-063a06f1c230)

Memory Usage

![shot 4](https://github.com/user-attachments/assets/200309bb-369d-4878-a215-ca42385f5f34)

## Exporting Results of Health Check
###  Run and save results to log file

```
./healthcheck.sh --cpu --memory --output log
```
This creates or appends to sysguard.log with a formatted output like the below.  This is quite useful for historical audits

```
==============================
SysGuard Report - 2025-07-05 10:20:15
==============================
CPU Load: 12%
Memory Usage: 61%
Top Process: firefox (8.3%)

```
###  Run and save results to JSON

```
./healthcheck.sh --cpu --memory --output json
```
Sample JSON Output CPU and Memory
```
{"timestamp":"2025-07-05T10:25:31+01:00",
"results":[
{"module":"cpu","status":"ok","load_avg":0.01,"cpu_percent":1},
{"module":"memory","status":"ok","used_percent":11,"top_process":"unattended-upgr","top_process_mem":0.5}]}
```
