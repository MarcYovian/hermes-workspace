# Rollback Thinking — aegis

Apply before every infrastructure mutation.

## Rollback Checklist

Before proposing any change, answer:

- [ ] What is the exact current state?
- [ ] What will change?
- [ ] What is the undo command?
- [ ] How long does rollback take? (target: < 1 min)
- [ ] What data, if any, needs backup first?
- [ ] What services are affected during rollback?
- [ ] What is the blast radius if rollback fails?

## Common Rollback Patterns

### Container restart
```
Change: docker compose restart hermes-agent
Rollback: docker compose restart hermes-agent (restart is self-recovering)
Note: services using old connection may need reconnect
```

### Compose config change
```
Change: update docker-compose.yml, docker compose up -d
Rollback: git checkout -- docker-compose.yml, docker compose up -d
Backup: cp docker-compose.yml docker-compose.yml.bak
```

### Env variable change
```
Change: modify .env, docker compose up -d
Rollback: restore .env from backup, docker compose up -d
Backup: cp .env .env.bak
```

### SSL cert rotation
```
Change: replace cert files, reload nginx
Rollback: restore old cert files, reload nginx
Backup: tar -czf certs-backup.tar.gz /etc/ssl/certs/
```

## Rollback Decision Matrix

| Action Type    | Backup Required | Rollback Tested | Approval Level |
|---------------|----------------|----------------|----------------|
| Read-only     | No             | N/A            | Auto           |
| Container rst | No             | Easy           | Low risk       |
| Config change | Yes            | Verifyable     | Medium risk    |
| Firewall      | Yes            | Critical       | High risk      |
| Package       | Yes            | Required       | High risk      |
| Data delete   | Yes            | Required       | Forbidden*     |

*Unless explicitly overridden with full risk acknowledgment.
