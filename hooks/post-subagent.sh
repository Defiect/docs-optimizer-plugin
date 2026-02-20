#!/usr/bin/env bash
set -euo pipefail

REVIEWS_DIR=".claude/reviews"
ARCHIVE_POINTER="$REVIEWS_DIR/.archive-path"

# Restore archived reviews if they exist
if [ -f "$ARCHIVE_POINTER" ]; then
    ARCHIVE_DIR=$(cat "$ARCHIVE_POINTER")
    if [ -d "$ARCHIVE_DIR" ]; then
        mv "$ARCHIVE_DIR"/*.md "$REVIEWS_DIR/" 2>/dev/null || true
        rmdir "$ARCHIVE_DIR" 2>/dev/null || true
    fi
    rm -f "$ARCHIVE_POINTER"
fi
