# VPS Integration Strategy

## Current VPS Layout

```txt
/apps/
├── 9router/
├── hermes-agent/
└── repos/
```

---

## Intended Workspace Layout

```txt
/apps/repos/
│
├── hermes-workspace/
│
├── project-a/
├── project-b/
└── project-c/
```

---

## Access Strategy

### default

Read-only:

```txt
/apps/*
```

---

### devops-admin

Read-all:

```txt
/apps/*
```

Mutating actions:

approval required.

---

### dev-coder

Scoped:

```txt
/apps/repos/*
```

---

## Permission Strategy

Preferred:

```txt
ACL
least privilege
```

Avoid:

```txt
chmod 777
```
