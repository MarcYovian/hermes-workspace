SOUL sebagai GM IT Team. Struktur: SOUL / Marc (orchestrator/interface ke user) → Aegis (DevOps) + Kairo (Coding). Semua task dari user → Marc → delegasi ke sub-agent → hasil kembali ke Marc → Marc informasikan ke user. Cron jobs dari sub-agent deliver ke local, Marc baca file dan forward ke user. Gateway Telegram hanya aktif di Marc, gateway sub-agent dinonaktifkan.
§
Aegis (DevOps Admin): Custom OpenAI API at http://192.168.10.200:8080/v1. Cron jobs: (1) Home server health report (cd0abfd5aba2, 07:00 WIB daily, deliver local); (2) VPS Sinyora health (93e8d5fee621, 07:30 WIB daily); (3) VPS backup (9221f6b4b292, 02:00 WIB daily); (4) VPS SSL check (c460c46f8830, Sun 08:00 WIB weekly). VPS Sinyora monitoring skills: vps-sinyora-health, vps-sinyora-backup, vps-sinyora-ssl-monitor.
§
User runs Hermes in Docker container. Hermes binary location: /opt/hermes/bin/hermes. Profiles directory: /opt/data/profiles/ (contains atlas, aegis, forge).
§
Hermes environment:
- Hermes executable: /opt/hermes/bin/hermes
- Active profiles: atlas (current), forge, aegis
- Profile data: /opt/data/profiles/
- Hermes CLI tidak ada di PATH, harus pakai full path
§
VPS Sinyora (103.196.154.123): SSH key di /opt/data/profiles/aegis/ssh/sinyora-vps.pem, akses via `ssh sinyora-vps` (SSH config sudah setup). Task yang butuh akses VPS → delegasikan ke Aegis.
§
Semua cron schedule harus mengikuti WIB (UTC+7), bukan UTC. Untuk jam X WIB, gunakan cron schedule jam (X-7) UTC. Contoh: 07:00 WIB = 00:00 UTC = "0 0 * * *". Full conversion table ada di skill orchestrator-delegation references/cron-timezone-wib.md
§
Profile forge diberi nama "Kairo" oleh user. Gateway Telegram disabled (komunikasi via SOUL). Rule wajib: semua project harus berjalan di atas Docker.
§
Delegation ke sub-agent gagal — Custom OpenAI API key Aegis (192.168.10.200:8080/v1) mungkin beda atau belum sync. Untuk task Aegis, coba langsung execute dari SOUL jika delegasi gagal.