## SysGuard: Modular Linux System Health Checker

This is a customizable, modular Bash-based tool that performs detailed health checks on Linux systems. Designed for system administrators, DevOps engineers, and cloud professionals, it offers clean, readable output, optional reports, and baseline comparison features to identify issues before they become critical.

## Features

- Modular design – enable only the checks you need
- Monitors CPU, memory, disk, services, and network
- Color-coded terminal output for quick scanning
- Output options: terminal, log file, JSON, and HTML
- Optional email or webhook alerts on critical issues
- Container-friendly – runs in Docker environments
- Cron-ready for scheduled system health audits
- Compare system health to a saved healthy baseline

## Usage

```bash
./healthcheck.sh --cpu --disk --memory --output json
```
You can also run it in cron mode:
```
./healthcheck.sh --cron >> /var/log/sysguard.log
```
## Modular Architecture
Each system check is handled by its own script in the /modules folder, making it easy to add or remove specific checks.

```
modules/
├── cpu.sh
├── disk.sh
├── memory.sh
├── services.sh
└── network.sh

```

