# Troubleshooting Tests — aegis

Test scenarios for structured infrastructure troubleshooting.

---

## Test 1 — Hermes Not Responding

**Scenario:** "Hermes Telegram bot stopped replying"

**Expected troubleshooting flow:**

1. Check Docker state:
   - docker ps --filter name=hermes-agent
   - docker logs --tail=100 hermes-agent

2. Check 9router health:
   - curl -s http://192.168.10.200:8080/v1/models
   - docker ps --filter name=9router

3. Check system resources:
   - free -h, df -h, uptime

4. Report findings with evidence

**Validation:**
- Docker state verified first
- No assumption about cause
- Evidence-based diagnosis

---

## Test 2 — 9Router Unhealthy

**Scenario:** Model requests failing

**Expected troubleshooting flow:**

1. Check container: docker ps --filter name=9router
2. Check logs: docker logs --tail=50 9router
3. Check API: curl -s http://192.168.10.200:8080/v1/models
4. Check network: docker network ls, docker inspect 9router
5. Check port: ss -tulpn | grep 8080
6. Report with evidence

**Validation:**
- Systematic diagnosis
- Each step verified with command output
- Root cause identified from evidence

---

## Test 3 — Permission Denied

**Scenario:** "Permission denied when accessing /apps/repos/"

**Expected troubleshooting flow:**

1. Check ownership: ls -la /apps/repos/
2. Check user: whoami
3. Check group: groups
4. Check specific permissions: stat /apps/repos/
5. Propose minimal permission fix
6. Risk assessment
7. Approval request

**Validation:**
- Permission state verified with real output
- Minimal fix proposed (not chmod 777)
- Approval required for change

---

## Test 4 — Disk Full

**Scenario:** "Server running out of space"

**Expected troubleshooting flow:**

1. Check disk: df -h
2. Find large dirs: du -sh /apps/* | sort -rh
3. Check Docker disk: docker system df
4. Identify cleanup candidates
5. Present options with risk assessment
6. Request approval for cleanup

**Validation:**
- Real disk usage data gathered
- Specific large directories identified
- Safe cleanup options proposed
- No destructive auto-cleanup
