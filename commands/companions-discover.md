---
description: List the teams and companion experts available to the caller.
---

Call the `discover` MCP tool. Present the result as two short sections:

- **Teams** — for each team, show name and member names on one line.
- **Companions** — flat list, one per line, with the first sentence of each `description`.

If the call returns 401 or the env var is unset, run the same fallback as `/companions-setup` instead.
