#Server Monitor

Bash script for monitoring server health with email alert notifications.

## Alerts when: 
 - free disk space less than 20% 
 - free RAM less than 100MB
 - CPU load average more than 1.5

##Requirements

 - msmtp (for email notifications)
 - Linux/Unix server

##Setup

1. Configure msmtp:
```bash
nano ~/.msmtprc
chmod 600 ~/.msmtprc
```

2. Make script executable:
```bash
chmod +x monitor.sh
```

3. Add to crontab (runs every hour):
```bash
crontab -e
0 * * * * /path/to/monitor.sh
```

## Usage
```bash
./monitor.sh
```
