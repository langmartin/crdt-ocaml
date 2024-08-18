open Sqlite3

let ok result =
  match result with
  | Rc.OK -> ()
  | _ -> ()

let db_init() =
  let db = db_open "anti_entropy.db" in
  let _result = exec db "
    create table if not exists item (
      key text,
      hulc text,
      body_text text,
      body_int integer
    ) primary key (key, hulc);

    create table if not exists migrations (
      label text primary key,
      date integer
    );
    " in
  db

type value =
  | String of string
  | Value of Item.value

let bind_one offset value prepared =
  match value with
  | String s -> bind_text prepared offset s |> ok
  | Value Item.String s -> bind_text prepared offset s |> ok
  | Value Item.Long l -> bind_int64 prepared offset l |> ok
  | Value Item.None -> ()

let rec bind offset values prepared =
  match values with
  | [] -> ()
  | t :: ts ->
    bind_one offset t prepared;
    bind (offset + 1) ts prepared

let store_item_query db = prepare db "
    insert into item (key, hulc, body)
      values (?, ?, ?)
    on conflict (key, hulc) do nothing;
      "

let store_item key hulc value prepared =
  reset prepared |> ok;
  bind 1 [String key; String hulc; Value value] prepared;
  step prepared |> ok;
