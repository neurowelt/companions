---
name: using-companions
description: Use when the user's problem would benefit from domain-expert perspectives — explicit asks ("what would a neuroscientist say"), contested questions with no single right answer, or moments when you've hit a wall and need a fresh angle. Drives the `companions` MCP server (handshake, meet, list_companions, describe_companions, list_teams, list_models, consult, check_balance). Not for things you already know cold.
---

# Using Companions — the expert-panel MCP

You have access to a panel of generated expert personas through the
`companions` MCP server. The tools are `handshake`, `meet`, `list_companions`,
`describe_companions`, `list_teams`, `list_models`, `consult`, `submit_reply`,
`submit_tool_outputs`, `get_job`, and `check_balance`. This skill tells you when
to reach for them and how to interpret what comes back.

## Starting a new project — `handshake` first

The FIRST time you bring Companions to a project — and you have no
remembered setup for it yet — call `handshake` before anything else. Hand it a
one-line portrait of the user and a self-portrait of yourself
(`{model, harness, capabilities}`, including whether you keep memory across
sessions). It hands back the 2-3 experts that fit this project, a
`recommendation` block (your default companion set + mode) to persist, and
a verbatim `working_agreement` — the durable rules for using this MCP.
**Persist what it establishes and reuse it; don't re-`handshake` for routine
work.**

`handshake` is single-use per project. Once you have a remembered setup, reach
experts directly with `consult`; when you're unsure which experts or mode
fit a specific problem, ask for advice with `consult(main="ferryman", ...)`
rather than re-running it. If `handshake` (or a turn-capable consult) needs
more from you first, it returns `needs_reply` — author the missing detail and
resume with `submit_reply(job_id, reply)`. The working agreement it returns
is the source of truth for the rest; follow it.

## Getting to know a companion — `meet`

`handshake` shakes hands with the **system**; `meet` introduces your **user**
to one **companion**. When the user wants to *get to know* an expert — "who is
Kris?", "tell me about the neuroscientist", "let me meet one of these" — don't
paraphrase a persona from its `description`. Call `meet` and let the companion
introduce **itself**: it speaks in the first person, warm and tailored to your
user and project, and says how it would help. That is a truer introduction than
anything you'd write about it.

When you show the user the roster (from `handshake` or `list_companions`), you
can offer this: suggest they `meet` any one that catches their eye. Then:

- `meet(companion, user, project?, self?)` — `companion` is the name (or
  `cmp_<uuid>` id) of the one to meet; `user` is a one-line portrait of your
  user and their work; pass `project` and your `self` portrait when you have
  them, so the introduction lands.
- It returns `complete` with the companion's first-person intro (`content`, the
  `answer` shape) and the `companion: {id, name}` it resolved to. Relay the
  intro to the user with attribution. There is **no** recommendation block and
  **no** working agreement — `meet` is a hello, not the bootstrap.
- An unknown name returns `{status: "error", reason: "companion_not_found",
  visible: [...]}` — show the visible names and let the user pick. A name shared
  by two companions returns `{status: "ambiguous", candidates: [...]}` — re-call
  with the `cmp_<uuid>` id of the intended one.

`meet` is for *acquaintance*, `consult` is for *answers*. If the user actually
has a question for the expert, use `consult`, not `meet`.

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
- No expert in `list_companions` is a credible fit — say so, answer directly
- The question is operational (code, debugging, config) — these tools
  are for *opinions*, not facts

## Always hand the expert your tools

When you consult, you are the expert's hands on the user's machine. **On
every `consult`, pass a `tools` array describing what you can do locally**
— read a file, list or search a repo, fetch a URL, run a command — and let
the *expert* decide what to inspect. This is the expected default, not an
add-on.

**Do NOT pre-digest the material and call `consult` without tools.**
Pasting a static summary you chose — a file tree you dumped, an excerpt
you picked — is strictly weaker than giving the expert the ability to pull
the exact data it needs: you've already made the judgment calls the expert
was supposed to make. The whole point of client tools is that the *expert*
drives the inspection, not you. Offer the capability on every call; whether
to use it is the expert's call to make, not yours to pre-empt.

Map your real capabilities to tool declarations. Each tool is a neutral
`{name, description, parameters}` object where `parameters` is a JSONSchema
for the call arguments. A good default set when a question touches a
codebase or files you can read:

```json
[
  {"name": "list_files",
   "description": "List files under a subdirectory of the project, recursively.",
   "parameters": {"type": "object",
     "properties": {"subdir": {"type": "string", "description": "Relative subdir; empty for the whole tree."}}}},
  {"name": "read_file",
   "description": "Read a file. Returns content with 1-based line numbers.",
   "parameters": {"type": "object",
     "properties": {"path": {"type": "string"},
                    "start_line": {"type": "integer"},
                    "end_line": {"type": "integer"}},
     "required": ["path"]}},
  {"name": "grep",
   "description": "Search the project for a regex; returns path:line:content.",
   "parameters": {"type": "object",
     "properties": {"pattern": {"type": "string"},
                    "glob": {"type": "string"}},
     "required": ["pattern"]}}
]
```

Declare only tools you can actually run (back `read_file` with your Read,
`grep` with your Grep/Bash, etc.). Describe each honestly so the expert
knows when to reach for it. **Only skip `tools` when the question is pure
opinion with no local material to ground it** — e.g. "what does Kris think
about consciousness?" — where there is nothing on the user's machine for
the expert to inspect.

When the expert calls a tool, `consult` (or a prior `submit_tool_outputs`)
returns `requires_action` instead of a final answer. You then run each
pending call and resume the run — see **The client-tool loop** below.

## Workflow

**New project, no remembered setup?** Run `handshake` first (see *Starting a
new project — `handshake` first*), then continue with the steps below. Skip it
once you have a remembered Companions setup for this project.

1. **First time this session:** call `check_balance`. If low, tell the
   user before spending. Cache the result for the session.
2. **Call `list_companions`** to see what experts exist — the cheap directory.
   Cache for the session. You get `{companions}`, a flat list where each entry
   is `{id, name, kind, visibility, hint}` and `hint` is a one-line teaser (the
   first sentence of the description). This is enough to confirm a companion
   exists, check spelling, resolve ambiguity, and **shortlist** — `consult`
   accepts either the *name* (readable) or the `cmp_<uuid>` id (use when a name
   is ambiguous).
   - **Need full profiles?** Once the hints let you shortlist a few candidates
     (typically 2–5), call `describe_companions([...refs])` with their names or
     ids. It returns `{companions, errors}` where each resolved entry carries
     the **full, untruncated** `description` plus its `teams`. This is a cheap
     catalogue read — no model call. (For a warm first-person introduction
     instead of text, `meet` a companion — that one *is* a live model call.)
   - **Need team rosters?** Call `list_teams` → `{teams: [{id, name, visibility,
     members: [{id, name, kind}]}]}`. When the user names a team, pass its
     members' names (or ids) as `participants` to `consult`.
3. **(Optional) Call `list_models`** if you're going to pass a `model`
   override anywhere it's accepted (e.g. directly via the API). The
   response is `{models: [{slug, display_name, temperature_min,
   temperature_max, top_p_min, top_p_max}, ...]}`, alphabetically
   sorted. Slugs outside this list are rejected at the wire boundary
   with a 422 carrying the accepted slugs in `ctx.accepted`. Cache for
   the session. **Don't** call this just for show — only when you
   actually need to pick a model.
4. **Pick a mode** based on question shape:

   | Question shape                                | Mode                  |
   |-----------------------------------------------|-----------------------|
   | "What does X think about Y?"                  | `answer` + `main=X`   |
   | "Deep research on Y from X's angle"           | `answer_crumbs`       |
   | "Give me N independent takes on Y"            | `parallel`            |
   | "X leads, others react"                       | `parallel_with_main`  |
   | "Synthesise N expert views into one answer"   | `panel`               |
   | "I want X and Y to debate Z"                  | `discussion`          |

5. **Declare your tools** (see "Always hand the expert your tools"). If
   there is any local material the expert could inspect, build the
   `tools` array now. Client tools are supported for `mode="answer"`
   only in v1 — if you need tools, use `answer`.
6. **Call `consult`.** It waits briefly for the answer (default 60s) — don't
   ask the user to wait, just do it. Quick modes return the answer in one
   round-trip; heavy modes (`discussion`, `panel`, `parallel_with_main`, deep
   crumbs) often outlast the wait and return `{status: "pending", job_id}` —
   NOT a failure, the run is alive server-side. Collect it with `get_job` while
   you keep working (see **Collecting a `pending` run** below). If it returns
   `requires_action`, run the client-tool loop below instead.
7. **Present the result with attribution** — read the right field of
   `content` per mode (see the table below). For `panel` / `discussion` /
   `parallel`, name who said what; don't collapse multiple voices into
   one.
8. **Report cost discipline** in one short trailing line if you spent
   non-trivially: "(consulted 3 experts, balance now $X)". One line max.

## The client-tool loop

When `consult` (or `submit_tool_outputs`) returns
`{status: "requires_action", job_id, node, pending_tool_calls}`, the expert
has called one of YOUR tools and the run is paused waiting on you:

1. For each entry in `pending_tool_calls` — shape
   `{call: {id, function: {name, arguments}}, tool: {...declaration}}` —
   read `call.function.name` and parse `call.function.arguments` (a JSON
   string). **Run the call yourself** with your real tools (Read, Grep,
   Bash, WebFetch, …).
2. Build one output per pending call: `{tool_call_id: call.id, output: "<verbatim result string>"}`.
   Stringify structured results. You MUST return exactly one output per
   pending id — no more, no fewer.
3. Call `submit_tool_outputs(job_id, tool_outputs)`. It blocks and
   resolves to the next stop: a final answer (`complete`), a `failed`, or
   **another** `requires_action` if the expert calls more tools — in which
   case repeat this loop.
4. Pass `idempotency_key` (any unique string) if you might retry a dropped
   connection — a retry with the same key replays the original result
   instead of double-resuming.

Do not fabricate tool outputs. If you genuinely cannot run a pending call,
return an honest error string as its `output` so the expert can adapt.

## Collecting a `pending` run

`consult` waits only briefly (default 60s) before handing back a handle, so a
long `panel` or `discussion` returns `{status: "pending", job_id}` rather than
blocking your whole turn. The run keeps going server-side — the answer is not
lost. To collect it:

1. Note the `job_id`. Go do other useful work — you don't have to sit and wait.
2. Call `get_job(job_id)`. It waits briefly and returns either the finished
   answer (the SAME envelope `consult` would have — see below) or
   `{status: "pending"|"running", job_id}` meaning "not ready yet."
3. If still pending, call `get_job(job_id)` again after your next chunk of work
   — on your own cadence, not a tight loop. Repeat until it is terminal
   (`complete`/`failed`) or hands you a turn (`requires_action` →
   `submit_tool_outputs`, `needs_reply` → `submit_reply`).

`get_job` is read-only — it never spends credit, so pulling is always safe. Pass
`timeout_seconds=0` for an instant snapshot ("is it done yet?") without waiting.
It also collects a `submit_reply` / `submit_tool_outputs` that came back
`pending`. **Never** re-issue `consult` to retrieve a pending run: the original
`job_id` is the one live handle to your answer, and a fresh `consult` enqueues
(and bills) a second run.

## Reading `consult` results

`consult` returns one of these envelopes:

- **`{status: "complete", job_id, mode, content, stages}`** — success.
  Every `content` carries a `shape` discriminator matching `mode`.
  Single-expert modes carry one persona's response; multi-expert modes
  carry a `list[ParticipantResponse]` shaped `{slot, id, name, response}`.

  | Mode                 | Fields on `content`                                                       |
  |----------------------|---------------------------------------------------------------------------|
  | `answer`             | `shape="answer"`, `companion`, `companion_id`, `response`                 |
  | `answer_crumbs`      | `shape="answer"`, `companion`, `companion_id`, `response`, `crumbs?`      |
  | `parallel`           | `shape="parallel"`, `responses: list[ParticipantResponse]`                |
  | `parallel_with_main` | `shape="parallel_with_main"`, `main_companion`, `main_companion_id`, `main_response`, `participants?: list[ParticipantResponse]` |
  | `panel`              | `shape="panel"`, `aggregator_companion`, `aggregator_companion_id`, `synthesis`, `stage1?`, `stage2?` |
  | `discussion`         | `shape="discussion"`, `summarizer_companion`, `summarizer_companion_id`, `summary`, `turns?: list[{speaker, speaker_id, response, pointer}]` |

  Intermediate fields marked `?` are absent when the engine ran with
  `RETURN_INTERMEDIATE_STEPS=false`. Don't assume they're there — the
  final field (`synthesis` / `summary` / `response`) is always present.

- **`{status: "requires_action", job_id, node, pending_tool_calls}`** —
  the expert called one of your `tools`. Run them and resume via
  `submit_tool_outputs` — see **The client-tool loop** above. This is NOT
  a failure; the run is alive and waiting.

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

- **`{status: "ambiguous", kind, field, name, candidates, hint}`** — a
  `main` or `participants` name maps to more than one visible companion
  (or team). `candidates` is the list of `{id, name, ...}` rows it could
  have meant. Re-call with the `cmp_<uuid>` / `team_<uuid>` id of the
  intended row.

- **`{status: "visibility_violation", message}`** — server rejected the
  call because a private companion would join a non-private team (or an
  analogous case). Surface the message; this is a hard constraint, not a
  retry path.

- **`{status: "pending", job_id, hint}`** — the run outlasted `consult`'s
  courtesy-wait and is still going server-side. NOT a failure, NOT lost.
  Collect it with `get_job(job_id)` — see **Collecting a `pending` run**
  above. Never re-issue `consult` to retrieve it; that enqueues a second,
  separately billed run.

- **`{status: "error", http_status, body, ...}`** — POST or poll failed
  at the HTTP layer. Read `body` for the reason. Common causes:
  - **402**: exhausted balance.
  - **422 unknown_model**: a `model` override (set at the API/CLI layer)
    was outside the allow-list. `body.detail[*].ctx.accepted` lists the
    slugs you may pick — same data as `list_models`.
  - **422 temperature_out_of_range** / **top_p_out_of_range**: bounds
    violation. `ctx.min` / `ctx.max` / `ctx.actual` carry the offending
    values; per-model bounds also surface in `list_models`.

`submit_tool_outputs` returns the SAME envelope set as `consult`, plus an
`error` for a rejected submit — e.g. **409** if the run already resumed or
the pause expired (restart the consult), **400** on an id-coverage
mismatch (you returned the wrong set of `tool_call_id`s), **422** on an
output-bounds violation.

## Failure modes

- **No relevant expert exists** → don't force a fit. Answer directly,
  tell the user there wasn't a good match, name what kind of expert
  *would* help so they can generate one.
- **Balance hits zero mid-task** → stop, tell the user, ask whether to
  top up or proceed without consultation.
- **Unknown companion name** → re-call `list_companions` (the user may have
  generated something new this session) before assuming the name is bad.
- **Unknown model slug rejected (422)** → re-call `list_models` rather
  than guessing. The accepted list is also embedded in the 422 body's
  `ctx.accepted`.
- **You skipped tools and the expert asked for material you have** → you
  pre-empted the expert's inspection. Re-run the consult with the right
  `tools` declared and let it drive.

## Quick reference — what each tool returns

- `handshake(user, self, project?, surface?)` → first-project bootstrap
   (agent → system): `{content (prose), recommendation, recommendation_grounded,
   working_agreement}`. May return `needs_reply` — answer via
   `submit_reply`. Single-use per project; persist what it establishes.
- `meet(companion, user, project?, self?, surface?)` → introduce ONE companion
   to your user (user → companion): `{content (the companion's first-person
   intro), companion: {id, name}}`. No recommendation, no working agreement — a
   hello. `companion_not_found` (with `visible`) / `ambiguous` (retry with the
   id) on a bad name.
- `list_companions()` → the cheap directory: `{companions: [{id, name, kind,
   visibility, hint}]}` where `hint` is the first sentence of the description.
   Confirm existence / spelling, resolve ambiguity, shortlist.
- `describe_companions(companions: [ref, ...])` → full profiles for a shortlist
   (names or `cmp_<uuid>` ids): `{companions: [{id, name, kind, visibility,
   description, teams}], errors: [{ref, reason}, ...]}`. `description` is the
   full untruncated text. Partial success is fine; an `ambiguous` error carries
   `candidates` (retry with the id), a `not_found` matched nothing. Cheap read,
   no model call.
- `list_teams()` → `{teams: [{id, name, visibility, members: [{id, name,
   kind}]}]}` — teams and their member rosters. Full member profiles via
   `describe_companions`.
- `list_models()` → `{models: [{slug, display_name, temperature_min,
   temperature_max, top_p_min, top_p_max}, ...]}` (alphabetical by slug)
- `consult(prompt, mode, main?, participants?, tools?, timeout_seconds=60)`
   → see "Reading `consult` results". Waits ~60s, then returns the answer or
   `{status: "pending", job_id}` to collect with `get_job`. **Pass `tools` on
   every consult** where the expert could inspect local material (see "Always
   hand the expert your tools").
- `submit_reply(job_id, reply, idempotency_key?, timeout_seconds=60)`
   → answer a `needs_reply` (from `handshake` or a turn-capable `consult`);
   same envelope set as `consult`.
- `submit_tool_outputs(job_id, tool_outputs, idempotency_key?, timeout_seconds=60)`
   → resume a paused run; same envelope set as `consult`.
- `get_job(job_id, timeout_seconds=60)` → collect a `pending` run (or a
   paused/timed-out resume) by its handle: the same envelope set as `consult`
   once terminal, or `{status: "pending"|"running", job_id}` to call again.
   Read-only, never bills; `timeout_seconds=0` for an instant snapshot.
- `check_balance()` → API balance envelope (pass-through).
