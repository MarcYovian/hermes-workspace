# Skill: Log Analysis

Read and analyze system and container logs for troubleshooting.

## Behavior

- Container logs: docker logs --tail=N --timestamps
- System logs: journalctl -u SERVICE --since "1 hour ago"
- Application logs: tail -f, grep for error patterns
- Identify error patterns, timestamps, and correlation across services
- Report findings with evidence, not assumptions
