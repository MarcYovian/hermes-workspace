#!/bin/bash
# Atlas - Report Scanner Cron
# Scan cron output directories dan forward report baru ke Telegram
# Schedule: setiap 30 menit (sesuaikan dengan kebutuhan)

HERMES_BIN="/opt/hermes/bin/hermes"
PROFILE_DIR="/opt/data/profiles"
OUTPUT_DIR="$PROFILE_DIR/aegis/cron/output"
STATE_FILE="$PROFILE_DIR/atlas/cron/report_scan_state.json"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-846740826}"

# Load state (last seen timestamps)
declare -A LAST_SEEN
if [ -f "$STATE_FILE" ]; then
    while IFS='=' read -r job_id timestamp; do
        LAST_SEEN["$job_id"]="$timestamp"
    done < "$STATE_FILE"
fi

# Update state file
update_state() {
    local job_id="$1"
    local timestamp="$2"
    LAST_SEEN["$job_id"]="$timestamp"
    grep -v "^${job_id}=" "$STATE_FILE" 2>/dev/null > "${STATE_FILE}.tmp" || true
    echo "${job_id}=${timestamp}" >> "${STATE_FILE}.tmp"
    mv "${STATE_FILE}.tmp" "$STATE_FILE"
}

# Process report files
process_report() {
    local job_id="$1"
    local file_path="$2"
    
    # Skip if already processed (based on mtime)
    local mtime=$(stat -c %Y "$file_path" 2>/dev/null)
    local last="${LAST_SEEN[$job_id]:-0}"
    
    if [ "$mtime" -le "$last" ]; then
        return 0
    fi
    
    # Extract report content (skip frontmatter/headers, get actual report)
    local content=$(sed -n '/^## Response$/,$p' "$file_path" | sed '1d' | head -50)
    
    if [ -z "$content" ] || [ "$content" = '```' ] || [ ${#content} -lt 20 ]; then
        # Try alternative extraction
        content=$(tail -40 "$file_path" | sed '1d')
    fi
    
    # Format message
    local job_name=""
    case "$job_id" in
        "cd0abfd5aba2") job_name="🏠 HOME SERVER" ;;
        "93e8d5fee621") job_name="🌐 VPS SINYORA" ;;
        "9221f6b4b292") job_name="💾 VPS BACKUP" ;;
        "c460c46f8830") job_name="🔒 VPS SSL CHECK" ;;
        *) job_name="📋 REPORT" ;;
    esac
    
    local filename=$(basename "$file_path" .md)
    local timestamp=$(echo "$filename" | sed 's/_/ /g')
    
    local message="${job_name} — ${timestamp}

${content}"

    # Send to Telegram via Hermes
    "$HERMES_BIN" -p atlas chat -q "SILENT: Send message to Telegram chat ${TELEGRAM_CHAT_ID}: ${message}" > /dev/null 2>&1 || true
    
    # Update state
    update_state "$job_id" "$mtime"
}

# Scan all output directories
for job_dir in "$OUTPUT_DIR"/*/; do
    [ -d "$job_dir" ] || continue
    job_id=$(basename "$job_dir")
    
    # Get latest file
    latest=$(ls -t "$job_dir"*.md 2>/dev/null | head -1)
    [ -n "$latest" ] && process_report "$job_id" "$latest"
done

# Clean old state entries (keep only active jobs)
active_jobs="cd0abfd5aba2 93e8d5fee621 9221f6b4b292 c460c46f8830"
if [ -f "$STATE_FILE" ]; then
    for entry in $(grep -v '=' "$STATE_FILE" 2>/dev/null); do
        job_id=$(echo "$entry" | cut -d'=' -f1)
        echo "$entry" | grep -qE "^($active_jobs)=" || sed -i "/^${job_id}=/d" "$STATE_FILE" 2>/dev/null || true
    done
fi

exit 0