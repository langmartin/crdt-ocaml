sources = $(wildcard lib/*.ml lib/*.mli)

build: $(sources) schema.capnp lib/.ocamlinit
	dune build

run: build
	opam exec -- dune exec ocaml_crdt

deps: /opt/homebrew/bin/capnp
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.ocamlinit: .ocamlinit-template Makefile
	eval echo `cat $^` > $@

lib/.ocamlinit: .ocamlinit
	(cd lib; ln -sf ../.ocamlinit)

.PHONEY: run build deps
