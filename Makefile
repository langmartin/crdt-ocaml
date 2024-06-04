sources = $(wildcard lib/*.ml lib/*.mli)

run: build
	opam exec -- dune exec ocaml_crdt

build: /opt/homebrew/bin/capnp $(sources)
	dune build

deps:
	dune build
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.PHONEY: run build deps
