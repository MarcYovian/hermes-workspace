#!/usr/bin/env bash
# =============================================================================
# validate-workspace.sh — Hermes-native workspace validation
# =============================================================================
# Validates Hermes-native profile distribution structure.
# =============================================================================
set -euo pipefail

WORKSPACE_DIR="/apps/repos/hermes-workspace"

echo "[+] Hermes Workspace Validation"
echo "================================"

errors=0

check_file() {
    if [ -f "$1" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        errors=$((errors + 1))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        errors=$((errors + 1))
    fi
}

echo ""
echo "[*] Core files..."
check_file "$WORKSPACE_DIR/distribution.yaml"
check_file "$WORKSPACE_DIR/PRD.md"
check_file "$WORKSPACE_DIR/ARCHITECTURE.md"
check_file "$WORKSPACE_DIR/CONTRIBUTING.md"
check_file "$WORKSPACE_DIR/ROADMAP.md"

echo ""
echo "[*] Profile: atlas (orchestrator)..."
check_file "$WORKSPACE_DIR/profiles/atlas/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/atlas/config.yaml"
check_file "$WORKSPACE_DIR/profiles/atlas/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/atlas/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/atlas/skills"

echo ""
echo "[*] Profile: aegis (DevOps Admin)..."
check_file "$WORKSPACE_DIR/profiles/aegis/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/aegis/config.yaml"
check_file "$WORKSPACE_DIR/profiles/aegis/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/aegis/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/aegis/skills"

echo ""
echo "[*] Profile: forge (Software Engineer)..."
check_file "$WORKSPACE_DIR/profiles/forge/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/forge/config.yaml"
check_file "$WORKSPACE_DIR/profiles/forge/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/forge/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/forge/skills"

echo ""
echo "[*] Documentation layer..."
check_dir "$WORKSPACE_DIR/docs/profile-specs"
check_dir "$WORKSPACE_DIR/docs/memory-policies"
check_dir "$WORKSPACE_DIR/docs/policies"
check_dir "$WORKSPACE_DIR/docs/guardrails"
check_dir "$WORKSPACE_DIR/docs/context"
check_dir "$WORKSPACE_DIR/docs/prompts"
check_dir "$WORKSPACE_DIR/docs/tests"
check_dir "$WORKSPACE_DIR/docs/architecture"

echo ""
echo "[*] Deployment..."
check_dir "$WORKSPACE_DIR/deployment/bootstrap"
check_dir "$WORKSPACE_DIR/deployment/docker"

echo ""
echo "[*] MCP integration stubs..."
check_dir "$WORKSPACE_DIR/mcp/docker"
check_dir "$WORKSPACE_DIR/mcp/filesystem"
check_dir "$WORKSPACE_DIR/mcp/git"
check_dir "$WORKSPACE_DIR/mcp/terminal"
check_dir "$WORKSPACE_DIR/mcp/telegram"

echo ""
echo "================================"
echo "Validation complete."
echo "  Errors: $errors"
echo ""

if [ "$errors" -gt 0 ]; then
    echo "[-] Some artifacts are missing."
    exit 1
else
    echo "[+] All Hermes-native artifacts present."
fi
