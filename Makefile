sources = $(wildcard lib/*.ml lib/*.mli)

build: $(sources) schema.capnp
	dune build

test: build
	dune runtest

run: build
	opam exec -- dune exec ocaml_crdt

deps: /opt/homebrew/bin/capnp lib/.ocamlinit
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

lib/.ocamlinit:
	echo 'open Ocaml_crdt;;' > $@

.PHONEY: run build deps
