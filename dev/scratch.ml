let self = Hulc.make_node_id()

let the_clock = ref Hlc.zero;;

the_clock := Hlc.(time_ms() |> init);;

let send() =
  let next = !the_clock |> Hlc.(time_ms() |> send) in
  the_clock := next; Hulc.sprint next self

let recv remote =
  let recv = !the_clock |> Hlc.(time_ms() |> recv) in
  let next = recv remote in
  the_clock := next; Hulc.sprint next self
