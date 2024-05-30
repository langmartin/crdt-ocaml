type key = string
type value = string
type box = string * value

module StringMap = Map.Make(String)

let make_store() : box StringMap.t =
  StringMap.empty

let get_opt store key =
  match StringMap.find_opt store key with
  | None -> None
  | Some (_hulc, value) -> value

let put store key hulc value =
  let open StringMap in
  let x = find_opt store key in
  match x with
  | None -> add store key (hulc, value)
  | Some box ->
     let (prev, _) = box in
     if String.compare hulc prev > 0 then
       add store key (hulc, value)
     else
       store
