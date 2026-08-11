#!/bin/sh
# Append a text block to the current user's shell RC.
#
# Usage: append-shellrc.sh MARKER SOURCE_FILE
#   MARKER       unique string; if already present in the RC, do nothing
#   SOURCE_FILE  file whose contents are appended under a "# --- MARKER ---" header

set -eu

usage() {
	echo "Usage: $0 MARKER SOURCE_FILE" >&2
	exit 1
}

[ $# -eq 2 ] || usage

MARKER=$1
SOURCE=$2

if [ ! -f "$SOURCE" ]; then
	echo "error: $SOURCE not found" >&2
	exit 1
fi

home=${HOME:-$(eval echo "~$(id -un)")}
user=$(id -un)

shell=
if command -v getent >/dev/null 2>&1; then
	shell=$(getent passwd "$user" | cut -d: -f7)
fi
if [ -z "$shell" ] && [ "$(uname -s)" = Darwin ]; then
	shell=$(dscl . -read "/Users/$user" UserShell 2>/dev/null | awk '{print $2}')
fi
if [ -z "$shell" ]; then
	shell=$(awk -F: -v u="$user" '$1==u {print $7; exit}' /etc/passwd 2>/dev/null || true)
fi

case "$(basename "${shell:-}")" in
	zsh)  rc="$home/.zshrc" ;;
	bash) rc="$home/.bashrc" ;;
	ksh)  rc="$home/.kshrc" ;;
	*)
		if [ -f "$home/.zshrc" ]; then rc="$home/.zshrc"
		elif [ -f "$home/.bashrc" ]; then rc="$home/.bashrc"
		elif [ -f "$home/.kshrc" ]; then rc="$home/.kshrc"
		else rc="$home/.profile"
		fi
		;;
esac

touch "$rc"

if grep -qF "$MARKER" "$rc" 2>/dev/null; then
	echo "Already present in $rc ($MARKER) — skipping"
	exit 0
fi

{
	printf '\n# --- %s ---\n' "$MARKER"
	cat "$SOURCE"
	printf '\n'
} >> "$rc"

echo "Appended to $rc: $MARKER"
