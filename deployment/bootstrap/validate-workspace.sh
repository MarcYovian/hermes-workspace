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
echo "[*] Profile: default (Hermes-native)..."
check_file "$WORKSPACE_DIR/profiles/default/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/default/config.yaml"
check_file "$WORKSPACE_DIR/profiles/default/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/default/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/default/skills"

echo ""
echo "[*] Profile: devops-admin (Hermes-native)..."
check_file "$WORKSPACE_DIR/profiles/devops-admin/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/devops-admin/config.yaml"
check_file "$WORKSPACE_DIR/profiles/devops-admin/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/devops-admin/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/devops-admin/skills"

echo ""
echo "[*] Profile: dev-coder (Hermes-native)..."
check_file "$WORKSPACE_DIR/profiles/dev-coder/distribution.yaml"
check_file "$WORKSPACE_DIR/profiles/dev-coder/config.yaml"
check_file "$WORKSPACE_DIR/profiles/dev-coder/SOUL.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/mcp.json"
check_dir "$WORKSPACE_DIR/profiles/dev-coder/skills"

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
