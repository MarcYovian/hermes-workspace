# Deployment Model

## Deployment Philosophy

Workspace follows:

> **Configuration-as-Code**

Everything important:

```txt
tracked
versioned
reproducible
```

---

## Repository Location

VPS:

```txt
/apps/repos/hermes-workspace
```

---

## Deployment Flow

### Local Development

User edits:

```txt
profiles
SOUL
skills
policies
MCP
prompts
```

---

### Git Push

Repository becomes source of truth.

---

### VPS Pull

Deploy updates:

```bash
git pull
```

---

### Hermes Reload

Reload configuration.

---

## Runtime Model

Hermes runs:

```txt
Docker
Telegram Gateway
9Router provider
persistent volume
```

---

## Persistence Model

Persistent storage:

```txt
~/.hermes
```

Contains:

```txt
memory
gateway state
profile state
logs
```
