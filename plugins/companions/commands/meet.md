---
description: Meet a Companion — have one companion introduce itself to your user, tailored to your project.
argument-hint: "<companion> [note about the user and project]"
---

Introduce your user to a specific companion by calling the `meet` MCP tool. Use this when the user wants to *get to know* an expert — not to ask it a question (that's `consult`).

Arguments: `$ARGUMENTS` — the companion to meet (a name or `cmp_<uuid>` id), optionally followed by a note about the user and/or project. E.g. `/meet Kris` or `/meet Kris — solo dev building an MCP bridge`.

1. Resolve the target companion from the arguments. If none was given, or you don't yet know which companions exist, run `list_companions` first (or `/handshake` if this is a fresh project) and ask the user which one they'd like to meet.
2. Compose the call:
   - `companion`: the name or `cmp_<uuid>` id from the arguments.
   - `user`: a one-line portrait of the user and their work. Infer it from the conversation and any note in the arguments; keep it honest and short.
   - Optionally pass `project` and your own `self` (`{model, harness, capabilities}`) so the introduction lands.
3. Call `meet`. On completion you get the companion's first-person introduction (`content`) and the `companion: {id, name}` it resolved to. Relay the introduction to the user with attribution.
   - `companion_not_found` (carries `visible`): show the visible names and let the user pick.
   - `ambiguous` (carries `candidates`): re-call with the `cmp_<uuid>` id of the intended one.

`meet` is a hello, not the bootstrap: it returns no recommendation and no working agreement, and it never needs `submit_reply`. If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup`.
