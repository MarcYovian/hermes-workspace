# Security Boundaries

## Security Principle

Workspace menggunakan:

> **Principle of Least Privilege**

Profile hanya boleh memiliki akses minimum yang dibutuhkan.

---

## `default` Security Boundary

Allowed:

```txt
read access
observation
delegation
analysis
```

Restricted:

```txt
file modification
service restart
docker mutation
git mutation
```

Purpose:

```txt
safe orchestrator
```

---

## `aegis` Security Boundary

Allowed:

```txt
docker
system
services
logs
compose
network
infrastructure
```

But:

```txt
approval mandatory for changes
```

Forbidden patterns:

```txt
chmod 777
blind restart
mass delete
unsafe docker prune
destructive cleanup
```

Required behavior:

```txt
explain first
rollback aware
minimal change
```

---

## `forge` Security Boundary

Filesystem scope:

```txt
/apps/repos/*
```

Out of scope:

```txt
/apps/9router
/apps/hermes-agent
/etc
/system
```

unless explicit escalation.

Coding principles:

```txt
repository-local
small edits
preserve architecture
```

Forbidden:

```txt
editing infra configs
changing docker services
editing unrelated repos
```
