module Api = Schema.MakeRPC(Capnp_rpc_lwt)

open Lwt.Infix
open Capnp_rpc_lwt

let local =
  let module Gossip = Api.Service.Gossip in
  Gossip.local @@
    object inherit Gossip.service
      method ping_impl params release_param_caps =
        let open Gossip.Send in
        let msg = Params.msg_get params in
        release_param_caps ();
        let response, results = Service.Response.create Results.init_pointer in
        Results.reply_set results true;
        Service.return response
    end
