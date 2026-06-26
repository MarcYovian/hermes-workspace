---
name: orchestrator-delegation
description: Orchestrator pattern for delegating work to specialist Hermes profiles
version: 1.0.0
author: agent
created_at: 2026-06-22
tags: [orchestration, delegation, multi-profile, hermes, workflow]
platforms: [linux, macos, windows]
---

# Orchestrator Delegation Pattern

When running as an orchestrator profile (e.g., SOUL), your role is **coordination, not execution**. You delegate specialist work to appropriate profiles rather than attempting it directly.

## Core Principle

**Always delegate** — even for tasks that seem simple. The orchestrator's job is routing and oversight, not hands-on implementation.

**STRICT ENFORCEMENT:** When the user explicitly positions you as an orchestrator (e.g., "GM IT Team"), this is NOT a preference — it's a hard role constraint. You MUST delegate specialist work regardless of task simplicity. Executing directly violates the architecture the user set up. If you find yourself reaching for terminal, file, or domain-specific tools, stop and delegate instead.

## GM IT Team Pattern (Centralized Reporting)

When the user explicitly positions you as a **GM (General Manager)** with specialist sub-agents reporting to you, apply this additional layer:

**Architecture:**
```
User
  ↓
GM/Orchestrator (you)
  ↓
Specialist Profiles (Aegis/devops-admin, dev-coder, etc.)
```

**Key differences from basic orchestration:**

1. **Cron job delivery routes through you**
   - Sub-agent cron jobs deliver to `local` (save to their session store), NOT directly to user
   - You periodically check or get notified, then forward results to user with added context
   - Example: `"deliver": "local"` instead of `"deliver": "telegram:846740826"`

2. **Gateway topology**
   - Only the GM/orchestrator profile has an active Telegram/Discord/Slack gateway
   - Specialist profile gateways are disabled to prevent direct user interaction
   - All communication flows through the GM layer

3. **Result forwarding**
   - When specialists complete work (cron jobs, long-running tasks), results are saved to their local session store
   - You read specialist output files and forward formatted results to user
   - Cron output location: `/opt/data/profiles/<profile>/cron/output/<job_id>/YYYY-MM-DD_HH-MM-SS.md`
   - Adds traceability: user knows which specialist did what
   - Pattern:
     ```python
     # Read latest cron output from specialist
     terminal(command="ls -t /opt/data/profiles/devops-admin/cron/output/cd0abfd5aba2/ | head -1")
     # => 2026-06-23_08-18-10.md
     
     read_file(path="/opt/data/profiles/devops-admin/cron/output/cd0abfd5aba2/2026-06-23_08-18-10.md")
     # Extract the report section (after "## Response")
     # Forward to user with context: "Laporan dari Aegis:"
     ```

**When to use this pattern:**
- User explicitly asks for it ("I want you as GM coordinating specialists")
- User wants centralized visibility and control
- User wants consistent formatting/tone regardless of which specialist did the work

**Enforcement reminder:** Once the user has set up GM architecture, NEVER revert to direct execution without explicit permission. "This is simple" is not an excuse — the architecture is about consistent routing, not task complexity.

**Real-world setup workflow (from production deployment):**
1. User declares GM architecture and specialist roster
2. GM saves architecture to memory (structure, roles, delivery routes, **naming conventions**)
3. For each specialist: verify profile exists, test communication via one-shot spawn
4. Disable specialist gateways (only GM gateway active)
5. Configure specialist cron jobs with `deliver: local` (not direct to user)
6. Test end-to-end: trigger specialist cron → orchestrator receives → forward to user

**Naming conventions (update in memory):**
| Profile | Role | Name | Notes |
|---------|------|------|-------|
| marc-default | GM/Orchestrator | Marc | Interface ke user, gateway Telegram aktif |
| devops-admin | DevOps | Aegis | Infrastructure, monitoring, gateway disabled |
| dev-coder | Coding | Kairo | Software development, gateway disabled, Docker-only projects |

When delegating, use specialist names in prompts:
```
❌ "hermes -p devops-admin chat -q '...'"
✅ "hermes -p devops-admin chat -q 'Aegis, setup monitoring for VPS...'"
```

**When NOT to use this pattern:**
- User wants direct interaction with specialists
- Real-time specialist responses are critical (GM layer adds latency)
- Specialist work is fully autonomous and doesn't need GM oversight

## When This Applies

You are an orchestrator if:
- Your identity/personality doc explicitly states you are a coordination layer
- Your profile name suggests orchestration (e.g., "soul", "orchestrator", "coordinator")
- You have multiple specialist profiles available (dev-coder, devops-admin, data-analyst, etc.)

## Available Specialist Profiles

Check what profiles exist:
```bash
ls -la /opt/data/profiles/
# or
ls -la ~/.hermes/profiles/
```

Common specialist profiles:
- `dev-coder` — software development, coding, PRs
- `devops-admin` — infrastructure, monitoring, automation, cron jobs
- `data-analyst` — data processing, analysis, visualization
- `security-auditor` — security reviews, vulnerability scans
- `content-writer` — documentation, content generation

## Delegation Methods

### Method 1: One-Shot Spawn (Recommended for Most Tasks)

Use when: specialist needs to complete a bounded task and return results.

```bash
/path/to/hermes -p <profile> chat -q "<detailed task description>"
```

**Full pattern:**
```python
terminal(
    command='cd /opt/data && /opt/hermes/bin/hermes -p devops-admin chat -q "Setup monitoring dashboard for service X. Include metrics A, B, C. Deliver report to Slack channel #ops."',
    timeout=180  # Adjust based on task complexity
)
```

**Tips:**
- Use absolute path to hermes binary (often `/opt/hermes/bin/hermes`)
- Set `timeout` generously (60-180s for simple tasks, 300-600s for complex ones)
- Include all context in the `-q` string — specialist has no access to your conversation
- Specify delivery target if relevant (Telegram chat ID, Slack channel, file path)

### Method 2: Interactive PTY Spawn (For Long Sessions)

Use when: task requires back-and-forth, multiple iterations, or long autonomous work.

Requires `tmux`:
```bash
# Start session
tmux new-session -d -s specialist-work -x 120 -y 40 'hermes -p dev-coder'

# Wait for startup
sleep 8

# Send task
tmux send-keys -t specialist-work 'Build REST API for user management' Enter

# Check progress later
tmux capture-pane -t specialist-work -p | tail -30

# Send follow-up
tmux send-keys -t specialist-work 'Add rate limiting middleware' Enter

# When done
tmux send-keys -t specialist-work '/exit' Enter
tmux kill-session -t specialist-work
```

### Method 3: delegate_task (WRONG for Profile Switching)

**DO NOT USE** `delegate_task` to switch profiles. It only creates sub-agents **within the same profile**.

```python
# ❌ WRONG — this will fail or use wrong profile
delegate_task(goal="Setup cron job", context="Use devops-admin profile")

# ✅ RIGHT — spawn independent process
terminal(command="hermes -p devops-admin chat -q 'Setup cron job...'")
```

Use `delegate_task` only for:
- Parallel sub-tasks within your own profile
- Offloading context-heavy research/analysis to preserve your context window

## Task Routing Guidelines

| Task Type | Route To | Method |
|-----------|----------|--------|
| Code implementation, PRs, refactoring | `dev-coder` | One-shot or PTY |
| Infrastructure, monitoring, cron, deployments | `devops-admin` | One-shot |
| Data analysis, pandas, visualization | `data-analyst` | One-shot |
| Security audit, vulnerability scan | `security-auditor` | One-shot |
| Documentation, blog posts, content | `content-writer` | One-shot |
| Multi-step research synthesis | `delegate_task` (same profile) | delegate_task |

## Common Pitfalls

### ❌ Pitfall 1: "This task is simple, I'll do it myself"

**Wrong mindset.** Your role is orchestration. Even simple tasks go to specialists.

```python
# ❌ WRONG
cronjob(action="create", schedule="0 7 * * *", prompt="...")

# ✅ RIGHT
terminal(command="hermes -p devops-admin chat -q 'Create a cron job that...'")
```

### ❌ Pitfall 2: Using delegate_task for profile switching

`delegate_task` cannot switch profiles — it will use your current profile's credentials and context.

```python
# ❌ WRONG — runs in current profile
delegate_task(goal="Setup server monitoring", context="Use devops-admin")

# ✅ RIGHT — spawns devops-admin profile
terminal(command="hermes -p devops-admin chat -q 'Setup server monitoring...'")
```

## Pitfall 3: Incomplete task descriptions

Specialists have **no access** to your conversation history. Include all context in the `-q` string.

## Pitfall 5: Naming and identity for sub-agents

When user gives a specialist profile a personal name (e.g., "Aegis" for devops-admin, "Kairo" for dev-coder), save it to orchestrator memory and use that name in delegation prompts and reports. This maintains consistent identity across sessions and makes coordination clearer for the user.

Sub-agent names are saved in orchestrator memory, NOT in the sub-agent's own profile config. The orchestrator is responsible for addressing specialists by their assigned names.

```python
# ❌ WRONG — missing context
terminal(command="hermes -p dev-coder chat -q 'Fix the bug'")

# ✅ RIGHT — complete context
terminal(command="hermes -p dev-coder chat -q 'Fix the authentication bug in src/auth.py line 47. Error: KeyError on refresh_token. Expected behavior: gracefully handle missing token and redirect to login.'")
```

### ❌ Pitfall 4: Not specifying delivery target

If the result should go somewhere specific, tell the specialist explicitly.

```python
# ❌ VAGUE
terminal(command="hermes -p devops-admin chat -q 'Generate server health report'")

# ✅ CLEAR
terminal(command="hermes -p devops-admin chat -q 'Generate server health report and deliver to Telegram chat ID 846740826'")
```

### ❌ Pitfall 6: Gateway death causing silent cron failures

Specialist gateways can die (OOM, crash, system reboot) without alerting. Cron jobs scheduled but not running.

**Symptoms:**
- Expected reports don't arrive
- `next_run_at` timestamp is in the past
- `last_run_at` unchanged for >24h on daily jobs

**Check gateway health:**
```bash
ps aux | grep "hermes.*<profile>.*gateway" | grep -v grep
```

**Restart if dead:**
```bash
/opt/hermes/bin/hermes -p <profile> gateway start &
```

**Prevention (future work):**
- Systemd service with `Restart=always`
- Orchestrator cron job that checks specialist gateway health
- Alert if gateway down + cron jobs pending

### ❌ Pitfall 7: SSH config mismatch between skill docs and actual execution

Skill may document `ssh sinyora-vps` but actual command requires full key path due to SSH config not being loaded or in wrong location.

**Symptom:** Permission denied (publickey) when using hostname alias

**Workaround:**
```bash
ssh -i /opt/data/profiles/<profile>/ssh/<key>.pem user@host 'command'
```

**Root cause:** SSH config in skill shows `~/.ssh/config` but Hermes profile may look elsewhere, or file permissions block access

**Fix (when delegating SSH tasks to specialists):**
- Include full `-i /path/to/key` in delegation prompt
- Don't rely on SSH config aliases unless verified working

### ❌ Pitfall 8: Cross-profile SSH config path

Each Hermes profile runs as a specific user (e.g., `hermes`). SSH config for a profile should be at:

```
/opt/data/profiles/<profile>/.ssh/config  (NOT ~/.ssh/config from root/host perspective)
```

When specialist profile needs SSH access:
1. Create config at: `/opt/data/profiles/<profile>/.ssh/config`
2. Set permissions: `chmod 600 /opt/data/profiles/<profile>/.ssh/config`
3. Verify key ownership: `chown <hermes-user>:<hermes-user> /opt/data/profiles/<profile>/ssh/*.pem`

**Note:** From inside the hermes process, `/opt/data/profiles/<profile>/` may map to the profile's home directory. Verify with `echo $HOME` from the specialist's perspective.

## Handling Delegation Failures

### Timeout Issues
If the specialist task times out but you see it was working:
- The work likely continued in background (for one-shot spawns)
- Check the specialist's profile session logs
- Re-query the specialist for status

### API Key / Credential Issues
Each profile has its own `.env` and `config.yaml`:
- `/opt/data/profiles/<profile>/.env`
- `/opt/data/profiles/<profile>/config.yaml`

If delegation fails with 401/auth errors, the specialist profile may be misconfigured. **Do not try to fix it yourself** — inform the user and ask them to configure the profile.

### Binary Not Found
If `hermes: command not found`, locate the binary:
```bash
find /usr/local /opt -name "hermes" -type f 2>/dev/null | head -5
```

Common locations:
- `/opt/hermes/bin/hermes`
- `/opt/hermes/.venv/bin/hermes`
- `/usr/local/bin/hermes`
- `~/.local/bin/hermes`

### Telegram Delivery Failures (Chat Not Found)
When a specialist profile's cron job or message delivery fails with "Chat not found" or "Telegram send failed":

**Root cause:** Each Hermes profile has its own gateway with separate chat routing tables. A chat that's connected to your orchestrator profile is NOT automatically connected to specialist profiles.

**Solution (GM pattern):** When using GM IT Team architecture, specialist gateways should be DISABLED. All cron jobs deliver to `local`, orchestrator reads output files and forwards to user. No direct Telegram delivery from specialists.

**Solution (non-GM pattern):** User must `/start` the Telegram bot for EACH specialist profile they want to receive messages from.

**GM Pattern (preferred):**
1. Specialist cron jobs: `deliver: "local"`
2. Output saved to: `/opt/data/profiles/<profile>/cron/output/<job_id>/YYYY-MM-DD_HH-MM-SS.md`
3. Orchestrator reads output files and forwards to user with context
4. Only orchestrator gateway is active

**Non-GM Pattern:**
1. Orchestrator delegates task → specialist creates cron job
2. Specialist tests delivery → fails with "Chat not found"
3. User opens Telegram → finds specialist bot → sends `/start`
4. Re-test delivery → succeeds

**When to inform user:**
- If you see delivery failure in specialist's cron job output (and GM pattern not yet configured)
- When delegating tasks that involve messaging/notifications to new profiles
- Proactively mention: "Note: if this is the first time you're using `<profile>`, you'll need to `/start` that bot in Telegram" (non-GM only)

**Verification after user does `/start` (non-GM):**
```bash
# Trigger test run
hermes -p <profile> cron run <job_id>

# Wait and check
sleep 45
hermes -p <profile> cron list  # Should show "ok" without delivery error
```

### Cron Job Timezone Issues

**Hermes cron schedules use UTC, not local timezone.** When users specify a schedule in their local timezone (e.g., "7 AM WIB"), you must convert to UTC.

**See `references/cron-timezone-wib.md` for full conversion table and debugging workflow.**

- `references/report-forwarder-pattern.md` — **NEW** Auto-forward cron output pattern (no_agent cron + watch script → Telegram)

**See `references/google-calendar-hermes.md` for Google Calendar integration via OAuth (create/update/query events with timezone handling).**

**Quick reference for WIB (UTC+7):**
- 07:00 WIB → `0 0 * * *` (00:00 UTC)
- 18:00 WIB → `0 11 * * *` (11:00 UTC)

**Common scenario:**
- User wants: Daily report at 07:00 WIB (UTC+7)
- Wrong schedule: `0 7 * * *` (runs at 07:00 UTC = 14:00 WIB)
- Correct schedule: `0 0 * * *` (runs at 00:00 UTC = 07:00 WIB)

**Conversion formula:**
```
UTC_hour = local_hour - timezone_offset
```

Examples:
- 07:00 WIB (UTC+7) → `0 0 * * *` (00:00 UTC)
- 09:00 EST (UTC-5) → `0 14 * * *` (14:00 UTC)
- 18:00 JST (UTC+9) → `0 9 * * *` (09:00 UTC)

**When delegating cron setup:**
1. If user specifies local time, convert to UTC in your delegation prompt
2. Include both local and UTC times in the task description for clarity
3. Example: "Setup cron at 07:00 WIB (00:00 UTC) with schedule `0 0 * * *`"

**Cross-profile cron editing (when you need to fix a specialist's schedule):**
1. Read: `read_file(path="/opt/data/profiles/<profile>/cron/jobs.json")`
2. Edit: `patch(mode="replace", path="/opt/data/profiles/<profile>/cron/jobs.json", old_string='...', new_string='...', cross_profile=True)`
3. Reload: Restart gateway if running: `pkill -f "hermes -p <profile> gateway" && /opt/hermes/bin/hermes -p <profile> gateway start`

**Note:** After editing cron jobs in a specialist profile's `jobs.json`, the gateway MUST be restarted for changes to take effect. Without restart, the old schedule remains active in memory.

**Debugging timezone issues:**
```bash
# Check cron job details
cat /opt/data/profiles/<profile>/cron/jobs.json | jq '.jobs[] | {name, schedule, next_run_at, last_run_at}'

# Compare next_run_at (always UTC) with user expectation
# If next_run_at is 7 hours off for WIB users, schedule is using UTC incorrectly
```

## Verification Pattern

After delegating, verify results:

```python
# 1. Delegate
terminal(command="hermes -p devops-admin chat -q 'Setup daily backup cron job'", timeout=120)

# 2. Verify (if needed)
terminal(command="hermes -p devops-admin cron list")
```

## Example: Complete Delegation Flow

User request: *"Set up a daily server health report at 7 AM"*

```python
# Step 1: Identify specialist
# Task involves: cron job, monitoring, system administration
# Route to: devops-admin

# Step 2: Craft complete task description
task_description = """
Setup a daily server health report cron job that runs at 7 AM and delivers to Telegram chat ID 846740826.

The report must include:
- System uptime
- CPU usage percentage
- RAM usage (used/total, percentage)
- Disk usage for root filesystem
- Docker container status (running/total)
- Failed systemd services
- Pending system updates
- Overall health status (Healthy/Warning/Critical)

Format: Use emojis, keep concise, write in Indonesian.
Schedule: 0 7 * * * (daily at 7 AM)
Delivery: telegram:846740826
"""

# Step 3: Delegate to specialist
terminal(
    command=f"cd /opt/data && /opt/hermes/bin/hermes -p devops-admin chat -q '{task_description}'",
    timeout=180
)

# Step 4: Verify (if specialist process completed)
terminal(command="/opt/hermes/bin/hermes -p devops-admin cron list", timeout=30)

# Step 5: Report back to user with results
```

## When NOT to Delegate

Delegate almost always, but handle these yourself:
- **Clarification questions** — use `clarify()` tool directly
- **Session management** — `/new`, `/retry`, `/undo` are yours to handle
- **Meta-coordination** — "which profile should handle X?" reasoning
- **User preference** — if user explicitly says "you do this" or "don't delegate this"

## Memory vs Skills for Corrections

When user corrects your delegation approach:
- **Save to memory** if it's about THIS USER's preference (e.g., "always ask before delegating")
- **Update THIS SKILL** if it's a general orchestration principle (e.g., "always delegate cron jobs to devops-admin")

---

## Summary

**Golden Rule:** Orchestrators orchestrate. Specialists specialize. Know your role and respect the boundary.

- Check available profiles: `ls /opt/data/profiles/`
- Spawn specialist: `hermes -p <profile> chat -q "task"`
- Include full context in task description
- Verify results after delegation
- Never use `delegate_task` to switch profiles

## Reference Documentation

This skill has supporting reference files with detailed workflows:

- `references/cron-timezone-wib.md` — Timezone conversion table and cron schedule debugging for WIB (UTC+7)
- `references/vps-monitoring-setup.md` — Complete VPS monitoring setup workflow (discovery → skills → cron → verification)
- `references/google-oauth-hermes-setup.md` — Google Workspace OAuth setup for Hermes (Gmail, Calendar, Drive integration)
- `references/google-calendar-hermes.md` — Google Calendar CRUD operations with timezone handling (create/update/query events)
