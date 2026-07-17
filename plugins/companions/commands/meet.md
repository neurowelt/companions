---
description: Meet a Companion — have one companion introduce itself to your user, tailored to your project.
argument-hint: "<companion> [note about the user and project]"
---

Call `meet` when the user wants to get to know a Companion. Use `consult` for an actual question.

Arguments: `$ARGUMENTS` — the companion to meet (a name or `cmp_<uuid>` id), optionally followed by a note about the user and/or project. E.g. `/meet Kris` or `/meet Kris — solo dev building an MCP bridge`.

Resolve the target from `$ARGUMENTS`, using `list_companions` when needed. Pass its name or stable id plus a short, honest user portrait; include project and host context when useful. Relay the first-person introduction with attribution. For `companion_not_found`, show visible names. For `ambiguous`, resolve the intended stable id before retrying.

`meet` is a hello, not setup or consultation. On 401 or an authentication failure, use the `/setup` walkthrough.
