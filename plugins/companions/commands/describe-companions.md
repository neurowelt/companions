---
description: Show full profiles for a shortlist of companions by name or id.
argument-hint: "<name or cmp_<uuid>> [more names or ids…]"
---

Call the `describe_companions` MCP tool to read full profiles for a shortlist of companions (typically 2–5).

Arguments: `$ARGUMENTS` — one or more companion refs, each a name or a `cmp_<uuid>` id, space-separated. E.g. `/describe-companions Kris Kalo` or `/describe-companions cmp_1234... Kris`. If no refs were given, run `/list-companions` first and ask the user which ones to describe.

1. Pass the refs as the `companions` array to `describe_companions`.
2. It returns `{companions: [...], errors: [...]}` — partial success is fine.
   - For each resolved companion (`{id, name, kind, visibility, description, teams}`), present its **full** `description` under its name, with attribution.
   - For each `errors` entry, be honest:
     - `not_found` → say the ref matched no companion.
     - `ambiguous` → the name maps to more than one companion; list the `candidates` (`{id, name}`) and offer the `cmp_<uuid>` ids so the user can retry with the intended one.

This is the cheap catalogue read — text, no model call. To have a companion introduce **itself** in the first person instead, use `/meet <companion>`.

If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup` instead.
