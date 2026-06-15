# Hermes Workspace Architecture

## High-Level Overview

Hermes Workspace berjalan di VPS Ubuntu menggunakan Hermes Agent sebagai orchestration layer, Telegram sebagai communication interface, dan 9Router sebagai model provider abstraction.

Architecture philosophy:

> Delegated, safe, auditable, profile-driven workspace.

---

## Runtime Architecture

```txt
User (Telegram)
        │
        ▼
Hermes Gateway
        │
        ▼
default profile (orchestrator)
        │
 ┌──────┼──────────┐
 ▼      ▼          ▼
devops-admin   dev-coder   future profiles
```

---

## Infrastructure Components

### Hermes Agent

Responsibilities:

- orchestration
- profile delegation
- memory
- approvals
- tools execution

Location:

```txt
/apps/hermes-agent/
```

Runtime:

```txt
Docker
```

---

### 9Router

Responsibilities:

- model routing
- provider abstraction
- fallback logic

Location:

```txt
/apps/9router/
```

API:

```txt
http://192.168.10.200:8080/v1
```

---

### Repositories

Development workspace:

```txt
/apps/repos/
```

Only `dev-coder` may mutate repositories.

---

## Profile Architecture

### default

Role:

```txt
orchestrator
```

Responsibilities:

- understand task
- delegate
- summarize
- coordinate specialists

Restrictions:

- minimal direct mutation

---

### devops-admin

Role:

```txt
infrastructure specialist
```

Scope:

```txt
/apps/*
docker
system diagnostics
```

Mutation:

```txt
approval required
```

---

### dev-coder

Role:

```txt
software engineering specialist
```

Scope:

```txt
/apps/repos/*
```

Git rules:

- branch only
- no main/master push
- approval before push

---

## Filesystem Boundaries

| Profile      | Scope           |
| ------------ | --------------- |
| default      | read-only       |
| devops-admin | `/apps/*`       |
| dev-coder    | `/apps/repos/*` |

---

## Approval Flow

```txt
Read
→ automatic

Write
→ approval

Restart
→ approval

Delete
→ approval
```

---

## Future Expansion

Planned profiles:

- qa-engineer
- research-assistant
- trading analyst
- risk manager
- portfolio manager
