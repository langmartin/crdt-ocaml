type serialized = string

let sprint clock node_id =
  Hlc.sprint64 clock ^ node_id
