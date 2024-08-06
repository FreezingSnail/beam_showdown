import lib/move.{type Effect, type Move}
import lib/types.{type DualType}

pub type Stats {
  Stats(
    hp: Int,
    attack: Int,
    defense: Int,
    special_atk: Int,
    special_def: Int,
    speed: Int,
  )
}

pub type Creature {
  Creature(
    id: Int,
    name: String,
    health: Int,
    moves: List(Move),
    stats: Stats,
    dualtype: DualType,
    active_status: Effect,
  )
}

pub fn update_health(creature: Creature, new_health: Int) -> Creature {
  Creature(..creature, health: new_health)
}

pub fn update_status(creature: Creature, new_status: Effect) -> Creature {
  Creature(..creature, active_status: new_status)
}
