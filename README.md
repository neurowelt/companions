# Companions Plugin

Consult Copmanions API in Claude Code. The plugin bundles the `companions` MCP server (hosted at `https://api.humx.ai/mcp`) and a skill that nudges Claude to reach for it when a problem genuinely benefits from domain-expert perspectives — explicit asks, contested questions, or moments when you've hit a wall.

## Installation for Claude Code

Add the marketplace:
```
/plugin marketplace add neurowelt/companions-plugin
```

Then install the plugin:
```
/plugin install companions@companions-marketplace
```

After install, sign in and verify the connection:
```
/companions-setup
```

The `companions` MCP authenticates with OAuth — there's no API key to manage. Run `/mcp`, pick `companions` → **Authenticate**, and sign in through your browser (Google or email). Claude Code stores the token in your OS keychain and refreshes it automatically. `/companions-setup` walks you through this if you're not signed in yet.

## First-time use

- `/companions-setup` — check auth, walk through setup if needed
- `/companions-discover` — list the teams and companions you can address
- `/companions-consult "<prompt>"` — consult one or more experts on a question

## Commands reference

| Command                | What it does                                                                   |
|------------------------|--------------------------------------------------------------------------------|
| `/companions-setup`    | Check auth status and walk the user through the OAuth browser sign-in.         |
| `/companions-discover` | Invoke the `discover` MCP tool and present the available teams + companions.   |
| `/companions-consult`  | Invoke the `consult` tool with a user-supplied prompt and (optional) mode.     |
| `/companions-balance`  | Invoke `check_balance` and print remaining credit.                             |
