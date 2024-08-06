import lib/creature.{type Creature}
import lib/index.{type Index}
import lib/move.{type Effect}

pub type PlayerState {
  PlayerState(party: #(Creature, Creature, Creature), active_creature: Creature)
}

pub fn build_party(first, second, third: Int) -> PlayerState {
  todo
}

pub fn set_active_creature(
  playerstate: PlayerState,
  creature: Creature,
) -> PlayerState {
  PlayerState(..playerstate, active_creature: creature)
}

pub fn select_creature_from_party(
  playerstate: PlayerState,
  index: Index,
) -> Creature {
  let #(a, b, c) = playerstate.party
  case index {
    index.First -> a
    index.Second -> b
    index.Third -> c
  }
}

pub fn apply_active_damage(playerstate: PlayerState, damage: Int) -> PlayerState {
  let new_health = playerstate.active_creature.health - damage
  let updated_creature =
    creature.update_health(playerstate.active_creature, new_health)
  PlayerState(..playerstate, active_creature: updated_creature)
}

pub fn apply_active_status(
  playerstate: PlayerState,
  status: Effect,
) -> PlayerState {
  let updated_creature =
    creature.update_status(playerstate.active_creature, status)
  PlayerState(..playerstate, active_creature: updated_creature)
}

pub fn clear_active_status(playerstate: PlayerState) -> PlayerState {
  apply_active_status(playerstate, move.NONE)
}
