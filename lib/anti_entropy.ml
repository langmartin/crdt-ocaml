type key = string
module Item = Schema.Make(Capnp.BytesMessage)
type box = Hulc.serialized * string

module StringMap = Map.Make(String)

let empty : box StringMap.t = StringMap.empty

let get_opt store key =
  match StringMap.find_opt key store with
  | None -> None
  | Some (_hulc, value) -> Some value

let get store key =
  match get_opt store key with
  | None -> raise Exit
  | Some value -> value

let use_next next prev =
  String.compare next prev > 0

let is_fresh key hulc store =
  match get_opt store key with
  | None -> true
  | Some(prev, _) ->
     use_next hulc prev

let put store key hulc value =
  let open StringMap in
  match find_opt key store with
  | None -> add key (hulc, value) store
  | Some (prev, _) ->
     if use_next hulc prev then
       add key (hulc, value) store
     else
       store

let put_fresh store key hulc value =
  let is_fresh = is_fresh key hulc store in
  let store = put store key hulc value in
  ( is_fresh, store )
