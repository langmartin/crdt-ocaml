sources = $(wildcard lib/*.ml lib/*.mli)

run: build
	opam exec -- dune exec ocaml_crdt

build: $(sources) schema.capnp
	dune build

deps: /opt/homebrew/bin/capnp
	dune build
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.PHONEY: run build deps
