# Risks & Mitigation

## Risk 1 — Hallucinated Infra Actions

Example:

```txt
service status assumption
```

Mitigation:

```txt
verify first
terminal proof
read-heavy model
```

---

## Risk 2 — Unsafe File Modification

Example:

```txt
chmod 777
```

Mitigation:

```txt
approval
guardrails
SOUL constraints
```

---

## Risk 3 — Overengineering

Example:

```txt
large unnecessary refactor
```

Mitigation:

```txt
minimal diff philosophy
incremental edits
respect architecture
```

---

## Risk 4 — Git Chaos

Example:

```txt
main branch mutation
```

Mitigation:

```txt
branch enforcement
approval before push
```

---

## Risk 5 — Context Drift

Example:

```txt
agent forgets repo reality
```

Mitigation:

```txt
filesystem inspection
git source of truth
stateless preference
```
