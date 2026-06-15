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

If the user is not authenticated, refer user to use `/mcp` command, select `companions` MCP and authenticate via **Authenticate** option.
