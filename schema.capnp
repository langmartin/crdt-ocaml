@0xb430e7dc4bf52fd7;

struct Item {
  key @0 :Text;
  hulc @1 :Data;

  union {
    string :group {
      value @2 :Text;
    }

    long :group {
      value @3 :Int64;
    }
  }
}

interface Gossip {
  send @0 (msg :Item) -> (reply :Bool);
}
