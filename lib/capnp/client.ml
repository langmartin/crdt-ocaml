module Gossip = Schema.Client.Gossip

let send t msg =
  let open Gossip.Send in
  let request, params = Capability.Request.create Params.init_pointer in
  Params.msg_set params msg;
  Capability.call_for_value_exn t method_id request >|= Results.reply_get
