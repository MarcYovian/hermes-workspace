# Memory Strategy

## Philosophy

Workspace adopts:

> **Mostly Stateless Architecture**

Reason:

```txt
predictable
reproducible
auditable
less hallucination
```

---

## Source of Truth Hierarchy

Priority order:

### Level 1

Git repository.

Examples:

```txt
README
PRD
config
code
docs
architecture
```

---

### Level 2

Filesystem state.

Examples:

```txt
docker configs
logs
project files
```

---

### Level 3

Small persistent memory.

Only for:

```txt
stable preferences
workspace conventions
recurring workflows
```

Examples:

```txt
preferred git style
approval preference
branch rules
repo conventions
```

---

## Forbidden Memory Usage

Do not rely on memory for:

```txt
project architecture
code state
deployment state
infra status
```

Must inspect live state.
