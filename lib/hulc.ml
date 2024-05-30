type serialized = string

let make_node_id =
  Random.bits64

let sprint node_id =
  Printf.sprintf "%016Lx" node_id

let sprint clock node_id =
  Hlc.sprint clock ^ sprint node_id
