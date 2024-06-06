module Api = Schema.MakeRPC(Capnp_rpc_lwt)
module Item = Schema.Make(Capnp.BytesMessage)

open Capnp_rpc_lwt

let recv item_msg : string =
  let open Item.Reader in
  let key = Item.key_get item_msg in
  let hulc = Item.hulc_get item_msg in
  World.ae_put key hulc item_msg

let local =
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

open Lwt.Infix

let send t key hulc value =
  let open Gossip.Send in
  let request, params = Capability.Request.create Params.init_pointer in
  let rw = Params.msg_init params in
  let open Item.Builder in
  Item.key_set rw key;
  Item.hulc_set rw hulc;
  Item.value_set rw value;
  Capability.call_for_value_exn t method_id request >|= Results.reply_get
