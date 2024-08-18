module Api = Schema.MakeRPC(Capnp_rpc_lwt)

open Capnp_rpc_lwt

let to_string item =
  let open Item.Item.Reader in
  let key = Item.key_get item in
  match Item.get item with
  | Item.String s -> Printf.sprintf "%s: %s" key (Item.String.value_get s)
  | Item.Long n -> Printf.sprintf "%s: %Ld" key (Item.Long.value_get n)
  | Undefined _ -> key ^ ":"

let recv item =
  let key = Item.key_of item in
  let hulc = Item.hulc_of item in
  let value = Item.value_of item in
  World.ae_put key hulc value

let make_local() =
  let module Gossip = Api.Service.Gossip in
  Gossip.local @@
    object inherit Gossip.service
      method send_impl params release_param_caps =
        let open Gossip.Send in
        let msg = Params.msg_get params in
        release_param_caps ();
        let is_fresh = recv msg in
        let response, results = Service.Response.create Results.init_pointer in
        Results.reply_set results is_fresh;
        Service.return response
    end

module Gossip = Api.Client.Gossip

let send t key hulc value =
  let open Lwt.Infix in
  let open Gossip.Send in
  let request, params = Capability.Request.create Params.init_pointer in

  (* We build the item right inline, not sure if it should move elsewhere *)
  let rw = Params.msg_init params in
  let open Item.Item.Builder.Item in
  key_set rw key;
  hulc_set rw hulc;
  (match value with
  | Item.String s -> String.value_set (string_init rw) s;
  | Item.Long l -> Long.value_set (long_init rw) l;
  | Item.None -> ());

  Capability.call_for_value_exn t method_id request >|= Results.reply_get
