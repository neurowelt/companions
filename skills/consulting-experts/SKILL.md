---
name: consulting-experts
description: Use when the user's problem would benefit from domain-expert
  perspectives — explicit asks ("what would a neuroscientist say"),
  contested questions with no single right answer, or moments when
  you've hit a wall and need a fresh angle. Drives the `companions`
  MCP server (discover, consult, check_balance). Not for things you
  already know cold.
---

# Consulting experts via the Companions MCP

You have access to a panel of generated expert personas through the
`companions` MCP server. The three tools you'll use are `discover`,
`consult`, and `check_balance`. This skill tells you when to reach for
them and how to interpret what comes back.

## When to consult (and when NOT to)

**Consult when:**
- The user explicitly asks for an expert framing or multiple perspectives
- The question is genuinely contested (ethics, design tradeoffs, open research)
- You've drafted an answer and want it stress-tested by a domain voice
- The user is exploring and benefits from seeing disagreement, not
  consensus

**Do NOT consult when:**
- You already know the answer with high confidence — burning credits
  to launder your own thinking is a tax on the user
- The user is mid-flow and a multi-second consultation breaks their loop
- No expert in `discover` is a credible fit — say so, answer directly
- The question is operational (code, debugging, config) — these tools
  are for *opinions*, not facts

## Workflow

1. **First time this session:** call `check_balance`. If low, tell the
   user before spending. Cache the result for the session.
2. **Call `discover`** to see what's available. Cache for the session.
   You get `{teams, companions}`:
   - `companions` is a flat list of every expert the caller can use.
     Companion *names* — not UUIDs — are what `consult` expects.
   - `teams` groups owned teams with their member companions. When the
     user names a team, look up its `members` and pass those names as
     `participants` to `consult`.
3. **Pick a mode** based on question shape:

   | Question shape                                | Mode                  |
   |-----------------------------------------------|-----------------------|
   | "What does X think about Y?"                  | `answer` + `main=X`   |
   | "Deep research on Y from X's angle"           | `answer_crumbs`       |
   | "Give me N independent takes on Y"            | `parallel`            |
   | "X leads, others react"                       | `parallel_with_main`  |
   | "Synthesise N expert views into one answer"   | `panel`               |
   | "I want X and Y to debate Z"                  | `discussion`          |

4. **Call `consult`.** It blocks until done — don't ask the user to wait,
   just do it. Typical run is seconds to a minute; for longer modes
   (`discussion`, `panel`) raise `timeout_seconds`.
5. **Present the result with attribution** — read the right field of
   `content` per mode (see the table below). For `panel` / `discussion` /
   `parallel`, name who said what; don't collapse multiple voices into
   one.
6. **Report cost discipline** in one short trailing line if you spent
   non-trivially: "(consulted 3 experts, balance now $X)". One line max.

## Reading `consult` results

`consult` returns one of these envelopes:

- **`{status: "complete", job_id, mode, content, stages}`** — success.
  `content` is shaped per `mode`. Pull from these keys:

  | Mode                 | Fields on `content`                                          |
  |----------------------|--------------------------------------------------------------|
  | `answer`             | `companion`, `response`                                      |
  | `answer_crumbs`      | `companion`, `response`, `crumbs?`                           |
  | `parallel`           | `responses: {companion_name: text}`                          |
  | `parallel_with_main` | `main_companion`, `main_response`, `participants?: {…: …}`   |
  | `panel`              | `aggregator_companion`, `synthesis`, `article?`, `stage1?`, `stage2?` |
  | `discussion`         | `summarizer_companion`, `summary`, `turns?: [{speaker, response, pointer}]` |

  Intermediate fields marked `?` are absent when the engine ran with
  `RETURN_INTERMEDIATE_STEPS=false`. Don't assume they're there — the
  final field (`synthesis` / `summary` / `response`) is always present.

- **`{status: "failed", job_id, error: {type, message}}`** — the engine
  run failed. Surface `error.message` to the user verbatim; that string
  is what tells you whether it's an unknown companion, a billing wall,
  or a real engine bug.

- **`{status: "decision", job_id, details}`** — synthetic envelope: the
  API decided not to enqueue a run. `details.reason` is one of
  `project_not_found` (you named a project the caller doesn't own) or
  `main_unresolved` (the engine couldn't pick a `main` from your inputs).
  No credit was spent. Fix the inputs and re-call — do **not** try to
  poll this `job_id`, no row exists.

- **`{status: "timeout", job_id}`** — the run is still going. Surface
  the `job_id` so the user can recover it later with
  `uv run python client.py jobs get <job_id>`. Do not silently retry —
  that's a double-spend.

- **`{status: "error", http_status, body, ...}`** — POST or poll failed
  at the HTTP layer. Read `body` for the reason; common causes are an
  exhausted balance (402) or a malformed request (422).

## Failure modes

- **No relevant expert exists** → don't force a fit. Answer directly,
  tell the user there wasn't a good match, name what kind of expert
  *would* help so they can generate one.
- **Balance hits zero mid-task** → stop, tell the user, ask whether to
  top up or proceed without consultation.
- **Unknown companion name** → re-call `discover` (the user may have
  generated something new this session) before assuming the name is bad.

## Quick reference — what each tool returns

- `discover()` → `{teams: [{id, name, members: [{name, kind, description}]}],
   companions: [{name, kind, visibility, description}]}`
- `consult(prompt, mode, main?, participants?, timeout_seconds=300)` →
   see "Reading `consult` results" above.
- `check_balance()` → API balance envelope (pass-through).
