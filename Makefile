sources = $(wildcard lib/*.ml lib/*.mli)

build: $(sources) schema.capnp
	dune build

run: build
	opam exec -- dune exec ocaml_crdt

deps: /opt/homebrew/bin/capnp
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.PHONEY: run build deps
