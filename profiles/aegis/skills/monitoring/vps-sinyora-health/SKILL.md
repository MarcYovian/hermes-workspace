---
name: vps-sinyora-health
description: Generate VPS Sinyora health report — system, Laravel, database, queue, SSL
compatibility:
  - hermes
metadata:
  hermes:
    tags: [monitoring, vps, laravel, health]
    category: monitoring
    requires_toolsets: [terminal]
---

# VPS Sinyora Health Report

Generate daily health report untuk VPS Sinyora (103.196.154.123) dengan Laravel application.

## When to Use
- Daily scheduled health monitoring (cron)
- On-demand status check
- Post-deployment verification

## Report Structure

**Format output:**
```
═══════════════════════════════════════════════════════════
📊 LAPORAN KESEHATAN VPS SINYORA
📅 [Tanggal & Waktu WIB]
═══════════════════════════════════════════════════════════

🖥️  SISTEM
   Uptime: [X hari Y jam]
   Load Average: [1m] [5m] [15m]
   Memory: [used] / [total]
   Disk: [used] / [total] ([percent])

🚀 LARAVEL APPLICATION
   Queue Worker: [🟢 Running / 🔴 Stopped]
   Redis: [🟢 Active / 🔴 Down]
   MySQL: [🟢 Active / 🔴 Down]

🔒 SSL CERTIFICATES
   [domain]: [X hari lagi]

═══════════════════════════════════════════════════════════
STATUS KESELURUHAN: [🟢 BAIK / 🟡 PERHATIAN / 🔴 KRITIS]
═══════════════════════════════════════════════════════════
```

## Data Collection

SSH ke VPS: `ssh sinyora-vps`

1. **System metrics:**
```bash
uptime -p
cat /proc/loadavg | awk '{print $1, $2, $3}'
free -h | grep Mem | awk '{print $3 " / " $2}'
df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}'
```

2. **Laravel queue worker:**
```bash
ps aux | grep 'artisan.*queue:work' | grep -v grep
```

3. **Redis:**
```bash
redis-cli ping
```

4. **MySQL:**
```bash
systemctl is-active mysql
```

5. **SSL expiry:**
```bash
sudo certbot certificates 2>/dev/null | grep -E 'Certificate Name|Expiry Date'
```

## Kondisi Assessment

- **🟢 KONDISI BAIK**: All services running, disk < 80%, memory < 85%, SSL > 14 days
- **🟡 PERHATIAN**: Queue worker down, disk 80-90%, SSL < 14 days
- **🔴 KRITIS**: MySQL down, disk > 90%, SSL expired

## Output

Print report in Indonesian directly (no agent commentary).