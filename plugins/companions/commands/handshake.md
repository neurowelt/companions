---
description: Run the Companions first-project handshake — introduce the system and establish your working set.
---

Call the `handshake` MCP tool to run the first-project handshake. Use it **once per project**, when you have not yet remembered a Companions setup for this project (for per-problem advice later, use `consult(main="ferryman", ...)` instead — do not re-run it).

1. Compose the two portraits:
   - `user`: a one-line portrait of the user and the work. Infer it from the project and conversation; if the user or project is genuinely unclear, ask before calling.
   - `self`: your own `{model, harness, capabilities}` — include whether you keep memory across sessions.
   - Optionally pass `project` and `surface`.
2. Call `handshake`. If it returns `needs_reply`, author the missing detail and resume with `submit_reply(job_id, reply)`.
3. On completion you get prose (Experts for you / How to work with us), a `recommendation` block (your default companion set + `default_mode`), and a verbatim `working_agreement` — the durable rules for using this MCP. Follow the working agreement for everything after.
4. **Before persisting, confirm with the user** that they want you to remember this setup. If they agree, store the recommendation + working agreement as your working set and confirm what you stored — then suggest starting a fresh session now that the handshake is done.

To then introduce your user to one of the recommended companions, use `/meet <companion>`.

If the call returns 401 (not authenticated / session expired), run the same fallback as `/setup` instead.
