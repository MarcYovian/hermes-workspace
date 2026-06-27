---
name: server-health
description: Daily server health check — uptime, CPU load, RAM, disk, Docker, services, network, pending updates, and overall condition report.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [monitoring, health, diagnostics, daily-report]
    category: monitoring
    requires_toolsets: [terminal]
---

# Server Health Check

Run a comprehensive daily health check covering uptime, CPU load, RAM, disk, Docker containers, critical services, network connectivity, pending system updates, and overall server condition.

## When to Use

- Daily scheduled health check (via cron)
- Before any infrastructure mutation — verify baseline health first
- When investigating performance issues or anomalies
- After maintenance to confirm server returned to healthy state

## Procedure

1. **Uptime** — `uptime` to check how long the server has been running and load averages (1, 5, 15 min)
2. **CPU Load** — `cat /proc/loadavg` or `uptime`; compare load avg against CPU core count
3. **RAM Usage** — `free -h` for total, used, available
4. **Disk Usage** — `df -h` for all mounted volumes; flag any partition >80%
5. **Docker Containers** — `docker ps -a` to list all containers with status; flag any that are exited, unhealthy, or restarting
6. **Critical Services** — `systemctl is-active -- <service>` for key services (nginx, ssh, docker, etc.)
7. **Network Connectivity** — `ss -tulpn` for listening ports; `curl -o /dev/null -s -w "%{http_code}" <health-endpoint>` for app health
8. **Pending Updates** — `apt list --upgradable 2>/dev/null` to count available security and package updates
9. **Overall Condition** — synthesize all findings into a status: HEALTHY / DEGRADED / CRITICAL
10. **Server Notes** — record any anomalies, trends, or recommendations

### Report Format

```
## Server Health Report — <date>

**Uptime:** <uptime output>
**Load Average:** <1min / 5min / 15min> (cores: N)
**RAM:** <used> / <total> (<percent>%)
**Disk:**
  - /: <used> / <total> (<percent>%) — <OK/WARN/CRIT>
  - /apps: <used> / <total> (<percent>%) — <OK/WARN/CRIT>
**Docker:**
  - Running: N
  - Exited: N — <list if any>
  - Unhealthy: N — <list if any>
**Services:**
  - nginx: <active/inactive>
  - ssh: <active/inactive>
  - docker: <active/inactive>
**Network:**
  - Listening ports: <list>
  - App health endpoint: <HTTP code or unreachable>
**Pending Updates:** N packages
**Condition:** HEALTHY / DEGRADED / CRITICAL
**Notes:** <observations, trends, recommendations>
```

## Pitfalls

- Reporting load average without comparing against CPU core count (load 4 on 2-core is high; on 8-core is fine)
- Flagging `docker ps -a` exited containers that are intentionally stopped (e.g., batch jobs)
- Not distinguishing between security updates and general package updates
- Checking service status without verifying it's actually serving traffic
- Reporting disk usage without checking inode usage (`df -i`)

## Verification

- Confirm each metric was read from live command output, not assumed
- Cross-check Docker health with service status (container running but app inside may be down)
- Verify network listening ports match expected services
- Ensure overall condition rating matches the evidence
- If CRITICAL, include immediate recommended action
