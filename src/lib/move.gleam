import lib/types.{type DualType}

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

pub type Move {
  Move(
    power: Int,
    accuracy: Float,
    types: DualType,
    physical: Bool,
    effect: Effect,
  )
}
