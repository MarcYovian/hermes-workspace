# Executive Summary

Hermes Workspace adalah sebuah AI-agent operating environment berbasis Hermes Agent yang berjalan pada VPS Ubuntu dan terintegrasi dengan Telegram sebagai primary communication channel serta 9Router sebagai model routing layer.

Workspace ini dirancang untuk:

1. Menjadi personal AI operating system untuk development dan infrastructure management.
2. Menggunakan pendekatan specialized-agent architecture dibanding monolithic AI agent.
3. Memiliki strict approval policy untuk seluruh tindakan write/destructive.
4. Menjadikan Git sebagai source of truth utama.
5. Bersifat production-minded, auditable, reproducible, dan extensible untuk roadmap masa depan.

Pada v1, fokus workspace hanya pada:

- orchestration
- coding assistance
- infrastructure management

Trading system, research assistant crypto, QA agents, dan autonomous execution **belum menjadi scope implementasi v1**.
