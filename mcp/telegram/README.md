# MCP: Telegram

## Purpose

Primary communication interface for Hermes Workspace.

## Scope

- Receiving user messages and commands
- Sending responses and status updates
- Approval request and response handling
- File and document sharing
- Notification delivery

## Integration

```
MCP Server: telegram
Transport: HTTP (webhook) or polling
Bot Token: TELEGRAM_BOT_TOKEN (from .env)
Chat ID: TELEGRAM_CHAT_ID (from .env)
```

## Message Format

### User to Hermes
- Natural language commands
- Approval responses (yes/no/confirm)
- Clarification responses

### Hermes to User
- Structured responses with Problem/Analysis/Recommendation/Risk/NextStep
- Approval requests with Plan/Risk/Command/Rollback
- Status updates and summaries
- Error reports with explanation

## Security

- Bot token stored in .env, never hardcoded
- Chat ID whitelist for access control
- No sensitive data in messages
- Approval responses clearly formatted
- Message history not persisted in memory
