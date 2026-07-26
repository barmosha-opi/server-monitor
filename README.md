# Server Monitor

Bash script for monitoring server health with Telegram and email alert notifications.

## Features: 
 - Disk usage monitoring
 - RAM availability monitoring
 - CPU load monitoring
 - Dual notification channel support (Telegram / Email / Both)
 - Environment-based configuration via .env

## Alerts when
 - Disk usage exceeds 80%
 - Free RAM drops below 100MB
 - CPU load average exceeds 1.5x CPU count

## Requirements
 - curl (for Telegram notifications)
 - msmtp (for email notifications)
 - Linux/Unix server

## Setup

1. Clone the repo:
```bash
git clone https://github.com/barmosha-opi/server-monitor.git
cd server-monitor
```

2. Copy and configure envitonment file:
```bash
cp .env.example .env
chmod 600 .env
nano .env
```

3. Make script executable:
```bash
chmod +x monitor.sh
```

4. Add to crontab (runs every hour):
```bash
crontab -e
0 * * * * /path/to/monitor.sh
```

## Configuration

ALERT_CHANNEL options:
 - 'telegram': Telegram only
 - 'email': email only via msmtp
 - 'both': Both channels

## Usage
```bash
./monitor.sh
```
