#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

alias i := install

@default:
	just --list

install-pre-commit:
    pre-commit install

install: install-pre-commit

alias prc := pre-commit
pre-commit:
    pre-commit run

alias prca := pre-commit-all
pre-commit-all:
    pre-commit run --all-files
