type clock = {
     time : int64;
     tick : int
}

let zero = { time = 0L; tick = 0 }

let time_ms() =
  Unix.gettimeofday() |> ( *. ) 1000. |> Int64.of_float

let init system =
  { time = system; tick = 0 }

let send system local =
  let open Int64 in
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
  let open Int64 in
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
    time = "0x" ^ sub serialized 0 12 |> Int64.of_string;
    tick = "0x" ^ sub serialized 12 4 |> int_of_string
  }

let sprint clock =
  let open Printf in
  sprintf "%012Lx%04x" clock.time clock.tick
