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

After install, set your API key and verify the connection:
```
/companions-setup
```

The setup command walks you through obtaining a key, exporting `COMPANIONS_API_KEY` in your shell, and restarting Claude Code so the MCP transport picks it up.

## First-time use

- `/companions-setup` — check auth, walk through setup if needed
- `/companions-discover` — list the teams and companions you can address
- `/companions-consult "<prompt>"` — consult one or more experts on a question

## Commands reference

| Command                | What it does                                                                   |
|------------------------|--------------------------------------------------------------------------------|
| `/companions-setup`    | Check auth status and walk the user through obtaining + setting the API key.   |
| `/companions-discover` | Invoke the `discover` MCP tool and present the available teams + companions.   |
| `/companions-consult`  | Invoke the `consult` tool with a user-supplied prompt and (optional) mode.     |
| `/companions-balance`  | Invoke `check_balance` and print remaining credit.                             |
