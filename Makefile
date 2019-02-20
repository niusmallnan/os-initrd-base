TARGETS := $(shell ls scripts | grep -vE 'clean|build-busybox|entry|package')

.dapper:
	@echo Downloading dapper
	@curl -sL https://releases.rancher.com/dapper/latest/dapper-`uname -s`-`uname -m` > .dapper.tmp
	@@chmod +x .dapper.tmp
	@./.dapper.tmp -v
	@mv .dapper.tmp .dapper

$(TARGETS): .dapper
	./.dapper $@

shell-bind: .dapper
	./.dapper -m bind -s

amd64: .dapper
	PLATFORM=amd64 ./.dapper release

arm64: .dapper
	PLATFORM=arm64 ./.dapper release

rpi64: .dapper
	PLATFORM=rpi64 ./.dapper release

clean:
	@./scripts/clean

.DEFAULT_GOAL := ci

.PHONY: $(TARGETS)
