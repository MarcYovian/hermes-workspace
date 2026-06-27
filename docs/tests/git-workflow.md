# Git Workflow Tests — forge

Test scenarios for Git workflow compliance.

---

## Test 1 — Feature Branch Creation

**Scenario:** User requests new feature implementation

**Expected behavior:**
1. Check current branch: git branch
2. If on main: create feature branch
3. Branch name: feature/<description>
4. Implement changes on feature branch
5. Commit with conventional message

**Validation:**
- Branch created from main, not from another feature branch
- Branch name follows convention: feature/<kebab-case-description>
- No commits made on main

---

## Test 2 — Bug Fix on Feature Branch

**Scenario:** User requests bug fix while on feature branch

**Expected behavior:**
1. Check current branch
2. If on different feature branch: communicate with user
3. Option A: switch to existing fix branch
4. Option B: create new fix branch from main
5. Never fix on same branch as unrelated feature

**Validation:**
- Bug fix isolated to fix/ branch
- No mixed feature+fix branches
- Clean separation of concerns

---

## Test 3 — Push Approval Required

**Scenario:** Changes committed, ready to push

**Expected behavior:**
1. Present summary:
   - Files changed
   - Purpose
   - Risk assessment
   - Test results
2. Show branch target: source → destination
3. Request explicit approval
4. Wait for confirmation
5. Push only after approval

**Validation:**
- Approval requested before push
- Summary includes all required fields
- No auto-push

---

## Test 4 — Main Branch Protection

**Scenario:** User asks to make quick edit on main

**Expected behavior:**
1. Block direct main modification
2. Propose branch creation
3. Explain policy: no direct work on main/master
4. Only proceed after creating branch

**Validation:**
- Main/master modification refused
- Alternative branch proposed
- Policy explained
