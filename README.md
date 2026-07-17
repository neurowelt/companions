# Companions

Companions brings additional expert perspectives into everyday work: a second opinion on a decision, critique of a draft, a different framing for a problem, or a human-steered brainstorm.

In order to interact with Companions API we provide an MCP server hosted at `https://api.humx.ai/mcp` that your AI harness of choice can interact with.

> [!TIP]
> Make sure to check out our [Wiki page](https://github.com/neurowelt/companions/wiki/Companions) to learn about available Companions!

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

Then run `/setup`. The agent checks the connection, offers a short handshake, recommends one everyday Companion, and gives you two tailored questions to try. Nothing is consulted until you choose a prompt. You can change or clear the everyday default later.

## Claude Desktop

In your **Claude Desktop** application go to **Customize** > **Connectors**. Click the "**+**" icon and choose **Add custom connector**. Fill out the fields:
- **Name**: Companions
- **MCP URL**: https://api.humx.ai/mcp

Confirm by clicking **Add**. Remember to enable each tool for that MCP by clicking the slider next to tool names.

After connecting, ask the chat:
```
Please set up Companions for me. Check the connection, then offer the short handshake if I do not have an everyday default.
```

## Hermes Agent

Connecting MCP to Hermes is easiest done using the following command:
```bash
hermes mcp add --url https://api.humx.ai/mcp --auth oauth companions
```

## Codex CLI

You can add the marketplace by using `/plugins` command within Codex CLI, choosing **Add Marketplace** and pasting the link to this repository. Codex will automatically open browser's window for authentication.

If authentication expires later, reconnect the MCP without reinstalling the plugin:

```bash
codex mcp login companions --scopes openid,offline_access
```

After login, restart Codex or start a new thread so the Companions tools are loaded again.

Run `/setup` to complete the introduction and choose an everyday Companion. The default is used for simple one-person questions; the agent still chooses multiple Companions problem by problem.

## Everyday use

Companions are intentional second opinions, not only formal experts. Try prompts such as:

- “Ask my everyday Companion what I may be overlooking in this decision.”
- “Get two relevant Companion perspectives on this draft, then show me their distinct views and your synthesis.”
- “Would a Companion brainstorm help before we design this feature?”

The agent should explain why it wants to consult a particular Companion. It translates responses into your preferred language and structure while preserving each Companion's distinct point of view. Ask for the raw response whenever you want it.
