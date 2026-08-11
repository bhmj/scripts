#!/bin/sh
# Merge repo .vimrc lines into current user's ~/.vimrc.
# Existing lines are left untouched; only missing lines are appended (no duplicates).

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SOURCE="$REPO_ROOT/.vimrc"

if [ ! -f "$SOURCE" ]; then
	echo "error: $SOURCE not found" >&2
	exit 1
fi

home=${HOME:-$(eval echo "~$(id -un)")}
dest="$home/.vimrc"

touch "$dest"

added=0
while IFS= read -r line || [ -n "$line" ]; do
	# Skip blank lines — avoid stacking empty separators on re-install
	if [ -z "$line" ]; then
		continue
	fi
	if ! grep -Fxq -- "$line" "$dest" 2>/dev/null; then
		printf '%s\n' "$line" >> "$dest"
		added=$((added + 1))
	fi
done < "$SOURCE"

if [ "$added" -eq 0 ]; then
	echo "All .vimrc lines already present in $dest — skipping"
else
	echo "Appended $added line(s) to $dest"
fi
