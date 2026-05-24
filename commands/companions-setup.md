---
description: Verify the Companions API key is set and the MCP is reachable; otherwise walk the user through setup.
---

# Companions — setup check

Run these steps in order. Report the first failure clearly and stop.

1. **Check the env var.** Is `COMPANIONS_API_KEY` set in the current shell? You can introspect this with `echo "${COMPANIONS_API_KEY:+set}${COMPANIONS_API_KEY:-unset}"`.
   - If **unset**: print the instructions in the "Setup walkthrough" section below and stop. Do not try to call the MCP.

2. **Verify reachability.** Call the `check_balance` MCP tool. Three outcomes:
   - Returns a balance envelope → say "Companions is set up. Balance: $X." Done.
   - Returns 401 / authentication error → the env var is set but the key is invalid or expired. Print the "Setup walkthrough" with the note that the key needs to be replaced.
   - Network / 5xx error → the key is fine but the service is unreachable. Print the service URL and ask the user to confirm they're online.

## Setup walkthrough

If the user has no key:

1. Contact the team to acquire your API key (currently the only way).
3. Export it in your shell. For zsh / bash add this line to `~/.zshrc` or `~/.bashrc`:
   ```bash
   export COMPANIONS_API_KEY=cmp_live_...
   ```
4. Reload your shell (`source ~/.zshrc`) and **restart Claude Code** so the new env is picked up by the MCP transport.
5. Re-run `/companions-setup` to verify.

If the user already has a key but it's invalid, the only step is to regenerate at the dashboard and replace the export line.

> The plugin sends `Authorization: ApiKey ${COMPANIONS_API_KEY}` on every MCP request. The key never leaves your machine via this plugin's code — only via the MCP request itself, which goes directly to `api.humx.ai`.
