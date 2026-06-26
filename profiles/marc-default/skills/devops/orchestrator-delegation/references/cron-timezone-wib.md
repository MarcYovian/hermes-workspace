# Cron Timezone Conversion Reference (WIB/UTC)

Hermes cron schedules use **UTC**, not local timezone. When users specify times in WIB (UTC+7) or other timezones, convert before creating the cron expression.

## Conversion Formula

```
UTC_hour = local_hour - timezone_offset
```

For WIB (UTC+7):
```
UTC_hour = WIB_hour - 7
```

## WIB to UTC Conversion Table

| WIB Time | UTC Time | Cron Expression |
|----------|----------|-----------------|
| 00:00 | 17:00 (previous day) | `0 17 * * *` |
| 01:00 | 18:00 (previous day) | `0 18 * * *` |
| 02:00 | 19:00 (previous day) | `0 19 * * *` |
| 03:00 | 20:00 (previous day) | `0 20 * * *` |
| 04:00 | 21:00 (previous day) | `0 21 * * *` |
| 05:00 | 22:00 (previous day) | `0 22 * * *` |
| 06:00 | 23:00 (previous day) | `0 23 * * *` |
| **07:00** | **00:00** | **`0 0 * * *`** |
| 08:00 | 01:00 | `0 1 * * *` |
| 09:00 | 02:00 | `0 2 * * *` |
| 10:00 | 03:00 | `0 3 * * *` |
| 11:00 | 04:00 | `0 4 * * *` |
| 12:00 | 05:00 | `0 5 * * *` |
| 13:00 | 06:00 | `0 6 * * *` |
| 14:00 | 07:00 | `0 7 * * *` |
| 15:00 | 08:00 | `0 8 * * *` |
| 16:00 | 09:00 | `0 9 * * *` |
| 17:00 | 10:00 | `0 10 * * *` |
| **18:00** | **11:00** | **`0 11 * * *`** |
| 19:00 | 12:00 | `0 12 * * *` |
| 20:00 | 13:00 | `0 13 * * *` |
| 21:00 | 14:00 | `0 14 * * *` |
| 22:00 | 15:00 | `0 15 * * *` |
| 23:00 | 16:00 | `0 16 * * *` |

## Common Mistakes

### ❌ Wrong: Using WIB hour directly
```json
{
  "schedule": "0 7 * * *"  // Runs at 07:00 UTC = 14:00 WIB (7 hours late!)
}
```

### ✅ Right: Convert to UTC first
```json
{
  "schedule": "0 0 * * *"  // Runs at 00:00 UTC = 07:00 WIB
}
```

## Debugging Timezone Issues

When a cron job runs at the wrong time:

1. **Check next_run_at in jobs.json:**
   ```bash
   cat /opt/data/profiles/<profile>/cron/jobs.json | jq '.jobs[] | {name, schedule, next_run_at}'
   ```
   
2. **Compare with user expectation:**
   - `next_run_at` is always in UTC
   - If it's 7 hours off from what user expects (for WIB), schedule needs fixing

3. **Fix the schedule:**
   ```bash
   # Edit jobs.json with correct UTC time
   patch(path="/opt/data/profiles/<profile>/cron/jobs.json", 
         old_string='"expr": "0 7 * * *"',
         new_string='"expr": "0 0 * * *"',
         cross_profile=True)
   
   # Restart gateway to reload config
   pkill -f "hermes -p <profile> gateway"
   /opt/hermes/bin/hermes -p <profile> gateway start
   ```

## Cross-Profile Cron Editing Pattern

When you need to fix a cron job in a specialist profile:

```python
# 1. Read current config
read_file(path="/opt/data/profiles/devops-admin/cron/jobs.json")

# 2. Patch the schedule (both expr and display fields)
patch(
    mode="replace",
    path="/opt/data/profiles/devops-admin/cron/jobs.json",
    old_string='''      "schedule": {
        "kind": "cron",
        "expr": "0 7 * * *",
        "display": "0 7 * * *"
      },
      "schedule_display": "0 7 * * *",''',
    new_string='''      "schedule": {
        "kind": "cron",
        "expr": "0 0 * * *",
        "display": "0 0 * * *"
      },
      "schedule_display": "0 0 * * *",''',
    cross_profile=True
)

# 3. Restart gateway to reload (if running)
terminal(command="pkill -f 'hermes -p devops-admin gateway' && sleep 2 && /opt/hermes/bin/hermes -p devops-admin gateway start")

# 4. Verify next_run_at updated
read_file(path="/opt/data/profiles/devops-admin/cron/jobs.json")
```

## When Delegating Cron Setup

Always specify BOTH local time (for user clarity) AND UTC schedule (for correctness):

```python
task = """
Setup daily server health report cron job.

Schedule: 07:00 WIB (00:00 UTC)
Cron expression: 0 0 * * *

Important: Use the UTC schedule '0 0 * * *' in the cron configuration.
"""

terminal(command=f"hermes -p devops-admin chat -q '{task}'")
```

## Other Timezones

Apply the same formula for other timezones:

- **JST (UTC+9)**: `UTC_hour = JST_hour - 9`
- **EST (UTC-5)**: `UTC_hour = EST_hour + 5`
- **PST (UTC-8)**: `UTC_hour = PST_hour + 8`
- **CET (UTC+1)**: `UTC_hour = CET_hour - 1`

Example: 09:00 JST → 00:00 UTC → `0 0 * * *`
