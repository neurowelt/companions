---
name: brainstorm
description: Use when the user asks to brainstorm or when creative work would benefit from several genuinely different directions. Before designing features, components, functionality, or behavior, recommend this Companion-led brainstorm with a concrete reason; proceed only if the user accepts. Keeps the human in control through three review checkpoints.
---

# Brainstorm

Run a human-steered brainstorm with Companions. Produce a few understandable directions, not implementation. If the user explicitly asked to brainstorm, begin the workflow. If creative work merely suggests it would help, briefly recommend it and explain why; continue normally if they decline.

## Principles

- Keep every idea tied to the original problem.
- Generate independently before combining.
- Conceptually compress before every human review.
- Treat the user's reactions as new brainstorm material.
- Prefer a few different mechanisms over many cosmetic variants.
- Preserve meaningful disagreement and uncertainty.
- The host agent is always the orchestrator. Companions are thinkers; they do not own the workflow or impersonate the user.

Conceptual compression rewrites an idea so it is understandable in one reading: ordinary words, concrete behavior, explicit connection to the problem, and the most important tradeoff. It may remove repetition, but must not change the mechanism, erase a constraint, or turn uncertainty into fact.

## Set up the brainstorm

Choose meaningfully different Companions with the user and reuse them throughout:

- **Minimal:** 2 thinkers, 1 idea each. Recommend this first.
- **Moderate:** 3 thinkers, 1–2 ideas each.
- **Extensive:** 5 thinkers, distinct ideas without a fixed quota.
- **Custom:** user chooses both values.

Explain that thinker count controls perspective diversity and ideas per thinker controls depth. The user must approve both values and the Companion choices before consultation begins. Select the group for this problem and pass it explicitly; do not reuse a saved group automatically.

If Companions is unavailable or no suitable thinkers exist, stop and say so. Do not silently replace them with ordinary subagents.

Write the human-facing artifacts under:

```text
docs/companions/brainstorm/<slug>/
  00-charter.md
  01-first-ideas.md
  02-developed-ideas.md
  03-final-ideas.md
  working/              optional raw notes and traceability
```

The four numbered files must stand on their own. Keep raw output in `working/` only when useful.

## Stage 0: Charter

Draft `00-charter.md` in plain language:

- problem and why it matters;
- important context and hard constraints;
- what a useful idea should achieve;
- what is out of scope;
- consequential unknowns;
- approved thinker and idea counts.

**Checkpoint 1:** Show the charter and stop. Do not generate ideas until the user corrects or approves the frame.

## Stage 1: Independent ideas

Give every thinker the same approved charter and relevant material. Consult them independently so they cannot see one another's first ideas. Ask for mechanisms, not rewordings, including at least one direction that challenges an assumption.

Pool, deduplicate, and conceptually compress the responses into `01-first-ideas.md`. Each idea has:

- **The idea:** complete explanation in two to four sentences;
- **How it helps:** explicit connection to the problem;
- **Main tradeoff:** the central cost, risk, or unknown.

**Checkpoint 2:** Show the file and stop. Invite free-form reactions: useful, wrong, missing, surprising, or worth combining. Append a plain-language feedback summary and clarify only uncertain meaning.

## Stage 2: Develop and cross-pollinate

Give every thinker the charter, compressed first ideas, and the user's feedback. Ask them to strengthen useful directions, repair or discard misunderstandings, and fill important gaps. Combining ideas is optional; do not create hybrids for their own sake.

Compress the result into `02-developed-ideas.md` using the same self-contained card structure. References or lineage never substitute for explaining the idea.

**Checkpoint 3:** Show the file and stop. Ask what should move forward, change, remain distinct, or be dropped. Summarize the user's guidance; silence about an idea is not rejection.

## Stage 3: Converge

Ask the same thinkers to challenge the remaining directions for clarity, relevance, distinctness, and tradeoffs. Then write `03-final-ideas.md` for someone who has read only the problem. Begin with a short problem restatement and keep the smallest set that preserves genuinely different useful directions.

Each final idea includes:

- **The idea:** what changes and how it works conceptually;
- **Why it addresses the problem:** the direct connection;
- **What makes it distinct:** its different mechanism or assumption;
- **Main tradeoff:** central risk, cost, or open question;
- **Small next step:** the simplest way to learn whether it is worth developing.

Do not include debate logs, votes, opaque IDs, unexplained metaphors, or claims of validation by agent consensus.

Loop only when the user asks or their feedback materially changes the problem. Return to the earliest affected checkpoint, and never continue Companion discussion while waiting for human feedback.
