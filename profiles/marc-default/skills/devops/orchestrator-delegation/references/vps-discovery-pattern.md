# VPS Discovery & Monitoring Setup Pattern

**When to use:** Setting up monitoring for a new VPS/server with application stack.

## Phase 1: Discovery

Delegate to devops-admin (or appropriate specialist) to gather:

### System Info
- OS & kernel version
- Uptime, CPU, RAM, Disk usage
- Current user & sudo access

### Application Stack
- Find application directory (e.g., Laravel project via `find -name artisan`)
- Read `.env` (redact secrets!)
- Application version (composer.json, package.json, etc.)
- Runtime version (PHP, Node, Python, etc.)

### Services
- **Database**: Type, version, status (MySQL, PostgreSQL, etc.)
- **Queue**: Driver (Redis, database, sync), worker processes, Supervisor config
- **Cache**: Driver (Redis, Memcached), status
- **Web server**: Nginx, Apache status & config

### Security
- **SSL certificates**: `sudo certbot certificates` or `/etc/letsencrypt/live/`
  - Domain names
  - Expiry dates
  - Days until expiry

### Backup
- Cron jobs: `crontab -l`
- Backup scripts: `/etc/cron*`, custom scripts
- Backup locations: `/backup`, `/var/backups`, `~/backups`
- Last backup timestamp

### Project Structure
- Directory layout
- Disk usage: `du -sh`

## Phase 2: Setup Monitoring

Based on discovery findings, create:

### Skills (3 typical)
1. **`<project>-health`** — Daily health report
   - System metrics (CPU, RAM, Disk)
   - Application status
   - Database status
   - Queue worker status
   - SSL expiry check

2. **`<project>-backup`** — Database backup automation
   - Database dump
   - Compression (gzip)
   - Retention policy (e.g., 7 days)
   - Cleanup old backups

3. **`<project>-ssl-monitor`** — SSL certificate monitoring
   - Check expiry dates
   - Alert thresholds (30d OK, 14-30d WARNING, <14d CRITICAL)

### Cron Jobs (3 typical)
| Job | Schedule | Deliver | Purpose |
|-----|----------|---------|---------|
| Health Report | 0 0 * * * (07:00 local) | local | Daily system/app status |
| Database Backup | 0 19 * * * (02:00 local next day) | local | Nightly backup |
| SSL Check | 0 1 * * 0 (08:00 local Sunday) | local | Weekly certificate check |

**Delivery routing:** All jobs deliver to `local` (save to specialist's cron output), orchestrator reads and forwards to user.

**Timezone conversion:** Always convert user's local time to UTC for cron schedule. See `references/cron-timezone-wib.md`.

## Phase 3: Test & Verify

1. **Trigger test run:** `hermes -p <profile> cron run <job_id>`
2. **Check output:** `ls -lht /opt/data/profiles/<profile>/cron/output/<job_id>/`
3. **Read latest report:** Verify format, data accuracy
4. **Restart gateway if needed:** Load new cron schedules

## Common Pitfalls

### SSH Access Issues
- **Permission denied (publickey):** Check key file ownership and permissions
  - Key must be owned by the user running Hermes (e.g., `hermes:hermes`)
  - Permission: `chmod 600 <keyfile>`
  - If owned by different UID: `sudo chown hermes:hermes <keyfile>`
- **SSH config location:** Specialist profiles may need config at `~/.ssh/config` or `/opt/data/profiles/<profile>/.ssh/config`
- **Missing hostname:** Verify SSH config has correct `HostName`, `User`, `IdentityFile`

### Cron Schedule Mistakes
- Forgetting timezone conversion (user says "07:00 WIB" → must convert to UTC)
- Using user's schedule directly without UTC adjustment
- Not restarting gateway after schedule changes

### Skill Naming
- Use project/service name prefix (e.g., `vps-sinyora-health`, not generic `health-check`)
- Keep pattern consistent across related skills (health, backup, ssl-monitor)

## Example: VPS Sinyora

**Context:** Ubuntu 22.04 VPS, Laravel app, MySQL, Redis, Supervisor queue workers, 2 SSL domains

**Phase 1 output:**
- System: 26 days uptime, light load, 35% memory, 17% disk
- Laravel: PHP 8.3.31, Nginx, production mode, Redis queue
- MySQL: 8.0.45, active
- Redis: PONG
- Supervisor: 1 worker (notifications, default queues)
- SSL: 2 domains, 30-36 days until expiry
- Backup: Last backup 40 days ago (manual)

**Phase 2 created:**
- Skills: `vps-sinyora-health`, `vps-sinyora-backup`, `vps-sinyora-ssl-monitor`
- Cron: Health (daily 07:00 WIB), Backup (daily 02:00 WIB), SSL (weekly Sun 08:00 WIB)

**Phase 3 result:**
- Test health check: SUCCESS, all services green
- SSH access: Fixed key ownership (UID 1000 → hermes)
- First backup scheduled: Tonight 02:00 WIB

## Session Reference

See session 2026-06-23 for full VPS Sinyora discovery and setup workflow.
