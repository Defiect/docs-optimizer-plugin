#!/usr/bin/env bash
set -euo pipefail

REVIEWS_DIR=".claude/reviews"
ARCHIVE_DIR="/tmp/docs-optimizer-archive-$$"

# Only act if reviews directory exists and has .md files
if [ -d "$REVIEWS_DIR" ] && ls "$REVIEWS_DIR"/*.md &>/dev/null; then
    mkdir -p "$ARCHIVE_DIR"
    # Move all review .md files (but NOT test-questions or state files)
    for f in "$REVIEWS_DIR"/*-review*.md "$REVIEWS_DIR"/*-conciseness*.md; do
        [ -f "$f" ] && mv "$f" "$ARCHIVE_DIR/"
    done
    # Record archive path for post-hook
    echo "$ARCHIVE_DIR" > "$REVIEWS_DIR/.archive-path"
fi
