---
description: Introduce the Companion system, receive its working agreement, and recommend a first everyday Companion.
---

Call `handshake` when the user is new to Companions or explicitly wants a fresh introduction.

1. Pass a short, honest `user` portrait; your `self` portrait (`model`, `harness`, capabilities, and memory behavior); and `project` or `surface` when useful. Ask only if important context is genuinely unclear.
2. If the response is `needs_reply`, provide the missing detail through `submit_reply`.
3. Explain the system and working agreement in plain language. Follow the agreement for later Companion work and retain it in the host application's normal persistent memory or configuration when supported; do not invent a universal path. Present the recommended everyday Companion, the reason it fits, and the proposed warm-up questions.
4. Check if user has a default Companion in preferences already using `list_preferences`. Ask whether the user wants to replace with or save the proposed Companion as their global `answer` default. Only after confirmation call `set_preference(mode="answer", main=<recommended id or name>)`.
5. Offer a few warm-up prompts based on handshake response and your knowledge of what user is working on and explain why it is a useful first consultation. Do not run it without the user's choice.

Do not require the user to clear or restart the session. The default can be updated with `set_preference` or removed with `clear_preference` at any time. For later problem-specific routing uncertainty, ask the ferryman instead of repeating onboarding.

On 401 or an authentication failure, use the `/setup` authentication walkthrough.
