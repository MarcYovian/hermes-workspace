# Report Forwarder Pattern

Pattern untuk auto-forward cron output dari sub-agent ke user via orchestrator profile. Menghindari gateway Telegram langsung dari sub-agent.

## Problem

Sub-agent cron jobs deliver ke `local` (file output). Orchestrator perlu forward hasil ke user, tapi:
- Tidak bisa manual check setiap saat
- Butuh mekanisme otomatis untuk mendeteksi report baru
- Report harus sampai ke user via Telegram

## Solution: no_agent Cron + Watch Script

Gunakan cron job `no_agent=True` dengan script shell yang:
1. Scan output directories secara periodik
2. Track file modification times (state file)
3. Forward new reports ke Telegram
4. Update state untuk avoid duplicate delivery

### Script Location

Scripts harus di `~/.hermes/scripts/` (relative to hermes user home):

```bash
~/.hermes/scripts/scan_reports.sh
```

### Example: scan_reports.sh

```bash
#!/bin/bash
HERMES_BIN="/opt/hermes/bin/hermes"
OUTPUT_DIR="/opt/data/profiles/devops-admin/cron/output"
STATE_FILE="/opt/data/profiles/marc-default/cron/report_scan_state.json"
TELEGRAM_CHAT_ID="846740826"

# Load state (last seen timestamps)
declare -A LAST_SEEN
if [ -f "$STATE_FILE" ]; then
    while IFS='=' read -r job_id timestamp; do
        LAST_SEEN["$job_id"]="$timestamp"
    done < "$STATE_FILE"
fi

# Process new reports
for job_dir in "$OUTPUT_DIR"/*/; do
    [ -d "$job_dir" ] || continue
    job_id=$(basename "$job_dir")
    latest=$(ls -t "$job_dir"*.md 2>/dev/null | head -1)
    [ -n "$latest" ] || continue
    
    # Check if new
    mtime=$(stat -c %Y "$latest" 2>/dev/null)
    last="${LAST_SEEN[$job_id]:-0}"
    [ "$mtime" -le "$last" ] && continue
    
    # Extract report content (after ## Response)
    content=$(sed -n '/^## Response$/,$p' "$latest" | sed '1d' | head -50)
    
    # Job name mapping
    case "$job_id" in
        "cd0abfd5aba2") job_name="🏠 HOME SERVER" ;;
        "93e8d5fee621") job_name="🌐 VPS SINYORA" ;;
        *) job_name="📋 REPORT" ;;
    esac
    
    # Send to Telegram
    "$HERMES_BIN" -p marc-default chat -q \
        "SILENT: Send message to Telegram chat ${TELEGRAM_CHAT_ID}: ${job_name} — $(basename ${latest} .md | sed 's/_/ /g')

${content}"
    
    # Update state
    grep -v "^${job_id}=" "$STATE_FILE" > "${STATE_FILE}.tmp" || true
    echo "${job_id}=${mtime}" >> "${STATE_FILE}.tmp"
    mv "${STATE_FILE}.tmp" "$STATE_FILE"
done
```

### Cron Job Setup

```python
cronjob(
    action="create",
    name="Marc SOUL - Report Scanner",
    schedule="*/30 * * * *",  # Every 30 minutes
    script="scan_reports.sh",
    no_agent=True,
    deliver="local",
    repeat="∞"
)
```

**Note:** Script path in cron job should be just filename (`scan_reports.sh`), not absolute path. Hermes resolves it from `~/.hermes/scripts/`.

## State File Format

```json
cd0abfd5aba2=1719160200
93e8d5fee621=1719160500
```

- Key: job_id dari cron
- Value: Unix timestamp dari file modification time terakhir yang sudah diproses

## Job ID Mapping

Update script saat ada cron job baru:

```bash
case "$job_id" in
    "cd0abfd5aba2") job_name="🏠 HOME SERVER" ;;
    "93e8d5fee621") job_name="🌐 VPS SINYORA" ;;
    "9221f6b4b292") job_name="💾 VPS BACKUP" ;;
    "c460c46f8830") job_name="🔒 VPS SSL CHECK" ;;
    *) job_name="📋 REPORT ($job_id)" ;;
esac
```

## Alternative: Hermes cron run + poll

Jika tidak mau pakai shell script, alternatif lain:

1. Orchestrator buat cron job yang:
   - List output directories
   - Compare modification times
   - Jika ada file baru → read file → send_message to Telegram

2. Gunakan `delegate_task` dengan LLM-driven analysis:
   - Cron trigger delegate_task
   - Agent baca output dirs
   - Decide mana yang perlu diforward

Tapi shell script lebih reliable dan murah (no LLM cost).

## Real Session Example

**Setup untuk Marc (GM):**

1. Created script: `/opt/data/profiles/marc-default/scripts/scan_reports.sh`
2. Copied to: `~/.hermes/scripts/` (Hermes user home)
3. Made executable: `chmod +x ~/.hermes/scripts/scan_reports.sh`
4. Created state file: `/opt/data/profiles/marc-default/cron/report_scan_state.json`
5. Created cron job:
   - Schedule: `*/30 * * * *` (every 30 min)
   - Deliver: local
   - no_agent: true
   - Result: Report otomatis ke Telegram setiap ada report baru dari Aegis

## Pitfalls

- **Script path wrong**: Hermes only looks in `~/.hermes/scripts/`, not absolute paths. Jika script tidak jalan, verify location.
- **State file race**: Jika 2 instances jalan bersamaan, race condition. Minimal - state file operations tidak atomic. Acceptable untuk low-frequency scans.
- **Chat ID hardcoded**: Telegram chat ID hardcoded dalam script. Jika chat ID berubah, perlu update script.
- **Token limits**: Hermes chat command untuk send message bisa hit rate limits. Jika banyak reports, consider batching atau longer interval.