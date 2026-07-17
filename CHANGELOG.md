# Changelog

All notable changes to the Companions plugin are documented in this file.

## [0.6.0] - 2026-07-17

### Added
- New `perspective` skill for structured second opinions, critiques, independent Companion views, and host synthesis.
- New `brainstorm` skill for human-steered creative exploration with independent ideas, conceptual compression, and review checkpoints.
- New `/preferences`, `/set-preference`, and `/clear-preference` commands for managing the user's everyday Companion.
- Reusable client-tool declarations and consultation continuation guidance for `pending`, `requires_action`, and `needs_reply` states.

### Changed
- Reworked the `using-companions` skill into a compact activation and routing guide for everyday questions, challenges, decisions, drafts, and ideas—not only formal expert consultations.
- Redesigned `/setup` and `/handshake` around a guided first success: introduce the system, recommend one editable everyday Companion, and offer tailored warm-up questions without automatically spending consultation credit.
- Defaulted ordinary consultations to `answer`, while choosing multiple Companions explicitly for each problem.
- Companion responses are now translated and conceptually compressed for the user while preserving distinct voices; multi-Companion results add a separate host synthesis.
- Simplified command guidance, plugin descriptions, and README onboarding around plain language and intentional second opinions.

## [0.5.0] - 2026-07-07

### Added
- New `get_job` MCP tool — collect a run by its `job-<uuid>` handle: the reader for a `pending` consult (or a paused/timed-out resume). Read-only, never bills.
- `using-companions` skill: a "Collecting a `pending` run" section teaching the submit-then-collect flow.

### Changed
- `consult` now waits a bounded courtesy-window (default 60s) then returns `{status: "pending", job_id}` instead of blocking indefinitely; the former `{status: "timeout"}` envelope is renamed `pending`. Resume verbs (`submit_reply`, `submit_tool_outputs`) default `timeout_seconds` to 60 as well.
- Working agreement bumped to v4 for the wait-policy rule (collect a `pending` run with `get_job`, never re-`consult`).

## [0.4.0] - 2026-07-06

### Added
- New `/describe-companions` command — full profiles for a shortlist of companions by name or id.
- New `/list-teams` command — teams and their member rosters.

### Changed
- Slimmed `list_companions` to a cheap directory of names, ids, and one-line hints; full profiles now come from the new `describe_companions` tool and team rosters from `list_teams`.
- Updated the `using-companions` skill for the shortlist → `describe_companions` flow.
- Working agreement bumped to v3 for the new discovery surface.

### Removed
- Dropped the deprecated `discover` MCP tool alias.

## [0.3.1] - 2026-07-06

### Fixed
- Corrected the OAuth resource URL used during authentication.
- Documented that the MCP server must be reinstalled for the Codex CLI, and added the reinstall note to the README. (`5ca531b`)

## [0.3.0] - 2026-07-03

### Changed
- Renamed the `meet` MCP tool to `handshake`, added a dedicated `/meet` command, and introduced the `using-companions` skill to guide when and how to reach for companion experts. (`664a813`)
- Reformatted indentation across JSON files for consistency. (`0ecf343`)

## [0.2.0] - 2026-06-30

### Added
- New `/meet` command. (`091342f`)
- `meet` handshake flow and `list_companions` support synced into the plugin. (`ab39352`)

### Changed
- Dropped the `companions-` prefix from command names and aligned them with the underlying MCP tool names (`companions-balance` → `check-balance`, `companions-consult` → `consult`, `companions-discover` → `list-companions`, `companions-list-models` → `list-models`, `companions-setup` → `setup`). (`091342f`)
- Renamed the `discover` capability to `list_companions`. (`ab39352`)
- CI now derives the auto-bump level (major/minor/patch) from Conventional Commit messages. (`77cb411`)

## [0.1.9] - 2026-06-15

### Fixed
- Removed agent directives from the authentication flow. (`68e76c3`)

### Documentation
- Added a Codex CLI installation note. (`8db41ff`)

## [0.1.8] - 2026-06-10

### Changed
- Reorganized the repository into a `plugins/companions/` structure for easier plugin installation. (`b8edd0a`)

## [0.1.7] - 2026-06-10

### Fixed
- Added missing fields to the Codex plugin manifest and fixed the version bump script. (`0baf165`)

## [0.1.6] - 2026-06-10

### Added
- Codex plugin manifest (`.codex-plugin/plugin.json`) for Codex CLI support, plus a Hermes installation note. (`2a22aed`)

### Documentation
- Expanded the general project description in the README. (`a6dd4e8`)
- Documented integrations in the README and configured the CI workflow to skip on specific paths. (`4441899`)

## [0.1.5] - 2026-06-02

### Changed
- Switched to OAuth-based authentication; updated `/setup` and all commands to use the new flow. (`c87df10`)

## [0.1.4] - 2026-05-31

### Added
- Tool calling via MCP, allowing companions to invoke tools during a consultation. (`3fb28fe`)

## [0.1.3] - 2026-05-27

### Added
- New `list_models` MCP command. (`1ca3b8d`)

### Changed
- Updated response shapes to match the reworked API. (`1ca3b8d`)

## [0.1.2] - 2026-05-24

### Fixed
- Renamed `mcp.json` to `.mcp.json` so Claude Code auto-discovers the MCP server. (`8deaf0f`)

## [0.1.1] - 2026-05-24

### Fixed
- `/setup` now verifies authentication with a balance check. (`17aefc5`)

## [0.1.0] - 2026-05-24

### Added
- Initial release of the Companions plugin: marketplace manifests (Claude Code and agents), plugin manifest, MCP configuration, and the `consulting-experts` skill. (`b5de196`)
- Commands: `/companions-balance`, `/companions-consult`, `/companions-discover`, `/companions-setup`. (`b5de196`)
- CI workflow for automatic version bumping and a `bump-version.sh` script. (`b5de196`)

[0.6.0]: https://github.com/neurowelt/companions/releases/tag/v0.6.0
[0.5.0]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.5.0
[0.4.0]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.4.0
[0.3.1]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.3.1
[0.3.0]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.3.0
[0.2.0]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.2.0
[0.1.9]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.9
[0.1.8]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.8
[0.1.7]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.7
[0.1.6]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.6
[0.1.5]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.5
[0.1.4]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.4
[0.1.3]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.3
[0.1.2]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.2
[0.1.1]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.1
[0.1.0]: https://github.com/neurowelt/companions-plugin/releases/tag/v0.1.0

---

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Version bumps are derived automatically from [Conventional Commits](https://www.conventionalcommits.org/)
by CI, so each release below corresponds to an automated version bump.
