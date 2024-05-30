type clock = {
     time : int;
     tick : int
}

let send system local =
  let logical = max system local.time in
  {
    time = logical;
    tick =
      if logical == local.time then
        local.tick + 1
      else
        0
  }

let recv system local remote =
  let logical = max system local.time |> max remote.time in
  {
    time = logical;
    tick = 
      if logical == remote.time then
        remote.tick + 1
      else if logical == local.time then
        local.tick + 1
      else
        0
  }

let parse serialized =
  let open String in
  {
    time = "0x" ^ sub serialized 0 12 |> int_of_string;
    tick = "0x" ^ sub serialized 12 4 |> int_of_string
  }

let sprint clock =
  let open Printf in
  sprintf "%012x%04x" clock.time clock.tick
