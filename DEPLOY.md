# Deploy — Hermes Workspace v1.1 (Docker)

Setup Docker-based Hermes dengan multi-profile (Atlas/Aegis/Forge) + Kanban.

> **Setup existing:**
> - Docker compose: `~/apps/hermes-agent/docker-compose.yml`
> - Container name: `hermes-agent`
> - Mount: `~/.hermes:/opt/data`, `~/apps:/apps`
>
> **Legend:**
> - 🖥️ **HOST** = jalankan di terminal VPS (bukan di dalam container)
> - 📦 **CONTAINER** = jalankan via `docker exec hermes-agent ...`
>
> **User:** SEMUA command di sini dijalankan sebagai **user biasa (`yann`)** — tidak perlu `sudo`.
> User `yann` sudah punya akses `docker` (via group) dan akses tulis ke `~/.hermes/` serta `~/apps/`.

---

## 1. Pull Perubahan Workspace

🖥️ **HOST:**

```bash
cd ~/apps/repos/hermes-workspace
git pull
```

---

## 2. Backup & Hapus Profile Lama

🖥️ **HOST:**

```bash
# Backup seluruh ~/.hermes
cp -r ~/.hermes ~/.hermes.bak

# Hapus profile lama (sudah di-rename)
rm -rf ~/.hermes/profiles/default
rm -rf ~/.hermes/profiles/devops-admin
rm -rf ~/.hermes/profiles/dev-coder
```

---

## 3. Copy Profile Baru

🖥️ **HOST:**

```bash
mkdir -p ~/.hermes/profiles/atlas
mkdir -p ~/.hermes/profiles/aegis
mkdir -p ~/.hermes/profiles/forge

cp -r ~/apps/repos/hermes-workspace/profiles/atlas/* ~/.hermes/profiles/atlas/
cp -r ~/apps/repos/hermes-workspace/profiles/aegis/* ~/.hermes/profiles/aegis/
cp -r ~/apps/repos/hermes-workspace/profiles/forge/* ~/.hermes/profiles/forge/
```

---

## 4. Setup .env per Profile

🖥️ **HOST:** — file-file ini akan terbaca oleh container via mount `~/.hermes:/opt/data`

**`~/.hermes/profiles/atlas/.env`:**

```bash
OPENAI_API_KEY=sk-xxxx...       # ganti dengan key asli di VPS
TELEGRAM_BOT_TOKEN=xxxx:xxxx    # ganti dengan token asli di VPS
TELEGRAM_ALLOWED_USERS=846740826
TELEGRAM_HOME_CHANNEL=846740826
```

**`~/.hermes/profiles/aegis/.env`:**

```bash
OPENAI_API_KEY=sk-xxxx...    # ganti dengan key asli di VPS
```

**`~/.hermes/profiles/forge/.env`:**

```bash
OPENAI_API_KEY=sk-xxxx...    # ganti dengan key asli di VPS
```

---

## 5. Setup Global Kanban Config

🖥️ **HOST:** — buat/sunting `~/.hermes/config.yaml`

```yaml
kanban:
  dispatch_in_gateway: true
  dispatch_interval_seconds: 60
  auto_decompose: true
  auto_decompose_per_tick: 3
  orchestrator_profile: atlas
  auto_subscribe_on_create: true
```

---

## 6. Restart Container (biar baca config & .env yang baru)

🖥️ **HOST:**

```bash
cd ~/apps/hermes-agent
docker compose down
docker compose up -d

# Cek log sampai muncul "gateway running"
docker compose logs -f
```

> Setelah这一步, gateway container sudah jalan dengan config baru.
> Tapi profile-nya belum diregistrasi — lanjut ke step 7.

---

## 7. Register Profile via Hermes CLI

📦 **CONTAINER:** — jalanin satu per satu

```bash
docker exec hermes-agent hermes profile install /apps/repos/hermes-workspace/profiles/atlas
docker exec hermes-agent hermes profile install /apps/repos/hermes-workspace/profiles/aegis
docker exec hermes-agent hermes profile install /apps/repos/hermes-workspace/profiles/forge

# Verifikasi
docker exec hermes-agent hermes profile list
```

Output harusnya:

```
atlas (orchestrator)
aegis (DevOps Admin)
forge (Software Engineer)
```

---

## 8. Opt-Out Bundled Skills (biar profile tetap bersih)

📦 **CONTAINER:**

> `hermes profile install` otomatis men-seed bundled skills (~100+ skill) ke setiap profile.
> Skills ini kebanyakan tidak relevan (ComfyUI, LaTeX template, Apple Notes, dll).
> Kita matikan seeding + hapus yang sudah terlanjur terinstall.

```bash
# Untuk semua profile sekaligus
for p in atlas aegis forge; do
  docker exec hermes-agent hermes -p $p skills opt-out --remove --yes
done

# Verifikasi — bundled skills sudah terhapus
docker exec hermes-agent hermes skills list
```

> **Penjelasan:**
> - `opt-out` → tulis `.no-bundled-skills` marker → `hermes update` tidak akan seed ulang
> - `--remove` → hapus bundled skills yang **tidak dimodifikasi** (byte-identical)
> - Skill buatan sendiri, skill dari hub, atau skill yang sudah diedit tetap aman
> - Mau undo? `hermes skills opt-in --sync`

---

## 9. Setup Profile Descriptions (untuk kanban routing akurat)

📦 **CONTAINER:**

```bash
docker exec hermes-agent hermes profile describe atlas --text "Orchestrator GM IT/CTO: decompose user requests, delegate to specialists via kanban, aggregate results, summarize."
docker exec hermes-agent hermes profile describe aegis --text "DevOps Admin: Docker, VPS, networking, SSL, SSH, monitoring, system resources, cron, deployment."
docker exec hermes-agent hermes profile describe forge --text "Software Engineer: Laravel, Odoo, Nuxt, API, SQL, refactoring, testing, Docker-based development."
```

---

## 10. Init Kanban Board

📦 **CONTAINER:**

```bash
docker exec hermes-agent hermes kanban init
docker exec hermes-agent hermes kanban list
docker exec hermes-agent hermes kanban show
```

---

## 11. Restart Container (biar gateway detek kanban board + profile baru)

🖥️ **HOST:**

```bash
cd ~/apps/hermes-agent
docker compose restart

# Cek apakah dispatcher aktif
docker compose logs -f | grep -i kanban
```

---

## 12. Test

### Test via CLI

📦 **CONTAINER:**

```bash
# Buat task
docker exec hermes-agent hermes kanban create \
  --title "Cek disk usage server home" \
  --assignee aegis \
  --description "Periksa disk usage, cari file besar"

# Tunggu ~60 detik (dispatch interval), lalu cek status
docker exec hermes-agent hermes kanban list --state running
docker exec hermes-agent hermes kanban list --state done
```

### Test via Telegram

🖥️ **DARI HP:** — chat ke bot Telegram Atlas

```
Cek kesehatan server home
```

Yang harus terjadi:
1. Atlas terima chat → triage → ini infra task
2. Atlas panggil `kanban_create(assignee="aegis", ...)`
3. Dispatcher (di dalam gateway) spawn Aegis
4. Aegis jalan, diagnosa, selesai → `kanban_complete(summary, metadata)`
5. Atlas dapat notifikasi → rangkum hasil → kirim ke kamu

---

## Troubleshooting

| Problem | Cek |
|---------|-----|
| Profile not found | 📦 `docker exec hermes-agent hermes profile list` |
| Container crash loop | 🖥️ `docker compose logs hermes-agent` |
| Task stuck "ready" | 📦 `docker exec hermes-agent hermes kanban show --id <task_id>` — pastikan assignee valid (aegis/forge) |
| Dispatcher tidak jalan | 🖥️ `cat ~/.hermes/config.yaml` — pastikan ada `dispatch_in_gateway: true` |
| Notifikasi tidak sampai | 🖥️ `cat ~/.hermes/profiles/atlas/config.yaml` — pastikan ada `notification_sources: ["*"]` |

---

## Rollback

🖥️ **HOST:**

```bash
cd ~/apps/hermes-agent
docker compose down

# Kembalikan backup
rm -rf ~/.hermes
cp -r ~/.hermes.bak ~/.hermes

# Git revert
cd ~/apps/repos/hermes-workspace
git revert HEAD --no-edit

# Start ulang
cd ~/apps/hermes-agent
docker compose up -d
```
