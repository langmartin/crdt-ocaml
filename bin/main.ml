module Cmd = struct
  type t = {
      listen : string;
      bootstrap : string;
      hostname : string;
      token : string;
    }

  let usage() = "peerstack [--listen host:port] [--boostrap host:port]
listen        Start a peer listening on host and port
bootstrap     Peer to use to bootstrap our state
"

  let parse () =
    let listen = ref 0 in
    let bootstrap = ref 1 in
    let hostname = ref 2 in
    let token = ref 3 in
    let specs = [
        "--listen",
      ]
end



open Core

let command =
  Command.basic
    ~summary:"Peer stack"
(Command.Param.map

let () = print_endline "Hello, World!"
