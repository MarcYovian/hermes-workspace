# 24. Acceptance Criteria (v1)

Workspace v1 considered successful if:

---

## AC1 — Telegram Works

User can:

```txt
chat with Hermes
trigger workflows
approve actions
```

---

## AC2 — Safe Diagnostics

Hermes can:

```txt
inspect VPS
inspect Docker
inspect logs
```

without destructive behavior.

---

## AC3 — Safe Coding

Hermes can:

```txt
create branch
modify repo
commit
push
```

without touching:

```txt
main/master
```

---

## AC4 — Approval System Works

Mutation actions require approval.

---

## AC5 — Observability Exists

Workspace actions traceable.

---

## AC6 — Configuration-as-Code

Workspace reproducible from Git.

---

## AC7 — Stable Multi-profile Behavior

Profiles:

```txt
default
devops-admin
dev-coder
```

have:

```txt
clear responsibility
minimal overlap
predictable behavior
```
