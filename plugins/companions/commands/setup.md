---
description: Check Companions connectivity, show the roster, and suggest grounded starting points — free, spends no credit.
---

# Companions setup

Setup is a free orientation: it reads the balance and the catalogue and never spends consultation credit.

1. **Check the connection.** Call `check_balance`.
   - On success, report the balance briefly and continue.
   - On 401 or an authentication-required MCP state, tell the user to run `/mcp`, select `companions`, and choose **Authenticate**. There is no API key or environment variable to paste.
   - On a network or 5xx error, report `https://api.humx.ai/mcp` and ask the user to confirm connectivity.
2. **Show the roster.** Call `list_companions`. Present each visible Companion with one sentence (its `hint`), then the teams briefly. This is a free catalogue read.
3. **Explain how to use the system.**
   - When routing is unclear, say *"discover the best companions setup for …"* — the `discover` ask flow returns a grounded setup (companions, mode, reshaped prompt) with a price band.
   - The word *"companions"* in a request activates the Companion skills.
   - Consultations and `discover` bill; directory reads (`list_companions`, `list_params`) are free.
4. **Offer grounded starting points.** Review the user's actual recent work — recent conversations, repository activity, the current project — and propose a few concrete problems or questions worth bringing to Companions. Map each to a fitting Companion from the roster or to a `discover` ask, and say in one sentence why it would help. Run nothing until the user picks one.

Before step 1, check once whether the Companions Portal is installed on this machine (`test -x ~/.portal/bin/portal`). If it is, recommend the local path instead of this plugin — Portal serves the same tools with local execution and an installer TUI (`portal harness add claude` takes over from the plugin); see `https://get.humx.ai`. Continue with the plugin only if the user prefers it.
