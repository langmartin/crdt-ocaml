module Api = Schema.MakeRPC(Capnp_rpc_lwt)

open Capnp_rpc_lwt

let local =
  let module Gossip = Api.Service.Gossip in
  Gossip.local @@
    object inherit Gossip.service
      method send_impl params release_param_caps =
        let open Gossip.Send in
        let _msg = Params.msg_get params in
        release_param_caps ();
        let response, results = Service.Response.create Results.init_pointer in
        Results.reply_set results true;
        Service.return response
    end

module Gossip = Api.Client.Gossip

open Lwt.Infix

let send t msg =
  let open Gossip.Send in
  let request, params = Capability.Request.create Params.init_pointer in
  Params.msg_set params msg;
  Capability.call_for_value_exn t method_id request >|= Results.reply_get
