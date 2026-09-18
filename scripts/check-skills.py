#!/usr/bin/env python3
"""Check standalone skill references and identical shared client-tool guidance.

Run from any directory; optionally pass a repository root to check a staging tree.
Only the standard library is required.
"""

import argparse
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit


# Skills use inline Markdown links and reference definitions. Ignore fenced
# examples so example output paths are not mistaken for packaged resources.
LINK = re.compile(r"\[[^\]\n]*\]\(\s*(<[^>]+>|[^\s)]+)")
DEFINITION = re.compile(r"^\s{0,3}\[[^\]\n]+\]:\s*(<[^>]+>|\S+)", re.MULTILINE)
FENCE = re.compile(r"^\s{0,3}(`{3,}|~{3,})(.*)$")


def prose(text):
    lines = []
    marker = None
    for line in text.splitlines():
        fence = FENCE.match(line)
        if fence:
            run, rest = fence.groups()
            if marker is None:
                marker = run
            elif run[0] == marker[0] and len(run) >= len(marker) and not rest.strip():
                marker = None
            continue
        if marker is None:
            lines.append(line)
    return "\n".join(lines)


def check(root):
    errors = []
    skills = sorted(root.glob("plugins/*/skills/*/SKILL.md"))
    if not skills:
        return ["no skill bundles found"]
    for entry in skills:
        folder = entry.parent.resolve()
        for document in sorted(folder.rglob("*.md")):
            text = prose(document.read_text(encoding="utf-8"))
            for match in list(LINK.finditer(text)) + list(DEFINITION.finditer(text)):
                target = match.group(1).strip("<>")
                parsed = urlsplit(target)
                if parsed.scheme or parsed.netloc or not parsed.path:
                    continue
                path = (document.parent / unquote(parsed.path)).resolve()
                if not path.is_relative_to(folder):
                    errors.append(f"{document.relative_to(root)}: reference leaves skill bundle: {target}")
                elif not path.is_file():
                    errors.append(f"{document.relative_to(root)}: missing reference: {target}")
    canonical = root / "plugins/portal/skills/using-companions/references/client-tools.md"
    expected = canonical.read_bytes()
    for product in ("portal", "companions"):
        for skill in ("using-companions", "brainstorm", "perspective"):
            reference = root / "plugins" / product / "skills" / skill / "references/client-tools.md"
            if not reference.is_file():
                errors.append(f"{reference.relative_to(root)}: missing shared reference")
            elif reference.read_bytes() != expected:
                errors.append(f"{reference.relative_to(root)}: differs from {canonical.relative_to(root)}")
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    errors = check(args.root.resolve())
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print("Skill bundles are self-contained; all six shared client-tool references match.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
