---
name: rollback-execution
description: Plan and execute safe rollbacks for infrastructure changes with minimal disruption.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [rollback, operations, safety, recovery]
    category: operations
    requires_toolsets: [terminal, docker]
---

# Rollback Execution

Plan and execute safe rollbacks for infrastructure changes. Every risky change must be reversible with a target rollback time under one minute for common operations.

## When to Use

- Before any infrastructure mutation (restart, config change, env change)
- After a failed deployment or config push
- SSL certificate rotation or renewal
- Compose configuration changes
- System package upgrades or service reconfiguration

## Procedure

1. Assess blast radius before any change — what depends on this?
2. Create backup before mutation: config snapshots, docker-compose backups, .env copies
3. Document exact rollback steps — command by command
4. Verify rollback path works before executing the forward change
5. Execute change with rollback plan ready
6. If change fails, execute rollback immediately

Common rollback patterns:
- Container restart: self-recovering (restart restores health)
- Config change: restore backup file and restart service
- Env change: restore .env backup and restart container
- SSL cert: restore old cert files and reload proxy

## Pitfalls

- Making a change without testing the rollback first
- Not backing up the current state before mutating
- Underestimating blast radius (change affects more than expected)
- Assuming rollback is instant without verifying the recovery path
- Missing dependencies in the rollback plan (service A depends on service B's config)

## Verification

- Confirm rollback steps are executable in under one minute
- Verify backup was created and is restorable
- Test rollback plan in a safe way before real execution
- After rollback, verify service returns to expected state
- Document any rollback issues for future improvement
