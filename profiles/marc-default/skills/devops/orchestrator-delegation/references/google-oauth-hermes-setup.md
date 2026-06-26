# Google OAuth Setup for Hermes Agent

Complete workflow untuk setup Google Workspace integration (Gmail, Calendar, Drive, Docs, Sheets).

## Prerequisites

1. **Google Cloud Console setup:**
   - Create project di https://console.cloud.google.com
   - Enable APIs: Gmail, Calendar, Drive, Docs, Sheets
   - Create OAuth 2.0 Client ID (Desktop app type)
   - Download `client_secret_*.json`

2. **File placement:**
   ```
   /opt/data/google/client_secret_{CLIENT_ID}.apps.googleusercontent.com.json
   ```

## Setup Flow

### Step 1: Install Dependencies

Buat virtual environment untuk Google API libraries:

```bash
cd /opt/data/profiles/{profile}
uv venv google-venv
uv pip install --python google-venv/bin/python \
  google-api-python-client \
  google-auth-oauthlib \
  google-auth-httplib2
```

### Step 2: Generate Authorization URL

Gunakan google-workspace skill's setup script:

```bash
cd /opt/data/profiles/{profile}
google-venv/bin/python skills/productivity/google-workspace/scripts/setup.py --auth-url
```

Output: URL untuk user buka di browser.

### Step 3: User Authorization

1. User buka URL di browser
2. Login dengan Google account
3. Approve permissions yang diminta
4. Browser redirect ke `http://localhost:1/?code=...` (akan error — **ini normal**)
5. User copy **ENTIRE URL** dari address bar

### Step 4: Exchange Code for Token

```bash
cd /opt/data/profiles/{profile}

# Extract code dari URL
CODE="4/0A..."  # dari parameter ?code=...

google-venv/bin/python skills/productivity/google-workspace/scripts/setup.py \
  --auth-code "$CODE"
```

Token tersimpan di: `/opt/data/profiles/{profile}/google_token.json`

### Step 5: Verification (Optional)

Test API call untuk verify token working:

```python
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
import json

with open('google_token.json', 'r') as f:
    token_data = json.load(f)

creds = Credentials.from_authorized_user_info(token_data)

# Test Gmail
gmail = build('gmail', 'v1', credentials=creds)
labels = gmail.users().labels().list(userId='me').execute()
print(f"Gmail: {len(labels.get('labels', []))} labels")

# Test Calendar
calendar = build('calendar', 'v3', credentials=creds)
calendars = calendar.calendarList().list().execute()
print(f"Calendar: {len(calendars.get('items', []))} calendars")
```

## Token Structure

`google_token.json` contains:

```json
{
  "token": "ya29.a0A...",
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
  ]
}
```

## Usage Examples

### Create Calendar Event

```python
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
import json

with open('/opt/data/profiles/{profile}/google_token.json', 'r') as f:
    creds = Credentials.from_authorized_user_info(json.load(f))

service = build('calendar', 'v3', credentials=creds)

event = {
    'summary': 'Meeting Title',
    'location': 'Office',
    'description': 'Description',
    'start': {
        'dateTime': '2026-06-25T18:00:00+07:00',  # WIB timezone
        'timeZone': 'Asia/Jakarta',
    },
    'end': {
        'dateTime': '2026-06-25T21:00:00+07:00',
        'timeZone': 'Asia/Jakarta',
    },
    'reminders': {
        'useDefault': False,
        'overrides': [
            {'method': 'popup', 'minutes': 60},
        ],
    },
}

created = service.events().insert(calendarId='primary', body=event).execute()
print(f"Event created: {created['htmlLink']}")
```

### Query Calendar Events

```python
from datetime import datetime, timedelta

# Get events for a specific day
start = datetime(2026, 6, 28, 0, 0, 0) - timedelta(hours=7)  # WIB to UTC
end = datetime(2026, 6, 28, 23, 59, 59) - timedelta(hours=7)

events = service.events().list(
    calendarId='primary',
    timeMin=start.isoformat() + 'Z',
    timeMax=end.isoformat() + 'Z',
    singleEvents=True,
    orderBy='startTime'
).execute()

for event in events.get('items', []):
    print(event['summary'], event['start'].get('dateTime'))
```

## Troubleshooting

### Error 403: access_denied

**Cause:** Google account tidak listed sebagai Test User untuk OAuth app.

**Fix:**
1. Buka https://console.cloud.google.com/apis/credentials/consent
2. Tambahkan email user ke "Test users" section
3. Retry authorization flow

### Token expired

Token auto-refresh jika `refresh_token` tersedia:

```python
from google.auth.transport.requests import Request

if creds.expired and creds.refresh_token:
    creds.refresh(Request())
    # Save refreshed token
    with open('google_token.json', 'w') as f:
        json.dump({
            'token': creds.token,
            'refresh_token': creds.refresh_token,
            'token_uri': creds.token_uri,
            'client_id': creds.client_id,
            'client_secret': creds.client_secret,
            'scopes': creds.scopes
        }, f)
```

### Redirect URI mismatch

Pastikan redirect URI di Google Cloud Console match dengan yang ada di setup script:

```
http://localhost:1
```

## Permissions Scopes

Standard scopes yang dibutuhkan:

- `gmail.readonly` — Read Gmail messages
- `gmail.send` — Send emails
- `gmail.modify` — Modify labels
- `calendar` — Full Calendar access
- `drive` — Full Drive access
- `contacts.readonly` — Read contacts
- `spreadsheets` — Full Sheets access
- `documents` — Full Docs access

## Security Notes

- Token file contains sensitive credentials — `chmod 600` dan jangan commit ke git
- Refresh token hanya issued sekali saat first authorization dengan `access_type=offline`
- Jika refresh token hilang, user harus re-authorize via browser flow
- Token bisa di-revoke dari https://myaccount.google.com/permissions

## Real Session Example

**Setup successful for:**
- Profile: devops-admin (Aegis)
- Client ID: 1028660412460-q8ksapvm42f7bv939hlh7f3kd2hjv4nr
- Token location: `/opt/data/profiles/devops-admin/google_token.json`
- Verified working: Calendar create event, Calendar query events
- Use case: User request "tambahkan ke calendar" → Aegis creates event → confirm with event link
