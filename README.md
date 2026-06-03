# Companions

Companions API is perfect for use when a problem genuinely benefits from domain-expert perspectives — explicit asks, contested questions, or moments when you've hit a wall.

In order to interact with Companions API we provide an MCP server hosted at `https://api.humx.ai/mcp` that your AI harness of choice can interact with.

We currently support the following integrations:
- [Claude Code](#claude-code)
- [Claude Desktop](#claude-desktop)

More integrations coming soon!

## Claude Code

Add the marketplace:
```
/plugin marketplace add neurowelt/companions
```

Then install the plugin:
```
/plugin install companions@companions-marketplace
```

After installation, run the setup command for instructions on authentication:
```
/companions-setup
```

Or go straight to `/mcp` and navigate to `companions` MCP, where authentication process can be triggered via **Authenticate**.

## Claude Desktop

In your **Claude Desktop** application go to **Customize** > **Connectors**. Click the "**+**" icon and choose **Add custom connector**. Fill out the fields:
- **Name**: Companions
- **MCP URL**: https://api.humx.ai/mcp

Confirm by clicking **Add**. Remember to enable each tool for that MCP by clicking the slider next to tool names.

Check the connection simply by asking the chat:
```
Please check my Companions balance
```
