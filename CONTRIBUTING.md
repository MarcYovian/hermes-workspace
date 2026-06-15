# Contributing Guide

## Purpose

This repository follows:

> Safety-first, approval-first, production-minded engineering.

All changes must be:

- minimal
- reversible
- auditable
- intentional

---

## Engineering Philosophy

Prefer:

```txt
small changes
incremental improvements
minimal diff
```

Avoid:

```txt
large refactor without reason
architecture rewrite
unnecessary abstractions
```

---

## Git Workflow

Never work directly on:

```txt
main
master
```

Required workflow:

```txt
main
 └── feature/*
 └── fix/*
 └── refactor/*
```

Example:

```bash
git checkout -b fix/datatables-rendering
```

---

## Commit Style

Preferred:

```txt
feat:
fix:
refactor:
docs:
test:
chore:
```

Examples:

```txt
fix: resolve datatable rowspan rendering
docs: add dev-coder profile policy
refactor: simplify repository service
```

---

## AI Agent Rules

AI agents must:

- inspect first
- explain reasoning
- minimize changes
- ask approval before mutation

AI agents must not:

- assume infra state
- push to main
- use chmod 777
- restart services blindly

---

## Repository Boundaries

Allowed:

```txt
/apps/repos/*
```

Restricted:

```txt
/apps/hermes-agent
/apps/9router
system folders
```

Unless explicitly approved.

---

## Documentation Standards

Architecture decisions:

```txt
docs/decisions/
```

Operational procedures:

```txt
runbooks/
```

Profile specifications:

```txt
profiles/
```
