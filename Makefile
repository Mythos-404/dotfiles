SYSTEMS := $(basename $(notdir $(wildcard systems/*.nix)))

TRACE ?= 
TRACE_FLAG := $(if $(TRACE),--show-trace,)

list:
	@echo "Available systems:"
	@$(foreach system,$(SYSTEMS), \
		[[ -f "systems/$(system).nix" ]] && \
		echo "  $(system) - $(shell head -5 systems/$(system).nix | grep -o 'hostName.*' | cut -d '"' -f2)"; \
	)
.PHONY: list

$(SYSTEMS):
	@echo "构建并切换系统: $@"
	sudo nixos-rebuild switch --flake .#$@ $(TRACE_FLAG)
.PHONY: $(SYSTEMS)

$(addprefix boot-,$(SYSTEMS)):
	@echo "构建系统: $(patsubst boot-%,%,$@)"
	sudo nixos-rebuild boot --flake .#$(patsubst boot-%,%,$@) $(TRACE_FLAG)
.PHONY: $(addprefix boot-,$(SYSTEMS))

$(addprefix test-,$(SYSTEMS)):
	@echo "测试系统: $(patsubst test-%,%,$@)"
	sudo nixos-rebuild test --flake .#$(patsubst test-%,%,$@) $(TRACE_FLAG)
.PHONY: $(addprefix test-,$(SYSTEMS))

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