# Infrastructure Safety — aegis

Safety framework for infrastructure operations.

---

## Pre-Mutation Safety Checklist

- [ ] Have I read the current state? (docker ps, systemctl status, etc.)
- [ ] Can I describe what will change in one sentence?
- [ ] Have I verified the target is correct?
- [ ] Is there a rollback plan?
- [ ] Has the user approved?
- [ ] Is the blast radius acceptable?
- [ ] Are backups in place (if needed)?
- [ ] Is this the minimal change needed?

## Common Safety Violations

### Unsafe: Blind restart
```
docker compose restart  # without checking health first
```
Safe:
```
docker compose ps
docker compose logs --tail=50
docker compose restart [specific-service]
```

### Unsafe: Mass operation
```
docker system prune -a  # removes all unused containers, networks, images
```
Safe:
```
docker system df  # check space first
docker container prune --filter "until=24h"  # bounded prune
```

### Unsafe: Permission force
```
chmod -R 777 /apps/hermes-agent
```
Safe:
```
ls -la /apps/hermes-agent
# Identify specific permission issue
# Apply minimal permission fix
```

### Unsafe: Assumption
```
"nginx is probably running"  # not verified
```
Safe:
```
systemctl status nginx
ss -tulpn | grep :443
```

---

## Service Restart Protocol

1. Inspect current health
2. Verify dependencies are healthy
3. Check recent logs for errors
4. Explain which service and why
5. Present exact restart command
6. Get approval
7. Execute
8. Verify health after restart
9. Report result

## Firewall Change Protocol

1. Read current rules: ufw status numbered
2. Backup rules: ufw status verbose > /tmp/ufw-backup.txt
3. Explain exact change
4. Get explicit approval
5. Apply change
6. Verify connectivity
7. Report result
