---
description: List the teams and their member rosters available to the caller.
---

Call the `list_teams` MCP tool. It returns `{teams: [{id, name, visibility, members: [{id, name, kind}]}]}`.

Present each team on its own line: the team `name` followed by its member names.

For full profiles of any member, use `/describe-companions <names>`.

If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup` instead.
