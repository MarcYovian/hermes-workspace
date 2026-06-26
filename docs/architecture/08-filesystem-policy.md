# Filesystem Access Policy

## Global Rule

Filesystem follows:

```txt
read-mostly
write-intentionally
```

---

## Allowed Directories

### `default`

Read-only:

```txt
/apps/*
```

No write.

---

### `aegis`

Read:

```txt
full VPS visibility
```

Write:

approval required.

---

### `forge`

Allowed workspace:

```txt
/apps/repos/*
```

Expected work:

```txt
project source code
tests
documentation
config
scripts
```

Restricted:

```txt
system directories
infra folders
```

---

## Permission Strategy

Workspace avoids:

```txt
chmod 777
```

Preferred:

```txt
ACL
group permissions
least privilege
```

Rationale:

```txt
safer
maintainable
git-friendly
production-ready
```
