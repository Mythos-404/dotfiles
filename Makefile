SYSTEMS := $(basename $(notdir $(wildcard systems/*.nix)))

list:
	@echo "Available systems:"
	@$(foreach system,$(SYSTEMS), \
		[[ -f "systems/$(system).nix" ]] && \
		echo "  $(system) - $(shell head -5 systems/$(system).nix | grep -o 'hostName.*' | cut -d '"' -f2)"; \
	)
.PHONY: list

$(SYSTEMS):
	@echo "构建系统: $@"
	sudo nixos-rebuild switch --flake ./#$@ --show-trace
.PHONY: $(SYSTEMS)

update:
	@if [ -n "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "更新指定 flake input: $(filter-out $@,$(MAKECMDGOALS))"; \
		nix flake update $(filter-out $@,$(MAKECMDGOALS)); \
	else \
		echo "更新所有 flake inputs"; \
		nix flake update; \
	fi
.PHONY: update

gc:
	sudo nix-collect-garbage --delete-older-than 7d
	nix-collect-garbage --delete-older-than 7d
.PHONY: gc

repl:
	nix repl -f flake:nixpkgs
.PHONY: repl

format:
	alejandra ./
.PHONY: format

%:
	@: