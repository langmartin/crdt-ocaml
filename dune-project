(lang dune 3.15)

(name ocaml_crdt)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ocaml_crdt)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  dune
  h2-lwt-unix
  capnp-rpc-lwt
  cmdliner)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
