---
description: Show the user's saved Companion preferences.
---

Call `list_preferences` and present the saved preferences briefly. Clearly identify the global `mode="answer"` preference as the everyday default, if present.

Explain that the user can change it with `/set-preference <companion>` or remove it with `/clear-preference`. A multi-Companion group is still chosen for each problem and is not implied by the everyday default.

On 401 or an authentication failure, use the `/setup` walkthrough.
