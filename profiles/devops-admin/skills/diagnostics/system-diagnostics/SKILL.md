---
name: system-diagnostics
description: Inspect host system resources, services, and network state for troubleshooting.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [system, diagnostics, resources, services, networking]
    category: diagnostics
    requires_toolsets: [terminal]
---

# System Diagnostics

Inspect host system resources, services, and network state to gather evidence before any diagnosis or mutation.

## When to Use

- System performance issues (high CPU, memory, disk)
- Service failure or unexpected behavior
- Before any host-level mutation
- Network connectivity issues
- Disk space warnings or filling up

## Procedure

1. Check resource usage: `free -h`, `df -h`, `du -sh <path>`, `uptime`, `top` / `htop`
2. Check service status: `systemctl status <service>`, `journalctl -u <service> --since "1 hour ago"`
3. Check network state: `ss -tulpn`, `netstat`, `curl <health-endpoint>`
4. Check firewall: `ufw status`
5. Correlate findings across resource, service, and network data
6. Report evidence-based diagnosis

Always gather evidence before recommendations. Never assume state.

## Pitfalls

- Reporting disk usage without checking which directory is growing
- Checking service status without checking its logs
- Assuming firewall state without verifying with `ufw status`
- Overlooking OOM kills when diagnosing service crashes

## Verification

- Confirm resource metrics match the reported issue
- Verify service logs confirm rather than contradict the hypothesis
- Cross-check network state with expected open ports
- Ensure diagnosis cites real command output, not assumptions
