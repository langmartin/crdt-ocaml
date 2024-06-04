type envelope = {
    hulc : Hulc.serialized;
    key : string;
    data : string;
  }

let self = Hulc.make_node_id()
let the_clock = ref Hlc.zero
let the_anti_entropy = ref Anti_entropy.empty

let t_send() =
  let next = !the_clock |> Hlc.(time_ms() |> send) in
  the_clock := next; Hulc.sprint next self

let t_recv remote =
  let recv = !the_clock |> Hlc.(time_ms() |> recv) in
  let next = remote |> Hlc.parse |> recv in
  the_clock := next; Hulc.sprint next self

let ae_get_opt key =
  let current = !the_anti_entropy in
  Anti_entropy.get_opt current key

let ae_put message =
  let {hulc = hulc; key = key; data = data} = message in
  let current = !the_anti_entropy in
  let next = Anti_entropy.put current key hulc data in
  the_anti_entropy := next; next
