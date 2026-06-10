---
description: Verify the Companions MCP is authenticated and reachable; otherwise walk the user through the OAuth sign-in.
---

# Companions — setup check

Call the `check_balance` MCP tool and report the first matching outcome:

- Returns a balance envelope → say "Companions is set up. Balance: $X." Done.
- Returns 401 / authentication error, **or** the MCP server shows as needing
  authentication / not connected → the user has not signed in yet (or their
  session expired). Print the "Setup walkthrough" below.
- Network / 5xx error → authentication is fine but the service is unreachable.
  Print the service URL (`https://api.humx.ai/mcp`) and ask the user to confirm
  they're online.

This MCP authenticates with OAuth — there is no API key and no environment
variable to set. The MCP call itself is the auth check; never ask the user to
paste a token or key.

## Setup walkthrough

If the user is not authenticated:

1. Run `/mcp` in Claude Code. The `companions` server is flagged as needing
   authentication.
2. Select `companions` → **Authenticate** (or "Login"). Claude Code opens your
   browser.
3. Sign in (Google or email) and approve the consent screen at
   `https://login.humx.ai`. The browser shows a success page; return to Claude
   Code.
4. Claude Code stores the token in your OS keychain and reconnects
   automatically — no restart needed. It refreshes the token on its own when it
   expires.
5. Re-run `/companions-setup` to verify.

If the session is simply expired, the same `/mcp` → Authenticate flow re-issues
a token. To switch accounts, choose **Clear authentication** in the `/mcp` menu
first, then authenticate again.

> The plugin ships no credentials. Authentication is handled entirely by Claude
> Code's built-in MCP OAuth client against `api.humx.ai` / `auth.humx.ai`; the
> token lives in your keychain, not in this plugin.
