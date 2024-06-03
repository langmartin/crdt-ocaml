open H2

(* This is our request handler. H2 will invoke this function whenever the
 * client send a request to our server. *)
let request_handler _client_address reqd =
  (* `reqd` is a "request descriptor". Conceptually, it's just a reference to
   * the request that the client sends, which allows us to do two things:
   *
   * 1. Get more information about the request that we're handling. In our
   *    case, we're inspecting the method and the target of the request, but we
   *    could also look at the request headers.
   *
   * 2. A request descriptor is also what allows us to respond to this
   *    particular request by passing it into one of the response functions
   *    that we will look at below. *)
  let { Request.meth; target; _ } = Reqd.request reqd in
  match meth with
  | `GET ->
    let response_body =
      Printf.sprintf "You made a request to the following resource: %s\n" target
    in
    (* Specify the length of the response body. Two notes to make here:
     *
     * 1. Specifying the content length of a response is optional since HTTP/2
     *    is a binary protocol based on frames which carry information about
     *    whether a frame is the last for a given stream.
     *
     * 2. In HTTP/2, all header names are required to be lowercase. We use
     *    `content-length` instead of what might be commonly seen in HTTP/1.X
     *    (`Content-Length`). *)
    let headers =
      Headers.of_list
        [ "content-length", string_of_int (String.length response_body) ]
    in
    (* Respond immediately with the response body we constructed above,
     * finishing the request/response exchange (and the unerlying HTTP/2
     * stream).
     *
     * The other functions in the `Reqd` module that allow sending a response
     * to the client are `Reqd.respond_with_bigstring`, that only differs from
     * `Reqd.respond_with_string` in that the response body should be a
     * bigarray, and `Reqd.respond_with_streaming` (see
     * http://anmonteiro.com/ocaml-h2/h2/H2/Reqd/index.html#val-respond_with_streaming)
     * which starts streaming a response body which can be written to
     * asynchronously to the client. *)
    Reqd.respond_with_string reqd (Response.create ~headers `OK) response_body
  | meth ->
    let response_body =
      Printf.sprintf
        "This server does not respond to %s methods.\n"
        (Method.to_string meth)
    in
    Reqd.respond_with_string
      reqd
      (* We don't include any headers in this case. The HTTP/2 framing layer
       * knows that these will be last frames in the exchange. *)
      (Response.create `Method_not_allowed)
      response_body

(* This is our error handler. Everytime H2 sees a malformed request or an
 * exception on a specific stream, it will invoke this function to send a
 * response back to the misbehaving client. Because there might not be a
 * request for the stream (handing malformed requests to the application is
 * strongly discouraged), there is also no request descriptor like we saw in
 * the request handler above. In this case, one of the arguments to this
 * function is a function that will start the response. It has the following
 * signature:
 *
 *   val start_response : H2.headers.t -> [`write] H2.Body.t
 *
 * This is also where we first encounter the concept of a `Body` (which were
 * briefly mentioned above) that can be written to (potentially
 * asynchronously). *)
let error_handler _client_address ?request:_ _error start_response =
  (* We start the error response by calling the `start_response` function. We
   * get back a response body. *)
  let response_body = start_response Headers.empty in
  (* Once we get the response body, we can immediately start writing to it. In
   * this case, it might be sufficient to say that there was an error. *)
  Body.Writer.write_string
    response_body
    "There was an error handling your request.\n";
  (* Finally, we close the streaming response body to signal to the underlying
   * HTTP/2 framing layer that we have finished sending the response. *)
  Body.Writer.close response_body

let () =
  (* We're going to be using the `H2_lwt_unix` module from the `h2-lwt-unix`
   * library to create a server that communicates over the underlying operating
   * system socket abstraction. The first step is to create a connection
   * handler that will accept incoming connections and let our request and
   * error handlers handle the request / response exchanges in those
   * connections. *)
  let connection_handler =
    H2_lwt_unix.Server.create_connection_handler
      ?config:None
      ~request_handler
      ~error_handler
  in
  (* We'll be listening for requests on the loopback interface (localhost), on
   * port 8080. *)
  let listen_address = Unix.(ADDR_INET (inet_addr_loopback, 8080)) in
  (* The final step is to start a server that will set up all the low-level
   * networking communication for us, and let it run forever. *)
  let _server =
    Lwt_io.establish_server_with_client_socket listen_address connection_handler
  in
  let forever, _ = Lwt.wait () in
  Lwt_main.run forever
