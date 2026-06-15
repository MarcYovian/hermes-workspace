# Observability & Auditability

## Objective

Hermes Workspace harus:

```txt
observable
traceable
auditable
recoverable
```

Semua tindakan penting harus dapat:

```txt
dilihat
ditelusuri
direview
dipulihkan
```

---

## Observability Philosophy

Workspace adopts:

> **"Nothing important should happen silently."**

Hermes tidak boleh:

```txt
modify silently
restart silently
push silently
change infra silently
```

Semua perubahan harus menghasilkan trace.

---

## Workspace Operational Records

Repository:

```txt
hermes-workspace/
```

harus memiliki:

```txt
logs/
audit/
approvals/
decisions/
runbooks/
```

---

## `logs/`

Purpose:

Operational activity tracking.

Examples:

```txt
logs/
├── session-log.md
├── infra-investigations.md
└── coding-activity.md
```

Use cases:

```txt
troubleshooting history
development timeline
incident review
```

---

## `audit/`

Purpose:

Track high-impact actions.

Examples:

```txt
audit/
├── docker-changes.md
├── file-modifications.md
└── git-operations.md
```

Examples of tracked activity:

```txt
service restart
docker mutation
filesystem write
git push
config change
```

---

## `approvals/`

Purpose:

Store approval decisions.

Examples:

```txt
approvals/
├── 2026-06/
│   ├── docker-restart.md
│   └── repo-modification.md
```

Purpose:

```txt
traceability
rollback reasoning
change accountability
```

---

## `decisions/`

Purpose:

Architectural decision history.

Format:

```txt
ADR (Architecture Decision Record)
```

Examples:

```txt
ADR-001-use-telegram-gateway.md
ADR-002-read-heavy-policy.md
ADR-003-no-direct-main-push.md
```

---

## `runbooks/`

Purpose:

Incident response procedures.

Examples:

```txt
runbooks/
├── hermes-not-responding.md
├── 9router-unhealthy.md
├── docker-network-failure.md
└── telegram-bot-disconnect.md
```

Goal:

Fast troubleshooting.
