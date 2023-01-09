LOCAL_BIN ?= /usr/local/bin
export PWD ?= $(shell pwd)
export DAT ?= $$@

define USAGE

Usage: make <target>

some of the <targets> are:

  list                 - list scripts
  install              - install scripts (NEED ROOT ACCESS)

NB: `sudo make install` for actual installation

endef
export USAGE

define LIST

BHMJ's useful script bundle
Installed in /usr/local/bin

	dps    = docker ps condensed (Python 3 required)
	dlog   = docker log
	dstop  = docker stop && docker rm
	kpods  = kubectl get pods
	kexec  = kubectl exec -it
	klog   = kubectl logs
	kstop  = kubectl delete pod

endef
export LIST

help:
	@echo "$$USAGE"

list:
	echo "$$LIST"

install:
	echo "docker ps -a $$DAT | python3 $$PWD/dps.py" > /usr/local/bin/dps
	echo "docker logs $$DAT" > /usr/local/bin/dlog
	echo "docker stop $$DAT" 2>/dev/null > /usr/local/bin/dstop && echo "docker rm $$DAT" 2>/dev/null >> /usr/local/bin/dstop
	echo "kubectl get pods $$DAT" > /usr/local/bin/kpods
	echo "kubectl exec -it $$DAT" > /usr/local/bin/kexec
	echo "kubectl logs $$DAT" > /usr/local/bin/klog
	echo "kubectl delete pod $$DAT" > /usr/local/bin/kstop
	chmod +x /usr/local/bin/dps
	chmod +x /usr/local/bin/dlog
	chmod +x /usr/local/bin/dstop
	chmod +x /usr/local/bin/kpods
	chmod +x /usr/local/bin/kexec
	chmod +x /usr/local/bin/klog
	chmod +x /usr/local/bin/kstop

.PHONY: help list install

$(V).SILENT:
