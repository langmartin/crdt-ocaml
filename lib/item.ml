module Item = Schema.Make(Capnp.BytesMessage)

type value =
  | String of string
  | Long of int64
  | None

let key_of item =
  let open Item.Reader in
  Item.key_get item

let hulc_of item =
  let open Item.Reader in
  Item.hulc_get item

let value_of item =
  let open Item.Reader in
  match Item.get item with
  | Item.String s -> String (Item.String.value_get s)
  | Item.Long l -> Long (Item.Long.value_get l)
  | Item.Undefined _ -> None

let value_str value =
  match value with
  | String s -> s
  | Long l -> Format.sprintf "%Ld" l
  | None -> ""
