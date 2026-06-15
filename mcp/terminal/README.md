# MCP: Terminal

## Purpose

Terminal command execution for system diagnostics and operations.

## Scope

- Read-only system inspection commands
- Service management (approval-gated)
- Script execution (approval-gated)
- Log reading

## Command Filtering

### Auto-allowed commands
- ls, pwd, whoami, id, groups
- cat, head, tail, grep, find (read-only)
- docker ps, docker logs, docker inspect, docker stats
- systemctl status, journalctl
- ss, netstat, free, df, du, uptime, top, ps
- git status, git log, git diff, git branch
- curl (GET requests for health checks)

### Approval-required commands
- touch, mkdir, cp, mv, rm
- echo ">" (file write), sed -i
- docker compose up/down/restart
- systemctl start/stop/restart/reload
- apt install/remove
- ufw, iptables

### Forbidden commands
- chmod 777, chmod -R 777
- rm -rf /, rm -rf /*
- docker system prune -a
- ufw reset, iptables -F
- git push -f
- sudo without explicit approval context

## Integration

```
MCP Server: terminal
Transport: stdio or HTTP
Shell: bash
Working directory: /apps
```

## Security

- Command output captured and logged
- Long-running commands have timeout
- Dangerous commands filtered at MCP level
- All executed commands logged for audit
