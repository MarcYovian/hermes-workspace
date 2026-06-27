#!/usr/bin/env bash
# =============================================================================
# sync-profiles.sh — Sync workspace profiles to Hermes config
# =============================================================================
# Syncs profile configurations from workspace repository to Hermes runtime.
# Run after updating profiles/ directory.
# =============================================================================
set -euo pipefail

WORKSPACE_DIR="/apps/repos/hermes-workspace"
HERMES_CONFIG_DIR="$HOME/.hermes"

echo "[+] Syncing Hermes profiles..."

# Sync Atlas profile (orchestrator)
echo "[*] Syncing atlas profile..."
if [ -d "$WORKSPACE_DIR/profiles/atlas" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/atlas/" "$HERMES_CONFIG_DIR/profiles/atlas/"
    echo "    -> atlas profile synced"
else
    echo "    [-] atlas profile directory not found, skipping"
fi

# Sync Aegis profile (DevOps Admin)
echo "[*] Syncing aegis profile..."
if [ -d "$WORKSPACE_DIR/profiles/aegis" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/aegis/" "$HERMES_CONFIG_DIR/profiles/aegis/"
    echo "    -> aegis profile synced"
else
    echo "    [-] aegis profile directory not found, skipping"
fi

# Sync Forge profile (Software Engineer)
echo "[*] Syncing forge profile..."
if [ -d "$WORKSPACE_DIR/profiles/forge" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/forge/" "$HERMES_CONFIG_DIR/profiles/forge/"
    echo "    -> forge profile synced"
else
    echo "    [-] forge profile directory not found, skipping"
fi

echo "[+] Profile sync complete."

# Remind to reload Hermes
echo "[*] Reload Hermes to apply changes:"
echo "    docker compose restart hermes-agent"
