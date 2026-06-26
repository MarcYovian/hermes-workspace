# VPS Monitoring Setup Workflow

Complete workflow untuk setup monitoring VPS baru dari discovery hingga automated reporting.

## Pattern: Discovery → Skills → Cron → Verification

### Phase 1: Discovery

SSH ke VPS dan kumpulkan:

**System Info:**
```bash
uname -a
uptime -p
free -h
df -h /
```

**Application Stack:**
```bash
# Laravel/PHP
find /var/www /home -name "artisan" -type f 2>/dev/null
php -v
cat .env | grep -E "^(APP_|DB_|QUEUE_|CACHE_)"

# Web server
systemctl is-active nginx apache2

# Database
systemctl is-active mysql mariadb postgresql
mysql --version

# Queue/Workers
ps aux | grep "artisan.*queue:work"
supervisorctl status
redis-cli ping

# SSL
sudo certbot certificates
```

**Backup & Cron:**
```bash
crontab -l
ls -lht /home/*/backups /var/backups
```

### Phase 2: Skill Creation

Buat 3 skills monitoring standar:

1. **{vps-name}-health** — Daily health report
   - System metrics (uptime, CPU, RAM, disk)
   - Application status (web server, queue, Redis, DB)
   - SSL expiry check
   - Format: emoji sections, Bahasa Indonesia

2. **{vps-name}-backup** — Database backup
   - MySQL dump + gzip
   - Cleanup retention (default 7 days)
   - Verify backup created

3. **{vps-name}-ssl-monitor** — SSL certificate check
   - Parse certbot output
   - Days until expiry
   - Alert thresholds: 🟢 >30d, 🟡 14-30d, 🔴 <14d

### Phase 3: Cron Jobs

Setup 3 cron jobs (convert local time to UTC):

| Job | Local Time | UTC Schedule | Frequency |
|-----|------------|--------------|-----------|
| Health Report | 07:30 local | `30 0 * * *` (WIB) | Daily |
| Database Backup | 02:00 local | `0 19 * * *` (prev day UTC for WIB) | Daily |
| SSL Check | 08:00 Sunday | `0 1 * * 0` (WIB) | Weekly |

**Critical:** All cron jobs from specialist profiles must set `deliver: local` so GM can forward results.

### Phase 4: Verification

1. **Test SSH access** dari specialist profile:
   ```bash
   ssh {vps-alias} 'echo OK'
   ```

2. **Manual trigger** health check:
   ```bash
   hermes -p {specialist-profile} cron run {job-id}
   ```

3. **Verify output** saved to local:
   ```bash
   ls -lht ~/.hermes/profiles/{profile}/cron/output/{job-id}/
   cat {latest-output-file}
   ```

4. **Test forwarding** dari GM ke user

## Pitfalls

- **SSH key permission**: File .pem harus owned by user yang run hermes process (bukan root/UID mismatch)
- **SSH config location**: Specialist profile perlu SSH config di `~/.ssh/config` dari perspective hermes user, bukan root
- **Timezone confusion**: User request "jam 7 pagi" → must convert to UTC for cron schedule
- **Gateway conflict**: Specialist cron dengan `deliver: telegram:ID` akan fail jika gateway specialist tidak running — use `deliver: local` + GM forwarding
- **First cron run delay**: Manual trigger (`cron run`) hanya reschedule, tidak instant execute — tunggu scheduler tick berikutnya

## SSH Setup untuk Specialist Profile

1. **Key file location**: `/opt/data/profiles/{profile}/ssh/{vps-name}.pem`
2. **Permission**: `chmod 600 {key-file}` owned by hermes user
3. **SSH config** di `~/.ssh/config` (dari perspective hermes process user):
   ```
   Host {vps-alias}
       HostName {IP}
       User {username}
       Port 22
       IdentityFile /opt/data/profiles/{profile}/ssh/{vps-name}.pem
       StrictHostKeyChecking accept-new
   ```
4. **Test**: `ssh {vps-alias} 'echo OK'` dari specialist profile

## Real Example: VPS Sinyora

- **Discovery**: Laravel 8.3.31 + MySQL 8.0.45 + Redis + Supervisor
- **Skills created**: vps-sinyora-health, vps-sinyora-backup, vps-sinyora-ssl-monitor
- **Cron schedules (WIB → UTC)**:
  - Health: 07:30 WIB = `30 0 * * *`
  - Backup: 02:00 WIB = `0 19 * * *` (prev day)
  - SSL: Sun 08:00 WIB = `0 1 * * 0`
- **SSH blocker resolved**: Key file owned by UID 1000, hermes runs as UID 10000 → chown to hermes user
- **Test verification**: Manual health check successful, output saved to local
