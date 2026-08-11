export PWD ?= $(shell pwd)

define USAGE

Usage: make <target>

some of the <targets> are:

  list                 - list scripts
  install              - install scripts + shell helpers

endef
export USAGE

define LIST

BHMJ's useful script bundle

Will be installed in ~/.local/lib/bhmj-scripts

	dps.py = helper for dps (Python 3 required)

Will be added in your shell profile:

	dps             = docker ps condensed (Python 3 required)
	dlog            = docker log
	dstop           = docker stop && docker rm
	kpods           = kubectl get pods
	kexec           = kubectl exec -it
	klog            = kubectl logs
	kstop           = kubectl delete pod
	mksh            = create bash script and open it in editor
	git-diff        = git diff condensed with line counts
	git-diff-total  = git diff with total line counts

endef
export LIST

help:
	@echo "$$USAGE"

list:
	echo "$$LIST"

install:
	sh "$(PWD)/assets/install-vimrc.sh"
	sh "$(PWD)/assets/install-dps.sh"
	sh "$(PWD)/assets/install-shell-aliases.sh"
	sh "$(PWD)/assets/install-git-diff.sh"

.PHONY: help list install

$(V).SILENT:
