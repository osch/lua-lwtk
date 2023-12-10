.PHONY: default doc test doctest

default: doc doctest

doc:
	lua mkdoc/main.lua

test: doctest

doctest:
	lua doctest.lua $(sort $(wildcard ../doc/*.md))
