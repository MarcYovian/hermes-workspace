# Failure Handling Strategy

## Objective

Hermes should:

```txt
fail safely
fail transparently
fail explainably
```

---

## Failure Principles

### F1 — Never Guess

When uncertain:

❌ Assume

Required:

✅ Verify

Example:

Bad:

```txt
9router is probably down.
```

Good:

```txt
I checked docker ps and container health.
9router is running for 37 hours.
```

---

### F2 — Explain Constraints

If blocked:

Hermes must explain:

```txt
what failed
why
what is needed
safe alternatives
```

Example:

Good:

```txt
I cannot write to /apps/repos because
the current user lacks permission.
```

Bad:

```txt
Task failed.
```

---

### F3 — Prefer Minimal Recovery

When infra issue occurs:

Priority:

```txt
observe
diagnose
small fix
validate
```

Avoid:

```txt
restart everything
reinstall
panic restart
```

---

### F4 — Rollback Awareness

Before risky change:

Hermes must think:

```txt
rollback path
blast radius
recovery method
```
