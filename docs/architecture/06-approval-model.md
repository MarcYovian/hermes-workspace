# Approval Model

## Objective

Approval system bertujuan untuk:

```txt
prevent accidental damage
maintain human oversight
avoid destructive automation
increase operational trust
```

Workspace v1 menerapkan:

> **Human-in-the-loop architecture**

Hermes tidak boleh melakukan tindakan berdampak tinggi tanpa explicit user approval.

---

## Approval Philosophy

Default principle:

```txt
Read automatically
Write intentionally
Destroy carefully
```

---

## Approval Matrix

### Level 0 — Auto Allowed

Tidak membutuhkan approval.

Kategori:

```txt
read-only
inspection
analysis
observation
```

Contoh:

```txt
pwd
whoami
ls
tree
cat
grep
tail
head
docker ps
docker logs
docker stats
git status
git diff
git branch
free -h
df -h
uptime
top
journalctl read
```

Purpose:

```txt
diagnostics
inspection
explanation
troubleshooting
```

---

### Level 1 — Approval Required

Butuh approval.

Kategori:

```txt
write
edit
state mutation
git mutation
configuration changes
```

Contoh:

```txt
touch
echo > file
nano
vim
sed -i
cp
mv
git add
git commit
git push
docker compose up
docker restart
systemctl restart
```

Behavior:

Hermes wajib:

1. menjelaskan plan
2. menjelaskan risk
3. meminta approval
4. baru execute

Format reasoning:

```txt
Plan:
1. inspect config
2. modify file
3. validate syntax
4. restart service

Risk:
Low
Only affects Hermes gateway.
```

---

### Level 2 — High Risk Approval

Approval + warning eksplisit.

Kategori:

```txt
delete
stop
infra mutation
permission mutation
package install
```

Contoh:

```txt
rm
docker compose down
systemctl stop
chmod
chown
apt install
apt remove
iptables
ufw changes
```

Behavior:

Hermes wajib:

```txt
explain impact
explain rollback
ask explicit confirmation
```

---

### Level 3 — Forbidden by Default

Tidak boleh dilakukan tanpa explicit override.

Kategori:

```txt
destructive system operations
credential exposure
security weakening
```

Examples:

```txt
chmod 777
rm -rf /
delete repo
drop database
disable firewall
push to main/master
expose secrets
```

Response pattern:

```txt
This action violates workspace policy.
Please explicitly override if intentional.
```
