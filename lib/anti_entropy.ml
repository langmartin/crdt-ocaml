type key = string
type box = string * string

module StringMap = Map.Make(String)
let make_store() : box StringMap.t = StringMap.empty

let get_opt store key =
  match StringMap.find_opt store key with
  | None -> None
  | Some (_hulc, value) -> value

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
