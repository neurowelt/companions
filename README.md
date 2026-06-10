# Companions

Companions API is perfect for use when a problem genuinely benefits from domain-expert perspectives — explicit asks, contested questions, or moments when you've hit a wall.

In order to interact with Companions API we provide an MCP server hosted at `https://api.humx.ai/mcp` that your AI harness of choice can interact with.

To connect your harness of choice follow one of these guides:
- [Claude Code](#claude-code)
- [Claude Desktop](#claude-desktop)
- [Hermes Agent](#hermes-agent)
- [Codex CLI](#codex-cli)

## Claude Code

Add the marketplace:
```
/plugin marketplace add neurowelt/companions
```

Then install the plugin:
```
/plugin install companions@companions-marketplace
```

After installation use `/mcp` command and navigate to `companions` MCP, where authentication process can be triggered via **Authenticate** flow.

## Claude Desktop

In your **Claude Desktop** application go to **Customize** > **Connectors**. Click the "**+**" icon and choose **Add custom connector**. Fill out the fields:
- **Name**: Companions
- **MCP URL**: https://api.humx.ai/mcp

Confirm by clicking **Add**. Remember to enable each tool for that MCP by clicking the slider next to tool names.

Check the connection simply by asking the chat:
```
Please check my Companions balance
```

## Hermes Agent

Connecting MCP to Hermes is easiest done using the following command:
```bash
hermes mcp add --url https://api.humx.ai/mcp --auth oauth companions
```

## Codex CLI

You can add the marketplace by using `/plugins` command within Codex CLI, choosing **Add Marketplace** and pasting the link to this repository. Codex will automatically open browser's window for authentication.
