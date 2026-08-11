#!/bin/sh
# Append aliases to the invoking user's shell RC.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

exec sh "$SCRIPT_DIR/append-shellrc.sh" \
	"bhmj/scripts shell aliases" \
	"$SCRIPT_DIR/shell-aliases.sh"
