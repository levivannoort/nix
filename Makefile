UNAME       := $(shell uname -s)
HOSTNAME    ?= $(shell hostname -s)
NIX         := nix --extra-experimental-features "nix-command flakes"

ifeq ($(UNAME),Darwin)
ATTR := darwinConfigurations.$(HOSTNAME).system
else
ATTR := nixosConfigurations.$(HOSTNAME).config.system.build.toplevel
endif

.PHONY: help build switch check fmt fmt-check lint update gc repl clean

help: ## Show this help message
	@grep -hE '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

build: ## Build this host's configuration without activating it
	$(NIX) build ".#$(ATTR)" --show-trace

switch: ## Build and activate this host's configuration
ifeq ($(UNAME),Darwin)
	sudo $(NIX) run nix-darwin -- switch --flake ".#$(HOSTNAME)" --show-trace
else
	sudo nixos-rebuild switch --flake ".#$(HOSTNAME)" --show-trace
endif

check: ## Evaluate every host defined in the flake
	$(NIX) flake check --show-trace

NIX_FILES := $(shell find . -name '*.nix' -not -path './.git/*')

# Uses the flake's own `formatter` output, so the version is pinned by
# flake.lock rather than tracking whatever nixpkgs#nixfmt happens to be today.
fmt: ## Format all Nix files
	$(NIX) fmt -- $(NIX_FILES)

fmt-check: ## Fail if any Nix file is unformatted
	$(NIX) fmt -- --check $(NIX_FILES)

lint: ## Find dead code and anti-patterns
	$(NIX) run nixpkgs#deadnix -- --fail $(NIX_FILES)
	$(NIX) run nixpkgs#statix -- check .

update: ## Update all flake inputs
	$(NIX) flake update --commit-lock-file

gc: ## Delete generations older than 30 days and optimise the store
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	$(NIX) store optimise

repl: ## Open a repl with the flake loaded
	$(NIX) repl .

clean: ## Remove build result symlinks
	rm -f result result-*
