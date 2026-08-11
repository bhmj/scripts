#!/bin/sh
# Append git-diff.sh helpers to the invoking user's shell RC.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

exec sh "$SCRIPT_DIR/append-shellrc.sh" \
	"bhmj/scripts git-diff helpers" \
	"$REPO_ROOT/git-diff.sh"
