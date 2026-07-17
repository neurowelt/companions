---
description: Set or change the everyday default Companion.
argument-hint: "<companion name or id>"
---

Use `$ARGUMENTS` as the Companion name or stable id. If missing or ambiguous, call `list_companions` and help the user choose.

Confirm the exact Companion and explain that it will be used for ordinary one-person `answer` consultations when `main` is omitted. After confirmation, call `set_preference(mode="answer", main=<companion>)` without a team, then report the saved default. Mention that it can be changed or cleared later.

On 401 or an authentication failure, use the `/setup` walkthrough.
