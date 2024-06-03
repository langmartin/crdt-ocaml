type key = string
type box = Hulc.serialized * string

module StringMap = Map.Make(String)

let empty : box StringMap.t = StringMap.empty

let get_opt store key =
  match StringMap.find_opt store key with
  | None -> None
  | Some (_hulc, value) -> Some value

let get store key =
  match get_opt store key with
  | None -> raise Exit
  | Some value -> value

let put store key hulc value =
  let open StringMap in
  match find_opt key store with
  | None -> add key (hulc, value) store
  | Some (prev, _) ->
     if String.compare hulc prev > 0 then
       add key (hulc, value) store
     else
       store
