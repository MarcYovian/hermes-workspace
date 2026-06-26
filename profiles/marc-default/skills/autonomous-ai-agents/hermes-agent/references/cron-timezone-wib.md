# Cron Job Timezone Handling (WIB/UTC)

## Problem

Hermes cron schedules are always interpreted in **UTC**, not local time. When a user in WIB (UTC+7) timezone asks for a job at "07:00", they mean 07:00 WIB, but a naive `0 7 * * *` schedule runs at 07:00 UTC = 14:00 WIB.

This creates a 7-hour offset that's easy to miss during initial setup.

## Solution

**Always convert WIB time to UTC when creating cron schedules.**

Formula: `UTC_hour = WIB_hour - 7`

### Examples

| User wants (WIB) | Cron expression | Actual run time |
|------------------|-----------------|-----------------|
| 07:00 WIB | `0 0 * * *` | 00:00 UTC = 07:00 WIB ✓ |
| 09:00 WIB | `0 2 * * *` | 02:00 UTC = 09:00 WIB ✓ |
| 14:00 WIB | `0 7 * * *` | 07:00 UTC = 14:00 WIB ✓ |
| 21:00 WIB | `0 14 * * *` | 14:00 UTC = 21:00 WIB ✓ |
| 02:00 WIB | `0 19 * * *` | 19:00 UTC (prev day) = 02:00 WIB ✓ |

### Midnight Wraparound

For hours 00:00-06:59 WIB, subtracting 7 gives a negative number — add 24 and subtract 1 day:

- **01:00 WIB** = `0 18 * * *` (18:00 UTC previous day)
- **06:00 WIB** = `0 23 * * *` (23:00 UTC previous day)

## Verification Pattern

After creating/updating a cron job for WIB users:

1. Check `next_run_at` timestamp in the job details
2. Convert to WIB: `date -d "2026-06-24T00:00:00Z" +"%Y-%m-%d %H:%M %Z" -u` → add 7 hours mentally or use `TZ=Asia/Jakarta date -d ...`
3. Confirm it matches the user's request

## Cross-Profile Cron Edits

The `cronjob` tool only manages jobs in the **current profile**. To edit another profile's cron jobs (e.g., orchestrator editing a specialist's schedule):

1. **Read** the target profile's `cron/jobs.json`:
   ```
   read_file(path="/opt/data/profiles/<profile>/cron/jobs.json")
   ```

2. **Edit** with `cross_profile=True`:
   ```
   patch(
     mode="replace",
     path="/opt/data/profiles/<profile>/cron/jobs.json",
     old_string='...',
     new_string='...',
     cross_profile=true
   )
   ```

3. **Restart the gateway** to reload the schedule:
   ```
   terminal(command="/opt/hermes/bin/hermes -p <profile> gateway restart")
   ```

Without the gateway restart, the old schedule stays in memory until the next gateway restart/crash.

## Real Example (From Session)

User wanted daily server health report at **07:00 WIB**.

**Initial (wrong) setup:**
- Schedule: `0 7 * * *`
- Ran at: 07:00 UTC = **14:00 WIB** (7 hours late)

**Fixed:**
- Schedule: `0 0 * * *`
- Runs at: 00:00 UTC = **07:00 WIB** ✓

```json
{
  "schedule": {
    "kind": "cron",
    "expr": "0 0 * * *",
    "display": "0 0 * * *"
  }
}
```

## Pitfall: Gateway Must Be Running

Cron jobs only fire when the profile's gateway is running. If the gateway is stopped:
- Jobs won't execute
- `next_run_at` won't advance
- No error is logged to the user

Check gateway status before debugging missed cron runs:
```bash
pgrep -af "hermes.*gateway.*<profile-name>"
```
