---
description: Ask one or more Companions for a perspective, critique, or answer.
argument-hint: "<prompt> [main=<name>] [mode=<mode>] [participants=<name1>,<name2>...]"
---

The user invoked `/consult $ARGUMENTS`.

1. Extract the prompt and any explicit `main`, `mode`, or `participants`. Ask for a prompt if missing.
2. Default to `mode="answer"`. When `main` is omitted, use the user's saved everyday default. If none exists, agree on a Companion or offer `/handshake`; do not silently choose.
3. For a multi-Companion consultation, state why multiple views help, agree on the group, and pass every participant explicitly. Select the group for this problem rather than reusing a saved group. If routing is materially unclear, ask the ferryman.
4. Include the outcome, relevant context, constraints, and expanded shorthand. Attach reusable client-tool declarations for any local resources the host can actually inspect.
5. Call `consult`. Continue `pending` work with `get_job`, `requires_action` with `submit_tool_outputs`, and `needs_reply` with `submit_reply`. Never repeat `consult` to collect an existing job.
6. Translate and conceptually compress the result for the user. Preserve attribution and distinct voices. For several Companions, show each translated view and then add agreements, tensions, and your synthesis. Offer raw responses on request.

On 401 or an authentication failure, use the `/setup` walkthrough.
