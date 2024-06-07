let client _host key value =
  if key == "" then `Error (false, "client key required")
  else
    `Ok (Printf.printf "hello client: %s %s" key value)

let server _listen bootstrap =
  if bootstrap == "" then `Error (false, "server bootstrap host required")
  else
    `Ok (Printf.printf "hello server: %s" bootstrap)

let start listen bootstrap host key value =
  match listen with
  | "" -> client host key value
  | _ -> server listen bootstrap

open Cmdliner

(* Server options *)
let listen =
  let doc = "listen[:port] to listen for peer and client queries. [port] defaults to 3903. Starts the server." in
  let env = Cmd.Env.info "MPOM_LISTEN" ~doc in
  Arg.(value & opt string "" & info ["listen"] ~env ~docv:"LISTEN" ~doc)

let bootstrap =
  let doc = "host[:port] to query. Ignored in server mode." in
  let env = Cmd.Env.info "MPOM_BOOTSTRAP" ~doc in
  Arg.(value & opt string "" & info ["bootstrap"] ~env ~docv:"BOOTSTRAP" ~doc)

(* Client options *)
let host =
  let doc = "host[:port] to query. Ignored in server mode." in
  let env = Cmd.Env.info "MPOM_HOST" ~doc in
  Arg.(value & opt string "localhost:3903" & info ["h"; "host"] ~env ~docv:"HOST" ~doc)

let key =
  let doc = "Key to get or, with optional value, store." in
  let env = Cmd.Env.info "MPOM_KEY" ~doc in
  Arg.(value & pos 0 string "" & info [] ~env ~docv:"KEY" ~doc)

let value =
  let doc = "Value to get or, with optional value, store." in
  let env = Cmd.Env.info "MPOM_VALUE" ~doc in
  Arg.(value & pos 1 string "" & info [] ~env ~docv:"VALUE" ~doc)

(* Cmd *)
let start_t = Term.(ret (const start $ listen $ bootstrap $ host $ key $ value))

let cmd =
  let doc = "print a customizable message repeatedly" in
  let man = [
    `S Manpage.s_bugs;
    `P "Email bug reports to <bugs@example.org>." ]
  in
  let info = Cmd.info "start" ~version:"%‌%VERSION%%" ~doc ~man in
  Cmd.v info start_t

let main () = exit (Cmd.eval cmd)
let () = main ()
