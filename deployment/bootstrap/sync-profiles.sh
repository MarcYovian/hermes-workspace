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

# Sync default profile
echo "[*] Syncing default profile..."
if [ -d "$WORKSPACE_DIR/profiles/default" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/default/" "$HERMES_CONFIG_DIR/profiles/default/"
    echo "    -> default profile synced"
else
    echo "    [-] default profile directory not found, skipping"
fi

# Sync devops-admin profile
echo "[*] Syncing devops-admin profile..."
if [ -d "$WORKSPACE_DIR/profiles/devops-admin" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/devops-admin/" "$HERMES_CONFIG_DIR/profiles/devops-admin/"
    echo "    -> devops-admin profile synced"
else
    echo "    [-] devops-admin profile directory not found, skipping"
fi

# Sync dev-coder profile
echo "[*] Syncing dev-coder profile..."
if [ -d "$WORKSPACE_DIR/profiles/dev-coder" ]; then
    rsync -a --delete "$WORKSPACE_DIR/profiles/dev-coder/" "$HERMES_CONFIG_DIR/profiles/dev-coder/"
    echo "    -> dev-coder profile synced"
else
    echo "    [-] dev-coder profile directory not found, skipping"
fi

# Sync shared configs
echo "[*] Syncing shared configurations..."
if [ -d "$WORKSPACE_DIR/shared" ]; then
    rsync -a "$WORKSPACE_DIR/shared/" "$HERMES_CONFIG_DIR/shared/"
    echo "    -> shared configs synced"
fi

echo "[+] Profile sync complete."

# Remind to reload Hermes
echo "[*] Reload Hermes to apply changes:"
echo "    docker compose restart hermes-agent"
