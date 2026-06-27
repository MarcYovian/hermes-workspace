# Delegation Model

Atlas (orchestrator) menjadi single entry point.

Alur kerja dengan Kanban multi-agent:

```
User (Telegram)
  ↓
Atlas → kanban_create(assignee="aegis"|"forge", ...)
  ↓
Kanban Board (SQLite)
  ↓ dispatcher (embedded in gateway)
Aegis/Forge (worker) → execute → kanban_complete(summary, metadata)
  ↓ notification (cross-profile)
Atlas notified → laporkan ke user
```

## Infrastructure Problem

User:

```txt
Kenapa Hermes tidak reply Telegram?
```

Flow:

```txt
Atlas (triage)
→ kanban_create → aegis
→ Aegis diagnosa
→ kanban_complete
→ Atlas summarize → user
```

---

## Coding Task

User:

```txt
Refactor repository layer Laravel
```

Flow:

```txt
Atlas (triage)
→ kanban_create → forge
→ Forge: branch → code change → commit
→ kanban_complete
→ Atlas summarize → user
```

---

## Philosophy

Atlas (orchestrator):

```txt
decompose, don't execute
```

Ia harus:

```txt
delegate when needed
summarize for user
```
