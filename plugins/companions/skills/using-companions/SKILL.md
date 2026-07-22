---
name: using-companions
description: Use when an idea, challenge, problem, decision, draft, strategy, or ambiguity would benefit from another perspective. Proactively suggest a Companion for a useful second opinion, critique, alternative framing, or specialist view; route creative exploration to the brainstorm skill and structured multi-perspective work to the perspective skill.
---

# Using Companions

Companions are additional thinkers for everyday work. Use them for questions and challenges where another point of view could change the result—not only for formal expert consultations.

## Understanding user's input

If user provides little or superficial information about their problem or task, ask them clarifying questions until you can understand the input. This is a critical phase on which using Companions greatly relies on.

## Suggest them naturally

Suggest Companions when they can provide a concrete benefit, such as:

- pressure-testing a draft or decision;
- noticing a blind spot or hidden assumption;
- reframing a difficult problem;
- adding a relevant specialist or stakeholder perspective;
- generating genuinely different directions.

When suggesting a consultation, say in one sentence **why** it would help and **who** you would ask. Do not merely announce that a tool is available. Ask before starting work that spends credit, unless the user already asked for a consultation or gave standing permission.

Use the `perspective` skill for a structured second opinion, critique, or several independent views. Use the `brainstorm` skill for genuinely generative creative work. Do not activate a full brainstorm just because the word “idea” appears; recommend it when exploration would materially help.

Skip consultation for routine facts, simple operations, or work you already know well unless the user explicitly asks.

## Everyday default

For an ordinary one-person question:

1. Use `mode="answer"`.
2. Omit `main` to use the user's saved everyday Companion.
3. If no default is saved, offer the short handshake/setup flow or agree on a Companion and save it with `set_preference` after confirmation.

The user can change their default at any time with `set_preference`, or remove it with `clear_preference`. Never imply that the choice is permanent.

For more than one Companion, select the group for the specific problem. A saved everyday default may be one candidate, but it does not determine the group. Always pass the agreed participants explicitly. If the right Companion or consultation shape is materially unclear, ask the ferryman for routing advice; do not ask it for routine choices.

## Give useful context

State the outcome, relevant context, constraints, and the exact point that needs another perspective. Expand acronyms and hidden assumptions. Poorly framed input creates drift, so clarify consequential ambiguity before consulting.

Always attach the available reusable client-tool declarations when consulting a Companion, unless the host genuinely cannot execute any of them. Companions use these to inspect files, search, and fetch resources on their own, which produces materially better-grounded answers. Keep those declarations available in the host application's normal persistent memory or configuration when supported, and reuse them on later calls. When you attach client tools, use `mode="answer"` only; complex modes such as parallel are currently rejected together with tools. This does not stop you from consulting several Companions at once: run multiple `answer` consultations concurrently instead of switching to parallel mode, which keeps the tools attached to every call. See [client tool declarations](references/client-tools.md).

## Present the result for this user

Companion responses are source material, not mandatory final wording.

- Translate and conceptually compress each response into the user's language, level of detail, and preferred structure.
- Calibrate to the user's preferred tone of voice. Pitch the summary at that level instead of mirroring the Companion's sophistication.
- Use plain langauge, sentences and meaningful headings by default.
- Preserve the Companion's distinct claim, reasoning, uncertainty, and disagreement. Translation must not flatten voices into consensus.
- Attribute every view. If several Companions answered, show their translated views separately, then add your own synthesis of agreements, tensions, and implications.
- Offer the raw responses when the user wants nuance or detail.

Conceptual compression means removing repetition and shorthand while keeping the mechanism, important constraint, and main tradeoff intact.

## First use and protocol

On first use, run `handshake` to introduce the system, receive the working agreement, recommend one everyday default, and offer tailored warm-up questions. Do not ask the user to clear or restart the session. Save a recommendation only after confirmation.

For continuation states such as `pending`, `requires_action`, and `needs_reply`, follow [the consultation protocol](references/protocol.md). In particular, collect an existing job by its `job_id`; never repeat `consult` to retrieve it.
