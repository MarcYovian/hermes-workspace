#!/usr/bin/env bash
# =============================================================================
# setup-hermes.sh — Hermes Workspace Bootstrap
# =============================================================================
# Run on fresh VPS Ubuntu to bootstrap Hermes workspace.
# Idempotent — safe to run multiple times.
# =============================================================================
set -euo pipefail

WORKSPACE_DIR="/apps/repos/hermes-workspace"
HERMES_CONFIG_DIR="$HOME/.hermes"

echo "[+] Starting Hermes workspace bootstrap..."

# 1. Verify prerequisites
echo "[*] Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo "[-] Docker not found. Install Docker first."; exit 1; }
command -v docker compose >/dev/null 2>&1 || { echo "[-] Docker Compose not found. Install Docker Compose first."; exit 1; }
command -v git >/dev/null 2>&1 || { echo "[-] Git not found. Install Git first."; exit 1; }

# 2. Verify workspace structure
echo "[*] Verifying workspace directory..."
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "[-] Workspace directory not found at $WORKSPACE_DIR"
    echo "[-] Clone the repository first:"
    echo "    git clone <repo-url> $WORKSPACE_DIR"
    exit 1
fi

# 3. Create Hermes config directory structure
echo "[*] Creating Hermes config directory..."
mkdir -p "$HERMES_CONFIG_DIR"/profiles/atlas
mkdir -p "$HERMES_CONFIG_DIR"/profiles/aegis
mkdir -p "$HERMES_CONFIG_DIR"/profiles/forge
mkdir -p "$HERMES_CONFIG_DIR"/memory
mkdir -p "$HERMES_CONFIG_DIR"/logs

# 4. Symlink or copy profile configs
echo "[*] Linking profile configurations..."
ln -sf "$WORKSPACE_DIR/profiles/atlas"/* "$HERMES_CONFIG_DIR/profiles/atlas/" 2>/dev/null || true
ln -sf "$WORKSPACE_DIR/profiles/aegis"/* "$HERMES_CONFIG_DIR/profiles/aegis/" 2>/dev/null || true
ln -sf "$WORKSPACE_DIR/profiles/forge"/* "$HERMES_CONFIG_DIR/profiles/forge/" 2>/dev/null || true

# 5. Validate workspace
echo "[*] Running workspace validation..."
if [ -f "$WORKSPACE_DIR/deployment/bootstrap/validate-workspace.sh" ]; then
    bash "$WORKSPACE_DIR/deployment/bootstrap/validate-workspace.sh"
fi

echo "[+] Bootstrap complete."
echo "[*] Next steps:"
echo "    1. Configure .env with your tokens"
echo "    2. Start Hermes: docker compose up -d"
echo "    3. Check logs: docker compose logs -f"
