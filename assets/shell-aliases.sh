alias dlog='docker logs'
alias kpods='kubectl get pods'
alias kexec='kubectl exec -it'
alias klog='kubectl logs'
alias kstop='kubectl delete pod'

dps () {
	docker ps -a "$@" | python3 "$HOME/.local/lib/bhmj-scripts/dps.py"
}

dstop () {
	docker stop "$@" 2>/dev/null
	docker rm "$@" 2>/dev/null
}

mksh () {
	if [ ! $# -eq 1 ]; then
		echo 'Usage: mksh script_name [editor]' 1>&2
		return 1
	elif [ -e "$1" ]; then
		echo "$1 already exists" 1>&2
		return 1
	fi

	printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' '' > "$1"
	chmod u+x "$1"

	EDITOR=${2:-vim}
	"$EDITOR" "$1"
}
