# Reusable client-tool declarations

Attach only tools the current host can execute. Reuse stable declarations instead of rebuilding them for every consultation, but keep descriptions honest when capabilities change. If the host supports persistent agent memory or configuration, store the chosen declarations in its normal application-specific space; do not invent a universal filesystem path.

Typical declarations:

```json
[
  {
    "name": "list_files",
    "description": "List files below a project-relative directory.",
    "parameters": {
      "type": "object",
      "properties": {
        "path": {"type": "string", "description": "Project-relative directory; empty for project root."}
      }
    }
  },
  {
    "name": "read_file",
    "description": "Read a project file, optionally within a line range.",
    "parameters": {
      "type": "object",
      "properties": {
        "path": {"type": "string"},
        "start_line": {"type": "integer", "minimum": 1},
        "end_line": {"type": "integer", "minimum": 1}
      },
      "required": ["path"]
    }
  },
  {
    "name": "search_files",
    "description": "Search project files for text or a regular expression.",
    "parameters": {
      "type": "object",
      "properties": {
        "query": {"type": "string"},
        "glob": {"type": "string"}
      },
      "required": ["query"]
    }
  },
  {
    "name": "fetch_url",
    "description": "Fetch the readable contents of an HTTP or HTTPS URL.",
    "parameters": {
      "type": "object",
      "properties": {
        "url": {"type": "string", "format": "uri"}
      },
      "required": ["url"]
    }
  }
]
```

Add a shell or command tool only when the host can run commands safely and the user has placed that system in scope. Use a narrow schema, for example:

```json
{
  "name": "run_command",
  "description": "Run an approved, non-interactive command in the project workspace.",
  "parameters": {
    "type": "object",
    "properties": {"command": {"type": "string"}},
    "required": ["command"]
  }
}
```

When a consultation returns `requires_action`, execute each requested call with the matching host capability. Return exactly one output for every pending `tool_call_id`. Never invent an output; return an honest error string when a call cannot be performed.
