---
description: Remove the everyday default Companion.
---

Explain that future one-person consultations will need an explicit Companion until another default is saved. After the user confirms, call `clear_preference(mode="answer")`. The operation is safe when no preference exists; report the resulting state plainly.

On 401 or an authentication failure, use the `/setup` walkthrough.
