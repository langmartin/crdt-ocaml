(lang dune 3.15)

(name ocaml_crdt)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license "AGPL-3.0-or-later")

(documentation https://url/to/documentation)

(package
 (name ocaml_crdt)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  alcotest
  base64
  capnp-rpc-unix
  capnp-rpc-lwt
  checkseum
  cmdliner
  dune
  h2-lwt-unix
  ocaml
  sqlite3)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
