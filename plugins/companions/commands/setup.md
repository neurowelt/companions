---
description: Check Companions authentication, introduce first-time users, and manage their everyday default Companion.
---

# Companions setup

1. Call `check_balance`.
   - On success, report the balance briefly and continue.
   - On 401 or an authentication-required MCP state, tell the user to run `/mcp`, select `companions`, and choose **Authenticate**. There is no API key or environment variable to paste.
   - On a network or 5xx error, report `https://api.humx.ai/mcp` and ask the user to confirm connectivity.
2. Call `list_preferences` and inspect the global `mode="answer"` preference.
   - If one exists, name the everyday default and explain that the user can update or clear it at any time. Setup is complete; do not make them reconfirm an existing choice unless they asked to change it.
   - If none exists, say: “Companions is connected. If this is your first time, I can run a short handshake to introduce the system, recommend an everyday Companion, and give you two questions to try.”
3. If the user accepts, run `handshake` with a short portrait of the user, project, and host agent. Follow the returned working agreement. Present the recommended default, why it fits, and the tailored warm-up questions.
4. Ask whether to save the recommendation as their everyday default. Only after confirmation call `set_preference(mode="answer", main=<recommended id or name>)`. A team is not needed for this preference.
5. Offer a few warm-up prompts based on handshake response and your knowledge of what user is working on. Call `consult` only if the user chooses it; setup itself must never spend consultation credit automatically.

To change an existing default, agree on the new Companion and call `set_preference(mode="answer", main=...)` after confirmation. To remove it, call `clear_preference(mode="answer")` after confirmation. Both choices can be changed later.
