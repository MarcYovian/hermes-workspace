# Vision

## Vision Statement

Membangun AI workspace yang dapat bertindak sebagai:

> "Trusted engineering companion for software development and infrastructure management"

dengan pendekatan:

```txt
safe
auditable
delegated
controlled
production-ready
```

Hermes Workspace tidak bertujuan menggantikan human decision-making, melainkan menjadi:

```txt
co-pilot
engineer assistant
system analyst
workflow accelerator
```

# Goals

## Primary Goals (v1)

### G1 — Safe VPS Interaction

Hermes dapat:

- membaca kondisi server
- membaca filesystem
- membaca docker state
- membaca logs
- melakukan troubleshooting

tanpa memberikan risiko destructive action yang tidak disengaja.

---

### G2 — AI Coding Assistant

Hermes dapat membantu:

```txt
coding
refactoring
debugging
documentation
git workflow
project understanding
module analysis
```

khusus pada:

```txt
/apps/repos/*
```

---

### G3 — Separation of Responsibility

Setiap profile memiliki:

```txt
single responsibility
clear scope
bounded permissions
specialized behavior
```

Tujuan:

mengurangi hallucination, overlap context, dan unsafe operations.

---

### G4 — Approval-First Safety

Semua operasi:

```txt
write
delete
restart
deployment
service change
docker mutation
git push
```

harus explicit approval.

---

### G5 — Reproducible Workspace

Seluruh konfigurasi Hermes harus:

```txt
version controlled
documented
portable
restorable
```

melalui repository khusus:

```txt
hermes-workspace
```

---

# 4. Non-Goals (Out of Scope v1)

Hal-hal berikut **tidak dilakukan di v1**:

## NG1 — Autonomous Trading

Tidak ada:

```txt
auto execution
auto leverage
auto futures order
```

Trading hanya future roadmap.

---

## NG2 — Fully Autonomous Infrastructure

Hermes tidak boleh:

```txt
auto restart services
auto patch production
auto modify configs
auto deploy
```

tanpa approval.

---

## NG3 — Autonomous Coding Merge

Hermes tidak boleh:

```txt
push to main
push to master
merge PR
release code
```

secara otomatis.

---

## NG4 — Unlimited System Access

Tidak semua profile memiliki akses penuh ke server.

Access harus:

```txt
principle of least privilege
```
