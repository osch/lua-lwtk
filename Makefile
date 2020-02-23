.PHONY: default rockspec

default: rockspec

rockspec:
	$(call UPDATE_ROCK, lwtk-scm-0.rockspec)
	
define UPDATE_ROCK
	@echo Updating $1
	@cd src/lwtk; ls *.lua internal/*.lua > ../../.files
	@lua scripts/substmodules.lua $1 .files
endef