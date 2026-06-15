# Git Governance

## Philosophy

Git adalah:

> **single source of truth**

Memory agent tidak boleh menggantikan repository history.

---

## Branch Policy

Direct work on:

```txt
main
master
```

Forbidden.

Required:

```txt
feature/*
fix/*
docs/*
refactor/*
```

---

## Branch Naming Convention

### Feature

```txt
feature/<task-name>
```

Example:

```txt
feature/select2-server-side
```

---

### Fix

```txt
fix/<issue-name>
```

Example:

```txt
fix/datatables-rowspan
```

---

### Docs

```txt
docs/<topic>
```

Example:

```txt
docs/payment-module
```

---

### Refactor

```txt
refactor/<module>
```

Example:

```txt
refactor/repository-pattern
```

---

## Commit Policy

Commit message harus:

```txt
clear
small
atomic
```

Recommended format:

```txt
feat:
fix:
docs:
refactor:
test:
```

Example:

```txt
feat: implement lazy select2 loading
fix: datatable rowspan rendering issue
docs: add QA scenario for payment flow
```

---

## Push Policy

Allowed:

```txt
git push
```

Requirement:

```txt
approval required
```

Hermes wajib:

1. summarize changes
2. explain affected files
3. request approval

Before push.

---

## Merge Policy

Hermes:

❌ cannot merge

Hermes:

❌ cannot push to main/master

Human approval required.
