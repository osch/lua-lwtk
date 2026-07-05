LUA ?= lua5.4

.PHONY: default all doc doctest alltests

default: doc doctest

all: doc doctest alltests

doc:
	$(LUA) mkdoc/main.lua

doctest:
	$(LUA) doctest.lua

alltests:
	$(LUA) alltests.lua
