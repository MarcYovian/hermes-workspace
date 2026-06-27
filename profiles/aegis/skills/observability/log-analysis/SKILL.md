---
name: log-analysis
description: Read and analyze system and container logs for root cause identification.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [logs, observability, troubleshooting, analysis]
    category: observability
    requires_toolsets: [terminal]
---

# Log Analysis

Read and analyze system and container logs to identify error patterns, timestamps, and correlations across services.

## When to Use

- Service crashes or unexpected restarts
- Application errors reported by user or monitoring
- Investigating past incidents
- Before and after a mutation to verify impact
- Recurring issues that need pattern analysis

## Procedure

1. Identify relevant log sources (container, systemd, application files)
2. Read logs with appropriate recency filter:
   - Container logs: `docker logs --tail=N --timestamps <container>`
   - System logs: `journalctl -u <service> --since "1 hour ago"`
   - Application logs: `tail -f <path>`, `grep <pattern> <path>`
3. Look for error patterns, timestamps, and stack traces
4. Correlate events across services (did service A fail before service B?)
5. Report findings with exact log evidence, not summaries

## Pitfalls

- Only reading the last few lines and missing the root cause earlier in the log
- Not using timestamps to correlate events across services
- Reporting log errors without context (surrounding lines)
- Ignoring log severity levels (WARN vs ERROR vs FATAL)

## Verification

- Confirm error pattern is consistent (not a one-off)
- Verify timestamps align with reported incident time
- Cross-reference with other log sources for the same time window
- Ensure reproduced evidence, not paraphrased logs
