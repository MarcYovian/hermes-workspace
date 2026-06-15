#!/usr/bin/env bash
# =============================================================================
# validate-workspace.sh — Workspace structure & configuration validation
# =============================================================================
# Validates that all required workspace artifacts exist and are correctly placed.
# =============================================================================
set -euo pipefail

WORKSPACE_DIR="/apps/repos/hermes-workspace"

echo "[+] Hermes Workspace Validation"
echo "================================"

errors=0
warnings=0

# Validate core directory structure
check_dir() {
    if [ -d "$1" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        errors=$((errors + 1))
    fi
}

check_file() {
    if [ -f "$1" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        errors=$((errors + 1))
    fi
}

# Core files
echo ""
echo "[*] Core files..."
check_file "$WORKSPACE_DIR/PRD.md"
check_file "$WORKSPACE_DIR/ARCHITECTURE.md"
check_file "$WORKSPACE_DIR/CONTRIBUTING.md"
check_file "$WORKSPACE_DIR/ROADMAP.md"

# Profile specs
echo ""
echo "[*] Profile specs..."
check_file "$WORKSPACE_DIR/profiles/specs/default.md"
check_file "$WORKSPACE_DIR/profiles/specs/devops-admin.md"
check_file "$WORKSPACE_DIR/profiles/specs/dev-coder.md"

# Profile artifacts
echo ""
echo "[*] Profile: default..."
for f in profile.yaml SOUL.md SYSTEM_PROMPT.md RULES.md MEMORY_POLICY.md SKILLS.md MCP.md; do
    check_file "$WORKSPACE_DIR/profiles/default/$f"
done
check_file "$WORKSPACE_DIR/profiles/default/prompts/delegation.md"
check_file "$WORKSPACE_DIR/profiles/default/prompts/safety.md"
check_file "$WORKSPACE_DIR/profiles/default/tests/delegation-tests.md"

echo ""
echo "[*] Profile: devops-admin..."
for f in profile.yaml SOUL.md SYSTEM_PROMPT.md RULES.md MEMORY_POLICY.md SKILLS.md MCP.md; do
    check_file "$WORKSPACE_DIR/profiles/devops-admin/$f"
done
check_file "$WORKSPACE_DIR/profiles/devops-admin/prompts/rollback-thinking.md"
check_file "$WORKSPACE_DIR/profiles/devops-admin/prompts/risk-analysis.md"
check_file "$WORKSPACE_DIR/profiles/devops-admin/prompts/infra-safety.md"
check_file "$WORKSPACE_DIR/profiles/devops-admin/tests/docker-health.md"
check_file "$WORKSPACE_DIR/profiles/devops-admin/tests/troubleshooting.md"

echo ""
echo "[*] Profile: dev-coder..."
for f in profile.yaml SOUL.md SYSTEM_PROMPT.md RULES.md MEMORY_POLICY.md SKILLS.md MCP.md; do
    check_file "$WORKSPACE_DIR/profiles/dev-coder/$f"
done
check_file "$WORKSPACE_DIR/profiles/dev-coder/prompts/branch-policy.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/prompts/commit-policy.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/prompts/code-review.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/prompts/safe-refactoring.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/tests/git-workflow.md"
check_file "$WORKSPACE_DIR/profiles/dev-coder/tests/coding-tests.md"

# Shared policies
echo ""
echo "[*] Shared artifacts..."
check_file "$WORKSPACE_DIR/shared/policies/approval-matrix.yaml"
check_file "$WORKSPACE_DIR/shared/policies/filesystem-boundaries.yaml"
check_file "$WORKSPACE_DIR/shared/policies/git-governance.yaml"
check_file "$WORKSPACE_DIR/shared/policies/security-policy.yaml"
check_file "$WORKSPACE_DIR/shared/prompts/approval-request.md"
check_file "$WORKSPACE_DIR/shared/prompts/escalation.md"
check_file "$WORKSPACE_DIR/shared/prompts/troubleshooting.md"
check_file "$WORKSPACE_DIR/shared/context/naming-conventions.md"
check_file "$WORKSPACE_DIR/shared/context/repo-standards.md"
check_file "$WORKSPACE_DIR/shared/context/workspace-conventions.md"
check_file "$WORKSPACE_DIR/shared/guardrails/forbidden-commands.yaml"
check_file "$WORKSPACE_DIR/shared/guardrails/dangerous-patterns.yaml"
check_file "$WORKSPACE_DIR/shared/guardrails/approval-required.yaml"

# MCP stubs
echo ""
echo "[*] MCP integrations..."
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
    echo "[-] Some artifacts are missing. Review the list above."
    exit 1
else
    echo "[+] All required artifacts present."
fi
