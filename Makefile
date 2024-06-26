sources = $(wildcard lib/*.ml lib/*.mli)

build: $(sources) schema.capnp
	dune build

run: build
	opam exec -- dune exec ocaml_crdt

deps: lib/.ocamlinit
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.ocamlinit: .ocamlinit-template
	sed 's|$$HOME|$(HOME)|g' $^ > $@

lib/.ocamlinit: .ocamlinit
	(cd lib; ln -sf ../.ocamlinit)

.PHONEY: run build deps
