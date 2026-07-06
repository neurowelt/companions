---
description: List the companion experts available to the caller — the cheap directory.
---

Call the `list_companions` MCP tool. It returns `{companions: [{id, name, kind, visibility, hint}]}` — the cheap directory: names, ids, and a one-line `hint` per companion (no descriptions, no teams).

Present the companions as a flat list, one per line: the `name` followed by its `hint`.

This is for confirming a companion exists, checking spelling, and shortlisting. For full profiles of a shortlist, use `/describe-companions <names>`. For team rosters, use `/list-teams`.

If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup` instead.
