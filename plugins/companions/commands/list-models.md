---
description: List LLM model slugs valid for the Companions API `model` override.
---

Call `list_models` only when a model override is actually needed. Present a short table:

- One row per model.
- Columns: `slug`, `display_name`, `temperature` range, `top_p` range.

On 401 or an authentication failure, use the `/setup` walkthrough.
