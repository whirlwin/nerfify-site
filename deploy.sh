#!/usr/bin/env bash
# Publish this repo's content to the `pages` branch on the configured remote.
# Codeberg Pages serves the root of that branch at
#   https://<user>.codeberg.page/<repo>/
# and at any host listed in .domains once DNS is in place.
#
# Usage:
#   ./deploy.sh                 # uses remote "origin"
#   REMOTE=codeberg ./deploy.sh
set -euo pipefail

REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-pages}"

repo_root="$(git rev-parse --show-toplevel)"

if ! git -C "$repo_root" ls-remote --exit-code "$REMOTE" >/dev/null 2>&1; then
  printf 'Remote %q not found.\n' "$REMOTE" >&2
  exit 1
fi

short_sha="$(git -C "$repo_root" rev-parse --short HEAD 2>/dev/null || echo initial)"
name="$(git -C "$repo_root" config user.name  || echo deploy)"
email="$(git -C "$repo_root" config user.email || echo deploy@localhost)"
remote_url="$(git -C "$repo_root" remote get-url "$REMOTE")"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Stage the served tree (exclude source-only files).
( cd "$repo_root" \
    && tar --exclude=./.git \
           --exclude=./deploy.sh \
           --exclude=./README.md \
           --exclude=./AGENTS.md \
           --exclude=./CLAUDE.md \
           --exclude=./.gitignore \
           --exclude='./.DS_Store' \
           -cf - . ) \
  | ( cd "$tmp" && tar -xf - )

cd "$tmp"
git init -q -b "$BRANCH"
git add .
GIT_AUTHOR_NAME="$name" GIT_AUTHOR_EMAIL="$email" \
GIT_COMMITTER_NAME="$name" GIT_COMMITTER_EMAIL="$email" \
  git commit -q -m "deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ) ($short_sha)"
git remote add up "$remote_url"
git push --force up "$BRANCH:$BRANCH"

printf 'Deployed to %s/%s\n' "$REMOTE" "$BRANCH"
