# Troubleshooting Prompt — Shared

Structured troubleshooting framework used by all profiles.

---

## Systematic Troubleshooting Flow

### Step 1 — Define the problem
What exactly is failing? What is the expected vs actual behavior?

### Step 2 — Gather evidence
- Read logs first
- Check current state (docker ps, systemctl status, git status, etc.)
- Verify assumptions with command output
- Collect relevant metrics

### Step 3 — Analyze
- Compare current state with expected state
- Identify recent changes that could cause issue
- Look for patterns in logs and errors
- Check dependencies

### Step 4 — Form hypothesis
Based on evidence, what is the most likely root cause?

### Step 5 — Verify hypothesis
Test with read-only commands first. If mutation needed to verify, request approval.

### Step 6 — Fix (with approval)
Minimal safe change. Present plan, risk, rollback. Get approval.

### Step 7 — Validate
Verify fix resolved the issue. Confirm no side effects.

### Step 8 — Document
Log the issue and resolution for future reference.

## Troubleshooting Mindset

- Start with read operations — cheaper, safer, faster
- Prefer inspection over assumption — 99% of issues visible in logs
- Isolate the variable — change one thing at a time
- If stuck, escalate — more eyes, more data
- Never restart blindly — diagnose first
