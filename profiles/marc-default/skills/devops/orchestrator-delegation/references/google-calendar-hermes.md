# Google Calendar Integration via Hermes

Complete workflow for Google Calendar CRUD operations through Hermes devops-admin profile using Google Workspace OAuth.

## Prerequisites

1. Google Cloud Console OAuth credentials (Desktop app)
2. APIs enabled: Gmail, Calendar, Drive, Docs, Sheets
3. Client secret JSON file downloaded

## Setup Workflow

### Phase 1: OAuth Token Generation

**Location:** Store client_secret and token in devops-admin profile
```bash
/opt/data/google/client_secret_<client-id>.apps.googleusercontent.com.json
/opt/data/profiles/devops-admin/google_token.json
```

**Steps:**

1. **Install dependencies** (first time only):
```bash
cd /opt/data/profiles/devops-admin
uv venv google-venv
uv pip install --python google-venv/bin/python google-api-python-client google-auth-oauthlib google-auth-httplib2
```

2. **Generate authorization URL**:
```bash
cd /opt/data/profiles/devops-admin
google-venv/bin/python skills/productivity/google-workspace/scripts/setup.py --auth-url
```

Returns URL like:
```
https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=...
```

3. **User opens URL in browser**, approves permissions

4. **Browser redirects to** `http://localhost:1/?code=...&scope=...`
   - Page will show error/not load — THIS IS NORMAL
   - User copies ENTIRE URL from address bar

5. **Exchange authorization code for token**:
```bash
cd /opt/data/profiles/devops-admin
google-venv/bin/python skills/productivity/google-workspace/scripts/setup.py --auth-code '<code-from-url>'
```

Token saved to: `/opt/data/profiles/devops-admin/google_token.json`

### Phase 2: Token Structure

```json
{
  "token": "ya29.a0...",
  "refresh_token": "1//0g...",
  "token_uri": "https://oauth2.googleapis.com/token",
  "client_id": "...",
  "client_secret": "...",
  "scopes": [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/calendar",
    "https://www.googleapis.com/auth/drive",
    ...
  ],
  "expiry": "2026-06-23T16:07:53.586827Z"
}
```

**Token refresh:** Automatic via refresh_token when expired

## Calendar Operations

### Create Event

**Python script pattern:**
```python
import json
from datetime import datetime
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

# Load token
with open('/opt/data/profiles/devops-admin/google_token.json') as f:
    token_data = json.load(f)

creds = Credentials(
    token=token_data['token'],
    refresh_token=token_data['refresh_token'],
    token_uri=token_data['token_uri'],
    client_id=token_data['client_id'],
    client_secret=token_data['client_secret'],
    scopes=token_data['scopes']
)

# Refresh if expired
if creds.expired and creds.refresh_token:
    from google.auth.transport.requests import Request
    creds.refresh(Request())
    # Save refreshed token back to file
    token_data['token'] = creds.token
    with open('/opt/data/profiles/devops-admin/google_token.json', 'w') as f:
        json.dump(token_data, f, indent=2)

# Build service
service = build('calendar', 'v3', credentials=creds)

# Create event with WIB timezone
event = {
    'summary': 'Event Title',
    'location': 'Location',
    'description': 'Description',
    'start': {
        'dateTime': '2026-06-26T18:00:00+07:00',  # WIB timezone
        'timeZone': 'Asia/Jakarta',
    },
    'end': {
        'dateTime': '2026-06-26T21:00:00+07:00',
        'timeZone': 'Asia/Jakarta',
    },
    'reminders': {
        'useDefault': False,
        'overrides': [
            {'method': 'popup', 'minutes': 60},
        ],
    },
}

created_event = service.events().insert(calendarId='primary', body=event).execute()
print(f"Event created: {created_event['htmlLink']}")
```

### Update Event

**PATCH method** (only update specified fields):
```python
update_data = {
    'start': {
        'dateTime': '2026-06-27T18:00:00+07:00',  # New date
        'timeZone': 'Asia/Jakarta'
    },
    'end': {
        'dateTime': '2026-06-27T21:00:00+07:00',
        'timeZone': 'Asia/Jakarta'
    },
}

updated_event = service.events().patch(
    calendarId='primary',
    eventId='<event_id>',
    body=update_data
).execute()
```

### Query Events

**List events for specific date range:**
```python
# Query events for specific day
from datetime import datetime, timedelta

# WIB = UTC+7
start_wib = datetime(2026, 6, 28, 0, 0, 0)
end_wib = datetime(2026, 6, 28, 23, 59, 59)

# Convert to UTC for API query
start_utc = start_wib - timedelta(hours=7)
end_utc = end_wib - timedelta(hours=7)

time_min = start_utc.isoformat() + 'Z'
time_max = end_utc.isoformat() + 'Z'

events_result = service.events().list(
    calendarId='primary',
    timeMin=time_min,
    timeMax=time_max,
    singleEvents=True,
    orderBy='startTime'
).execute()

events = events_result.get('items', [])
for event in events:
    start = event['start'].get('dateTime', event['start'].get('date'))
    print(f"{start} - {event['summary']}")
```

## Timezone Handling

**CRITICAL:** Google Calendar stores events with timezone info. Always use explicit timezone in dateTime fields.

**WIB (Asia/Jakarta) = UTC+7**

Event creation:
```python
'start': {
    'dateTime': '2026-06-26T18:00:00+07:00',  # 18:00 WIB
    'timeZone': 'Asia/Jakarta',
}
```

API returns events with timezone preserved:
```json
{
  "start": {
    "dateTime": "2026-06-26T18:00:00+07:00",
    "timeZone": "Asia/Jakarta"
  }
}
```

**Query timezone bug workaround:**

When querying events, parse `dateTime` field directly — it includes offset:
```python
# ✅ CORRECT
dt_str = event['start']['dateTime']  # "2026-06-26T18:00:00+07:00"
dt = datetime.fromisoformat(dt_str)  # Preserves +07:00 offset

# ❌ WRONG — manual UTC conversion loses offset info
dt_utc = datetime.fromisoformat(dt_str.replace('Z', '+00:00'))
dt_wib = dt_utc + timedelta(hours=7)  # Double-counts offset
```

**User-reported issue:** Script showed event at 01:00 WIB instead of 18:00 WIB
**Root cause:** Script parsed timestamp, converted UTC→WIB manually, but timestamp already had +07:00 offset
**Fix:** Trust the offset in dateTime field, don't add 7 hours

## Troubleshooting

### Error 403: access_denied

**Cause:** User's Google account not added as Test User in OAuth consent screen

**Fix:**
1. Go to Google Cloud Console → APIs & Services → OAuth consent screen
2. Add user email to "Test users" section
3. User re-authorizes (repeat Phase 1 steps 3-5)

### Token expired / 401 Unauthorized

**Symptom:** `google.auth.exceptions.RefreshError: invalid_grant`

**Cause:** Token expired, refresh_token invalid or revoked

**Fix:**
1. Delete `/opt/data/profiles/devops-admin/google_token.json`
2. Re-run full OAuth flow (Phase 1)

### Permission denied errors

**Symptom:** Script can't read/write token file

**Fix:**
```bash
chown hermes:hermes /opt/data/profiles/devops-admin/google_token.json
chmod 600 /opt/data/profiles/devops-admin/google_token.json
```

## Delegation Pattern

When orchestrator needs calendar operations, delegate to devops-admin (owns OAuth token):

```python
terminal(command="""
/opt/hermes/bin/hermes -p devops-admin chat -q "
Add event to Google Calendar:
- Title: Meeting with Team
- Date: 2026-06-30
- Time: 14:00-15:00 WIB
- Location: Office
- Description: Sprint planning
Output event ID and confirmation.
"
""", timeout=60)
```

Devops-admin loads token, creates event, returns result to orchestrator.

## Security Notes

- Token file contains refresh_token (long-lived) — treat as secret
- Scopes requested are broad (gmail, calendar, drive) — limit in production
- Test users in OAuth consent allow bypass of Google review for internal apps
- Production deployment: complete OAuth app verification with Google
