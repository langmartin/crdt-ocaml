open H2

let reply_text code text reqd =
  let headers = Headers.of_list
      [ "content-length", string_of_int (String.length text) ]
  in
  Reqd.respond_with_string reqd (Response.create ~headers (`Code code)) text

let request_handler _client_address reqd =
  let { Request.meth; target; _ } = Reqd.request reqd in
  match meth with
  | `GET ->
    let path = String.split_on_char '/' target in
    (match path with
     | ["list"; list; "item"; item] ->
       (match World.ae_get_opt(list ^ item) with
        | Some value -> reply_text 200 value reqd
        | None -> reply_text 404 "not found" reqd)
     | _ -> reply_text 404 "not found" reqd)

  | _ ->
    reply_text 405 "method not allowed" reqd

let error_handler _client_address ?request:_ _error start_response =
  let response_body = start_response Headers.empty in
  Body.Writer.write_string
    response_body
    "error\n";
  Body.Writer.close response_body

let () =
  let connection_handler =
    H2_lwt_unix.Server.create_connection_handler
      ?config:None
      ~request_handler
      ~error_handler
  in
  let listen_address = Unix.(ADDR_INET (inet_addr_loopback, 8080)) in
  let _server =
    Lwt_io.establish_server_with_client_socket listen_address connection_handler
  in
  let forever, _ = Lwt.wait () in
  Lwt_main.run forever
