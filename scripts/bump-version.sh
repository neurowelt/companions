#!/usr/bin/env bash
# Bump the companions plugin version across all manifests, then commit and tag.
#
# Usage:
#   scripts/bump-version.sh show
#   scripts/bump-version.sh patch | minor | major
#   scripts/bump-version.sh set X.Y.Z
#   scripts/bump-version.sh changed [BASE [HEAD]]
#       exit 0 if shipping paths changed (skills/, commands/, mcp.json, .claude-plugin/, .agents/)
#       exit 1 if nothing relevant changed (README, scripts/, .github/ don't count)
#       defaults: BASE=HEAD~1, HEAD=HEAD
#
# Flags:
#   --no-commit         update files but don't commit/tag
#   --allow-dirty       allow running with uncommitted changes
#   --dry-run           print planned changes only
#   --message-suffix S  append S to the commit message (e.g. " [skip ci]")
#
# Updates version fields in:
#   .claude-plugin/plugin.json        .version
#   .claude-plugin/marketplace.json   .plugins[0].version
#   .agents/plugins/marketplace.json  .plugins[0].version   (added if missing)
#
# Then creates commit "chore: bump version to vX.Y.Z" and annotated tag vX.Y.Z.
# Does not push — prints the push command for you to run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

MANIFESTS=(
  ".claude-plugin/plugin.json::.version"
  ".claude-plugin/marketplace.json::.plugins[0].version"
  ".agents/plugins/marketplace.json::.plugins[0].version"
)

CANONICAL=".claude-plugin/plugin.json"
CANONICAL_JQ=".version"

usage() {
  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//' >&2
  exit 2
}

no_commit=0
allow_dirty=0
dry_run=0
message_suffix=""
positional=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-commit)       no_commit=1; shift;;
    --allow-dirty)     allow_dirty=1; shift;;
    --dry-run)         dry_run=1; shift;;
    --message-suffix)  [[ $# -ge 2 ]] || { echo "error: --message-suffix needs a value" >&2; exit 2; }
                       message_suffix="$2"; shift 2;;
    -h|--help)         usage;;
    --) shift; positional+=("$@"); break;;
    -*) echo "error: unknown flag: $1" >&2; usage;;
    *) positional+=("$1"); shift;;
  esac
done
set -- "${positional[@]:-}"

[[ $# -ge 1 && -n "${1:-}" ]] || usage
mode="$1"; shift

command -v jq >/dev/null || { echo "error: jq is required (brew install jq)" >&2; exit 1; }

read_version() {
  jq -r "${2} // empty" "$ROOT/$1"
}

current="$(read_version "$CANONICAL" "$CANONICAL_JQ")"
if [[ -z "$current" ]]; then
  echo "error: could not read version from $CANONICAL" >&2
  exit 1
fi

for entry in "${MANIFESTS[@]}"; do
  f="${entry%%::*}"; p="${entry##*::}"
  v="$(read_version "$f" "$p")"
  if [[ -n "$v" && "$v" != "$current" ]]; then
    echo "warning: $f has $v (canonical: $current)" >&2
  fi
done

if [[ "$mode" == "show" ]]; then
  echo "$current"
  exit 0
fi

if [[ "$mode" == "changed" ]]; then
  base="${1:-HEAD~1}"
  head="${2:-HEAD}"
  changed="$(git -C "$ROOT" diff --name-only "$base" "$head" -- \
    'skills' 'commands' 'mcp.json' '.claude-plugin' '.agents' 2>/dev/null || true)"
  if [[ -n "$changed" ]]; then
    echo "shipping-path changes between $base..$head:"
    echo "$changed" | sed 's/^/  /'
    exit 0
  fi
  echo "no shipping-path changes between $base..$head (only README/scripts/.github)"
  exit 1
fi

IFS=. read -r maj min pat <<<"$current"
case "$mode" in
  patch) pat=$((pat+1));;
  minor) min=$((min+1)); pat=0;;
  major) maj=$((maj+1)); min=0; pat=0;;
  set)
    [[ $# -ge 1 ]] || { echo "error: 'set' needs a version argument" >&2; exit 2; }
    new="$1"
    semver_re='^[0-9]+\.[0-9]+\.[0-9]+$'
    [[ "$new" =~ $semver_re ]] || { echo "error: version must be X.Y.Z" >&2; exit 2; }
    maj="${new%%.*}"; rest="${new#*.}"; min="${rest%%.*}"; pat="${rest#*.}"
    ;;
  *) usage;;
esac
new_version="${maj}.${min}.${pat}"

if [[ "$new_version" == "$current" ]]; then
  echo "nothing to do (already at $current)" >&2
  exit 0
fi

echo "bumping: $current -> $new_version"

if [[ "$allow_dirty" -eq 0 && -n "$(git -C "$ROOT" status --porcelain)" ]]; then
  echo "error: working tree is dirty (use --allow-dirty to override)" >&2
  git -C "$ROOT" status --short >&2
  exit 1
fi

if git -C "$ROOT" rev-parse -q --verify "refs/tags/v${new_version}" >/dev/null; then
  echo "error: tag v${new_version} already exists" >&2
  exit 1
fi

if [[ "$dry_run" -eq 1 ]]; then
  echo "[dry-run] would update:"
  for entry in "${MANIFESTS[@]}"; do
    echo "  ${entry%%::*}  (${entry##*::})"
  done
  echo "[dry-run] would commit and tag v${new_version}"
  exit 0
fi

for entry in "${MANIFESTS[@]}"; do
  f="${entry%%::*}"; p="${entry##*::}"
  tmp="$(mktemp)"
  jq --indent 2 "$p = \"$new_version\"" "$ROOT/$f" > "$tmp"
  mv "$tmp" "$ROOT/$f"
  echo "  updated $f"
done

if [[ "$no_commit" -eq 1 ]]; then
  echo "done (files updated; commit/tag skipped per --no-commit)"
  exit 0
fi

for entry in "${MANIFESTS[@]}"; do
  git -C "$ROOT" add "${entry%%::*}"
done
git -C "$ROOT" commit -m "chore: bump version to v${new_version}${message_suffix}"
git -C "$ROOT" tag -a "v${new_version}" -m "v${new_version}"

echo
echo "committed and tagged v${new_version}"
echo "to publish:"
echo "  git push origin HEAD"
echo "  git push origin v${new_version}"
