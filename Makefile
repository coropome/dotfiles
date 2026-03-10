SHELL := /bin/bash

.PHONY: install uninstall doctor mac keyboard update agent help lint test \
        defaults ssh git-config upgrade lock dock install-preflight \
        install-packages install-links install-plugins verify-bootstrap \
        ansible-syntax sync-package-artifacts

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Bootstrap:"
	@echo "  install           install core brew packages and link dotfiles"
	@echo "  install-preflight verify bootstrap prerequisites only"
	@echo "  install-packages  install core Homebrew packages only"
	@echo "  install-links     back up and relink managed dotfiles only"
	@echo "  install-plugins   install/update tmux plugins and verify state"
	@echo "  uninstall         remove symlinks and restore backups"
	@echo "  doctor            check tools and dotfile symlinks"
	@echo ""
	@echo "macOS setup:"
	@echo "  mac               install apps and CLIs via Homebrew"
	@echo "  defaults          apply macOS defaults (Finder/Dock/Screenshot etc.)"
	@echo "  keyboard          tweak key repeat / Caps→Ctrl (optional)"
	@echo "  dock              reset Dock to managed apps via dockutil (asks confirmation)"
	@echo "  ssh               generate SSH key and configure for GitHub"
	@echo "  git-config        set git user.name / user.email from ansible/local.yml"
	@echo ""
	@echo "Maintenance:"
	@echo "  update            pull latest changes and re-link"
	@echo "  agent             install Claude Code + Gemini + Codex CLIs"
	@echo "  lint              shellcheck all scripts"
	@echo "  test              run local install/uninstall integration tests"
	@echo "  upgrade           upgrade managed brew packages/casks and cleanup"
	@echo "  lock              dump Brewfile.lock (brew bundle dump)"
	@echo "  ansible-syntax    run Ansible preflight and syntax-check the playbook"
	@echo "  sync-package-artifacts  regenerate committed package compatibility files"
	@echo ""
	@echo "Quickstart: make install && open a new terminal && tnew"
	@echo "Support: macOS-first bootstrap. Linux/WSL are best-effort manual setups; see docs/31-support-matrix.md"

install:
	./install.sh

install-preflight:
	./install.sh --phase preflight

install-packages:
	./install.sh --phase preflight --phase packages

install-links:
	./install.sh --phase preflight --phase backup --phase links --phase git --phase helpers

install-plugins:
	./install.sh --phase preflight --phase plugins --phase verify

verify-bootstrap:
	./install.sh --phase preflight --phase verify

uninstall:
	./uninstall.sh

doctor:
	./doctor.sh

# mac: install apps/tools via Homebrew (safe default)
mac:
	./ansible/run.sh --tags brew

# keyboard: tweak key repeat / modifier keys (optional)
keyboard:
	./ansible/run.sh --tags keyboard

# update: pull latest and re-link
update:
	git pull --ff-only origin main
	./install.sh

# agent: install Claude Code + Gemini + Codex and check readiness
agent:
	@set -e; \
	while IFS= read -r pkg || [ -n "$$pkg" ]; do \
		case "$$pkg" in \
			''|\#*) continue ;; \
		esac; \
		echo "==> Installing $$pkg..."; \
		npm install -g "$$pkg"; \
	done < manifests/packages/agent-npm.txt
	@echo "==> Running doctor check..."
	./doctor.sh

# lint: shellcheck all shell scripts
lint:
	@command -v shellcheck >/dev/null 2>&1 || { echo "shellcheck not found (run: make install)"; exit 1; }
	shellcheck -x install.sh uninstall.sh doctor.sh bin/tnew bin/thelp bin/tlist bin/tgo bin/tkill bin/_tpick bin/ttutor bin/p bin/_platform bin/_clipboard_copy bin/_open bin/_tmux_help bin/render-brewfile bin/render-ansible-package-vars ansible/run.sh test/install_uninstall.sh test/git_config.sh test/p.sh test/ansible_run.sh test/compatibility_helpers.sh test/repository_structure.sh test/package_inventory.sh test/zsh_portability.sh test/doctor_platform.sh

# test: run local integration checks in a temporary HOME
test:
	./test/package_inventory.sh
	./test/repository_structure.sh
	./test/install_uninstall.sh
	./test/git_config.sh
	./test/p.sh
	./test/ansible_run.sh
	./test/compatibility_helpers.sh
	./test/zsh_portability.sh
	./test/doctor_platform.sh

# defaults: macOS defaults (Finder / Dock / Screenshot etc.)
defaults:
	./ansible/run.sh --tags defaults

# ssh: SSH鍵の生成・GitHub登録
ssh:
	./ansible/run.sh --tags ssh

# git-config: git user.name / user.email を設定
git-config:
	./ansible/run.sh --tags git-config

# upgrade: brew outdated / upgrade / cleanup
upgrade:
	./ansible/run.sh --tags upgrade

# lock: Brewfile.lock を生成
lock:
	brew bundle dump --force --file=Brewfile.lock

# dock: Dock アプリ配置を設定
dock:
	./ansible/run.sh --tags dock

ansible-syntax:
	./ansible/run.sh --phase preflight --phase collections --phase playbook --syntax-check

sync-package-artifacts:
	./bin/render-brewfile > Brewfile
	./bin/render-ansible-package-vars > ansible/vars/packages.yml
