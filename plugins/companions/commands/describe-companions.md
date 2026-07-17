---
description: Show full profiles for a shortlist of companions by name or id.
argument-hint: "<name or cmp_<uuid>> [more names or ids…]"
---

Call `describe_companions` to read full profiles for a shortlist (typically two to five).

Arguments: `$ARGUMENTS` — one or more companion refs, each a name or a `cmp_<uuid>` id, space-separated. E.g. `/describe-companions Kris Kalo` or `/describe-companions cmp_1234... Kris`. If no refs were given, run `/list-companions` first and ask the user which ones to describe.

Pass the refs as `companions`. Present each resolved profile under its name. Partial success is fine: explain `not_found`; for `ambiguous`, show candidates and retry with the intended stable id.

This is the cheap catalogue read — text, no model call. To have a companion introduce **itself** in the first person instead, use `/meet <companion>`.

On 401 or an authentication failure, use the `/setup` walkthrough.
