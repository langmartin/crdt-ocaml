@0xb430e7dc4bf52fd7;

struct Item {
  key @0 :Text;
  hulc @1 :Data;
  value @2 :Text;
}

interface Gossip {
  send @0 (msg :Item) -> (reply :Bool);
}
