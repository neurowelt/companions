---
name: perspective
description: Use for a structured second opinion, critique, alternative framing, or several independent Companion perspectives on a concrete problem, decision, strategy, or draft. Clarifies the question, agrees who to ask, preserves distinct voices, and adds a host synthesis when several Companions answer.
---

# Perspective

Use Companions as additional thinkers, then turn their responses into an answer the user can act on.

## Stage 0: Frame the question

If user provides little or superficial information about their problem or task, ask them clarifying questions until you can understand the input. This is a critical phase on which gaining a new perspective relies on.

Clarify only what materially affects the consultation:

- the outcome or decision;
- concrete context and relevant material;
- constraints and non-negotiables;
- whether the user wants exploration, critique, extension, or a recommendation;
- ambiguous acronyms, shorthand, or assumptions.

For critique, include the draft or artifact and ask what works, what is weak or missing, and how to improve it without losing its purpose.

## Stage 1: Agree who to ask

Recommend one to three Companions whose perspectives differ in a useful way. State why each one fits. Use one for a quick second opinion; use several when disagreement or coverage is valuable.

Get the user's agreement before spending credit unless they already named the Companions, explicitly asked you to choose, or gave standing permission. For one Companion, the user's everyday Companion is the natural proposal; send it as `main`. For several, choose the group for this problem and pass every participant explicitly (a chosen team goes in as its `team_<uuid>` id, with `main` when the mode needs a lead); the server infers nothing, so do not treat any saved or previous group as the answer.

If the roster is unfamiliar, inspect it with `list_companions` (free) and propose from it yourself. When routing remains materially unclear, offer `discover` with the task — it returns a grounded setup with a price band and bills its small metered cost.

## Stage 2: Consult independently

Give every Companion the same complete frame. For independent perspectives, do not reveal another Companion's answer before the first response. Always declare the reusable client tools the host can currently execute on every consultation so each Companion can inspect files, search, or fetch resources itself. See the [client tool declarations](../using-companions/references/client-tools.md).

Use ordinary `answer` consultations, each with that person's `main`, for separate one-person views. Each `consult` bills and returns a receipt with a `job_id`; collect every run with `get_answer`, and follow the continuation protocol for pending work or tool calls. Never simulate a Companion when the service is unavailable.

## Stage 4: Translate without flattening

Conceptually compress each response into the user's vocabulary and preferred level of detail:

- replace shorthand and abstraction with concrete language;
- keep the core reasoning, uncertainty, and main tradeoff;
- preserve real disagreement;
- attribute the view to its Companion.

Do not merely paste raw output. Offer raw responses if the user wants the original nuance. Calibrate responses to the user's preferred tone of voice

For several Companions, present:

1. each translated perspective in its own short section;
2. where they agree;
3. the important tensions or incompatible assumptions;
4. your synthesis: what the combined views imply for the user's actual task.

The synthesis is the host agent's judgment, not a fabricated consensus.
