# AI — Universal Agent Skills Suite (https://github.com/luishrmc/ai)
.PHONY: all list install-global link-global install-claude link-claude install-project

TARGET ?= $(HOME)/.gemini/config/skills

all: list

list:
	@./install.sh --list

install-global:
	@./install.sh --global-gemini --copy

link-global:
	@./install.sh --global-gemini --symlink

install-claude:
	@./install.sh --global-claude --copy

link-claude:
	@./install.sh --global-claude --symlink

install-project:
	@./install.sh --project-agents --copy
