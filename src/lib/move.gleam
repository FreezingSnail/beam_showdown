import lib/types.{type Types}

pub type Effect {
  NONE
  EGOED
  DRENCHED
  BUFFETED
  STUMBLED
  BURNED
  SHOCKED
  ENTANGLED
  CURSED
}

pub type Priority {
  Normal
  Fast
  Slow
}

pub type Move {
  Move(
    id: Int,
    name: String,
    power: Int,
    accuracy: Float,
    types: Types,
    physical: Bool,
    effect: Effect,
    priority: Priority,
  )
}

pub fn string_to_effect(s: String) -> Effect {
  case s {
    "NONE" -> NONE
    "EGOED" -> EGOED
    "DRENCHED" -> DRENCHED
    "BUFFETED" -> BUFFETED
    "STUMBLED" -> STUMBLED
    "BURNED" -> BURNED
    "SHOCKED" -> SHOCKED
    "ENTANGLED" -> ENTANGLED
    "CURSED" -> CURSED
    _ -> NONE
  }
}
