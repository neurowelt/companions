---
description: Show remaining Companions API credit.
---

Call the `check_balance` MCP tool and print the balance verbatim — one line, no commentary.

If the call returns 401 or the env var is unset, run the same fallback as `/companions-setup` instead.
