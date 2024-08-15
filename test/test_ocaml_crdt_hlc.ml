open Ocaml_crdt.Hlc

let clock_pp ppf c = Format.fprintf ppf "@[%Ld-%d@]" c.time c.tick
let clock_t = Alcotest.testable clock_pp ( = )

let test_parse64 () =
  let ts = { time = time_ms(); tick = 1 } in
  Alcotest.(check clock_t) "same record" ts (Option.get (parse64 (sprint64 ts)))

let () =
  Alcotest.run "Hlc"
    [
      ( "parse64",
        [
          Alcotest.test_case "round trip" `Quick test_parse64;
        ]
      )
    ]
