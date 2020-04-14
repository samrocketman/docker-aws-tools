include Makefile.alternate

.PHONY: build clean help requirements test

help:
	@echo 'The following make commands are available'
	@echo '    make cli   - shows a CLI.'
	@echo '    make gui   - shows a VS Code editor (requires X11 or XQuartz on Mac).'
	@echo '    make test  - runs infra tests against the aws-tools docker image.'
	@echo '    make clean - Removes docker image created.'

clean:
	docker rmi aws-tools
	@echo 'Also run "docker image prune" for additional cleanup.'

requirements:
	@/bin/bash -lc 'type docker' > /dev/null || (echo 'ERROR: Docker needs to be installed.  If on Mac OS X, install Docker for Mac.' >&2; false)

build: requirements
	docker build . -t aws-tools

test: build
	docker run --rm -iu root aws-tools /usr/local/bin/goss -g - validate < goss.yaml
