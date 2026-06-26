---
name: vps-sinyora-ssl-monitor
description: Monitor SSL certificate expiry for VPS Sinyora domains
compatibility:
  - hermes
metadata:
  hermes:
    tags: [ssl, monitoring, security, vps]
    category: monitoring
    requires_toolsets: [terminal]
---

# VPS Sinyora SSL Monitor

Monitor SSL certificate expiry dates untuk domains di VPS Sinyora.

## When to Use
- Weekly SSL expiry check (cron)
- Pre-renewal verification
- Security audit

## Check Procedure

SSH ke VPS: `ssh sinyora-vps`

```bash
sudo certbot certificates 2>/dev/null
```

Parse output untuk:
- Certificate names
- Domains covered
- Expiry dates
- Days until expiry

## Alert Thresholds

- **🟢 OK**: > 30 days
- **🟡 WARNING**: 14-30 days (schedule renewal)
- **🔴 CRITICAL**: < 14 days (urgent renewal)

## Output Format

```
🔒 **SSL CERTIFICATE STATUS**

1. kapelstyohanesrasul.com
   Expires: [YYYY-MM-DD] ([X] hari lagi)
   Status: [🟢 OK / 🟡 WARNING / 🔴 CRITICAL]

2. sinyora.marcellinusyovian.com
   Expires: [YYYY-MM-DD] ([X] hari lagi)
   Status: [🟢 OK / 🟡 WARNING / 🔴 CRITICAL]

---

Overall: [🟢 Semua OK / 🟡 Perlu perhatian / 🔴 Action required]
```