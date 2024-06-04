schema = schema/schema.ml
sources = $(wildcard lib/*.ml lib/*.mli)

run: build
	opam exec -- dune exec ocaml_crdt

build: $(sources) $(schema)
	dune build

schema/schema.ml: schema/schema.capnp
	cd schema; capnp compile $(notdir $<) -o ocaml

deps: /opt/homebrew/bin/capnp
	dune build
	opam install . --deps-only

/opt/homebrew/bin/capnp:
	brew install capnp

.PHONEY: run build deps
