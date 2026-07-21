# Consultation protocol

Treat the response status as the next action:

- `complete`: read the typed `content`, translate it for the user, and attribute it.
- `pending` or `running`: keep the `job_id` and call `get_job` later. Pull on a useful cadence, not in a tight loop. Never start another consultation to collect the same work.
- `requires_action`: execute every pending client-tool call, then pass exactly one result per `tool_call_id` to `submit_tool_outputs`. Repeat if another action is requested.
- `needs_reply`: answer the requested clarification with `submit_reply`.
- `ambiguous`: show the candidates and retry with the intended stable ID after the user or context resolves it.
- `decision`: fix the reported input problem before making a new call; there may be no job to poll.
- `failed` or `error`: explain the useful error message. Do not pretend a Companion answered.

Use `consult` with short timeout (45s default is good) and rely on `get_job` for responses that take more time.

If credit is insufficient, tell the user before attempting another consultation.
