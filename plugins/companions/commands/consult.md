---
description: Consult one or more expert personas via the Companions MCP.
argument-hint: "<prompt> [mode=<answer, parallel, ...>] [main=<name>] [participants=<name1>,<nam2>...]"
---

The user has invoked `/consult $ARGUMENTS`.

1. Parse `$ARGUMENTS`. The first segment is the **prompt**. Optional trailing tokens may specify `mode=...`, `main=...`, `participants=name1,name2`. If the prompt is missing, ask the user what they want to consult about.
2. If `mode` is not specified, pick one using the table in the `using-companions` skill (question shape → mode).
3. If `main` or `participants` are needed by the chosen mode and not specified, call `list_companions` first (or `list_teams` when the user named a team) and ask the user to pick — or, when the choice is obvious from the prompt, default and tell the user what you chose.
4. **Declare your tools.** If the prompt touches any local material the expert could inspect (a repo, files, a URL), pass a `tools` array describing what you can run locally instead of pre-digesting it yourself. See the `using-companions` skill ("Always hand the expert your tools"). Tools need `mode=answer` in v1.
5. Call `consult` with the resolved arguments. If it returns `{status: "pending", job_id}` (heavy modes often outlast the ~60s wait), the run is alive server-side — collect it with `get_job(job_id)`, pulling on your own cadence until it is terminal, and never re-issue `consult` (see the skill's "Collecting a `pending` run"). If it returns `requires_action`, run each pending tool call yourself and resume with `submit_tool_outputs`, repeating until it resolves (see the skill's "client-tool loop"). Present the result with per-speaker attribution (see the skill for which `content` field to read per mode).
6. Trailing one-liner: "(consulted N experts)" if multi-expert.

If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup` instead.
