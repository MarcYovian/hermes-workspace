---
name: vps-sinyora-backup
description: Automated MySQL database backup for VPS Sinyora Laravel app
compatibility:
  - hermes
metadata:
  hermes:
    tags: [backup, mysql, laravel, vps]
    category: backup
    requires_toolsets: [terminal]
---

# VPS Sinyora Backup

Backup MySQL database dan Laravel storage dari VPS Sinyora.

## When to Use
- Daily automated backup (cron)
- Pre-deployment backup
- Manual backup request

## Backup Procedure

SSH ke VPS: `ssh sinyora-vps`

1. **MySQL dump:**
```bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/sinyora/backups"
DB_NAME=$(grep ^DB_DATABASE= /var/www/html/sinyora/.env | cut -d= -f2)
DB_USER=$(grep ^DB_USERNAME= /var/www/html/sinyora/.env | cut -d= -f2)
DB_PASS=$(grep ^DB_PASSWORD= /var/www/html/sinyora/.env | cut -d= -f2)

mysqldump -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/db_${TIMESTAMP}.sql.gz

echo "Backup created: $BACKUP_DIR/db_${TIMESTAMP}.sql.gz"
ls -lh $BACKUP_DIR/db_${TIMESTAMP}.sql.gz
```

2. **Cleanup old backups (keep 7 days):**
```bash
find /home/sinyora/backups -name 'db_*.sql.gz' -mtime +7 -delete
echo "Old backups cleaned (>7 days)"
```

3. **Verify backup:**
```bash
ls -lht /home/sinyora/backups | head -5
```

## Output Format

```
✅ **BACKUP VPS SINYORA**

📦 Database: [filename] ([size])
📅 Timestamp: [YYYY-MM-DD HH:MM:SS]
🗑️ Old backups cleaned: [count] files

Status: [SUCCESS/FAILED]
```