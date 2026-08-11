#!/bin/sh
# Install dps.py into ~/.local/lib/bhmj-scripts.

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SOURCE="$REPO_ROOT/dps.py"

if [ ! -f "$SOURCE" ]; then
	echo "error: $SOURCE not found" >&2
	exit 1
fi

home=${HOME:-$(eval echo "~$(id -un)")}
dest_dir="$home/.local/lib/bhmj-scripts"
dest="$dest_dir/dps.py"

mkdir -p "$dest_dir"
cp "$SOURCE" "$dest"

echo "Installed $dest"
