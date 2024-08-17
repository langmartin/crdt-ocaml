let self = Node_id.make_id()
let the_clock = ref Hlc.zero
let the_anti_entropy = ref Anti_entropy.empty

let t_send() =
  let next = !the_clock |> Hlc.(time_ms() |> send) in
  the_clock := next;
  Hulc.sprint next self

let t_recv remote =
  let recv = !the_clock |> Hlc.(time_ms() |> recv) in
  let next = remote |> Hlc.parse64 |> Option.get |> recv in
  the_clock := next;
  Hulc.sprint next self

let ae_get_opt key =
  let current = !the_anti_entropy in
  Anti_entropy.get_opt current key

let ae_put key hulc data =
  let current = !the_anti_entropy in
  (* let ( is_fresh, next ) = Anti_entropy.put_fresh current key hulc data in *)
  let next = Anti_entropy.put current key hulc data in
  if not (next == current) then
    the_anti_entropy := next;
  true

(* let ae_store key hulc data = *)
(*   Sqlite3 *)
