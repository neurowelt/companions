# Companions

Companions bring expert perspective into your everyday work: a second opinion on a decision, critique of plans, different framing for a problem, or actually novel ideas.

Most importantly, you can start using Companions in any harness of your choice [using Portal](#portal) or through our [remote MCP](#remote-mcp).

> [!TIP]
> For the best experience we recommend installing [Portal](#portal) – a small local MCP that connects to our service and handles tool calls for Companions.

Make sure to check out our [Wiki page](https://github.com/neurowelt/companions/wiki/Companions) to learn about available Companions.

## Portal

Companions Portal is a small binary running our MCP locally on your computer. It authenticates with our service and connects to your installed harnesses.

It functions as a layer between AI harness and our service. As your agent connects to it and sends tasks to Companions, when in response they require some tool calls, such as file reading or writing, Portal can intercept these tool calls and execute them without engaging your agent, sending response back to our service. Without it, requested tool calls are executed by your agent.

Install it by running the following command in your terminal:

macOS / Linux:
```bash
curl -fsSL https://get.humx.ai/install.sh | sh
```

Windows (PowerShell):
```powershell
irm https://get.humx.ai/install.ps1 | iex
```

The installer downloads the binary for your platform, verifies it, puts `portal` on your PATH and runs `portal setup` for you to authenticate, configure installation, tools and preferences. Run `portal setup` again to add a harness later and `portal update` to update Portal.

Portal installs the `portal` plugin from this marketplace into harnesses chosen during `setup`. If the `companions` plugin for [Remote MCP](#remote-mcp) is already installed, `setup` offers to disable it, as both expose the same tools.

## Remote MCP

We provide a remote MCP server hosted at `https://api.humx.ai/mcp` that your AI harness of choice can interact with.

Choose the harness you want to connect for instructions:
- [Claude Code](#claude-code)
- [Claude Desktop](#claude-desktop)
- [Hermes Agent](#hermes-agent)
- [Codex CLI](#codex-cli)

### Claude Code

Add the marketplace:
```
/plugin marketplace add neurowelt/companions
```

Then install the plugin:
```
/plugin install companions@companions-marketplace
```

After installation use `/mcp` command and navigate to `companions` MCP, where authentication process can be triggered via **Authenticate** flow.

### Claude Desktop

In your **Claude Desktop** application go to **Customize** > **Connectors**. Click the "**+**" icon and choose **Add custom connector**. Fill out the fields:
- **Name**: Companions
- **MCP URL**: https://api.humx.ai/mcp

Confirm by clicking **Add**. Remember to enable each tool for that MCP by clicking the slider next to tool names.

### Hermes Agent

Connecting MCP to Hermes is easiest done using the following command:
```bash
hermes mcp add --url https://api.humx.ai/mcp --auth oauth companions
```

### Codex CLI

You can add the marketplace by using `/plugins` command within Codex CLI, choosing **Add Marketplace** and pasting the link to this repository. Codex will automatically open browser's window for authentication.

If authentication expires later, reconnect the MCP without reinstalling the plugin:

```bash
codex mcp login companions --scopes openid,offline_access
```

After login, restart Codex or start a new thread so the Companions tools are loaded again.
