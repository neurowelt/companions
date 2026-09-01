---
name: using-companions
description: Use when an idea, challenge, problem, decision, draft, strategy, or ambiguity would benefit from another perspective. Proactively suggest a Companion for a useful second opinion, critique, alternative framing, or specialist view; route creative exploration to the brainstorm skill and structured multi-perspective work to the perspective skill.
---

# Using Companions

Companions are additional thinkers for everyday work. Use them for questions and challenges where another point of view could change the result—not only for formal expert consultations. Users do not think in commands: they describe what they want and expect it to happen. This skill is the single home for how the system works; the slash commands are thin entry points that defer to it.

## Understanding user's input

If the user provides little or superficial information about their problem or task, ask at least one clarifying question — and keep asking until you understand the input — **before** calling `discover` or `consult`, so the eventual call carries real context instead of a guess. Asking the user questions is a natural, expected part of using Companions; every harness can do it. This phase is critical: poorly framed input creates drift in everything downstream.

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

## When no Companion is named

When the user asks to use Companions without naming one ("use companions for this"), run the proposal flow yourself:

1. Clarify first if the description is thin (above).
2. Call `list_companions` (free), filter the roster by what you know of the task and context, and propose one or a few Companions, each with a one-line reason.
3. Alongside your own proposition you may offer `discover`: "I can also run the discover flow to have the system propose the best setup." It returns a grounded setup (companions, mode, reshaped prompt) with a price band and bills a small metered cost like any run. It is great for exploring what the system can do — suggest it, never push it as the primary path.
4. Consult once the user agrees.

The everyday workflow is: clarify if needed → propose → consult. Keep friction minimal; do not force extra steps on the user.

## Everyday default

For an ordinary one-person question:

1. Use `mode="answer"`.
2. Omit `main` to use the user's saved everyday Companion when one exists — `consult` honors it automatically.
3. If no default exists, agree on a Companion with the user, remember their choice in the host application's normal persistent memory or configuration, and pass it as `main` on later calls. Never imply that the choice is permanent.

For more than one Companion, select the group for the specific problem and pass every participant explicitly. A saved everyday default may be one candidate, but it does not determine the group.

## Give useful context

State the outcome, relevant context, constraints, and the exact point that needs another perspective. Expand acronyms and hidden assumptions.

Declare, on every `consult`, the reusable client tools the host can currently execute. Companions use these to inspect files, search, and fetch resources on their own, which produces materially better-grounded answers. Skip declarations only when the host genuinely cannot execute any, or the question is fully self-contained (pure opinion on material already in the prompt). Keep those declarations available in the host application's normal persistent memory or configuration when supported, and reuse them on later calls. Do not assume which modes or combinations are enabled: if one is unavailable the API rejects it and says what is accepted — relay that error; `list_params` lists the currently available modes, models, settings, and limits. See [client tool declarations](references/client-tools.md).

## Present the result for this user

Companion responses are source material, not mandatory final wording.

- Translate and conceptually compress each response into the user's language, level of detail, and preferred structure.
- Calibrate to the user's preferred tone of voice. Pitch the summary at that level instead of mirroring the Companion's sophistication.
- Use plain language, sentences and meaningful headings by default.
- Preserve the Companion's distinct claim, reasoning, uncertainty, and disagreement. Translation must not flatten voices into consensus.
- Attribute every view. If several Companions answered, show their translated views separately, then add your own synthesis of agreements, tensions, and implications.
- Offer the raw responses when the user wants nuance or detail.

Conceptual compression means removing repetition and shorthand while keeping the mechanism, important constraint, and main tradeoff intact.

## First use and protocol

On first use, run the `/setup` flow: check the connection, show the roster from `list_companions`, explain how the system is used, and offer starting questions grounded in the user's actual recent work. Setup is free and never spends consultation credit. Do not ask the user to clear or restart the session.

Only `consult` and `discover` bill. `consult` returns a receipt with a `job_id`, never the answer: collect every run with `get_answer`, the only tool that returns content. `pending` means still running, not lost — never repeat `consult` to retrieve it. For continuation states such as `pending`, `requires_action`, and `needs_reply`, follow [the consultation protocol](references/protocol.md).
