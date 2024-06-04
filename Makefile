run:
	opam exec -- dune exec ocaml_crdt

deps:
	dune build
	opam install . --deps-only

.PHONEY: run deps
