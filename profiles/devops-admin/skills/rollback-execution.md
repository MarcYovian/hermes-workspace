# Skill: Rollback Execution

Plan and execute safe rollbacks for infrastructure changes.

## Behavior

- Assess blast radius before any change
- Create backup before mutation (config snapshots, docker-compose backups)
- Document exact rollback steps
- Verify rollback path works before executing change
- Target rollback < 1 minute for common operations

## Common Rollback Patterns

Container restart: self-recovering (restart restores health)
Config change: restore backup file and restart service
Env change: restore .env backup and restart container
SSL cert: restore old cert files and reload proxy
