import gleam/int

import lib/creature.{type Creature}
import lib/data
import lib/move.{type Effect}

pub type CreatureSlot {
  First
  Second
  Third
}

pub type CreatureParty {
  CreatureParty(first: Creature, second: Creature, third: Creature)
}

pub type PlayerState {
  PlayerState(
    party: CreatureParty,
    active_creature: Creature,
    slot: CreatureSlot,
  )
}

pub fn build_party(first, second, third: Int) -> PlayerState {
  let c1 = data.get_creature_from_list(first)
  let c2 = data.get_creature_from_list(second)
  let c3 = data.get_creature_from_list(third)
  PlayerState(
    party: CreatureParty(first: c1, second: c2, third: c3),
    active_creature: c1,
    slot: First,
  )
}

pub fn build_random_party() -> PlayerState {
  build_party(int.random(30), int.random(30), int.random(30))
}

pub fn set_active_creature(
  playerstate: PlayerState,
  creature: Creature,
) -> PlayerState {
  PlayerState(..playerstate, active_creature: creature)
}

pub fn select_creature_from_party(
  playerstate: PlayerState,
  index: CreatureSlot,
) -> Creature {
  case index {
    First -> playerstate.party.first
    Second -> playerstate.party.second
    Third -> playerstate.party.third
  }
}

pub fn apply_active_damage(playerstate: PlayerState, damage: Int) -> PlayerState {
  let new_health = playerstate.active_creature.health - damage
  let updated_creature =
    creature.update_health(playerstate.active_creature, new_health)
  let party = case playerstate.slot {
    First -> CreatureParty(..playerstate.party, first: updated_creature)
    Second -> CreatureParty(..playerstate.party, second: updated_creature)
    Third -> CreatureParty(..playerstate.party, third: updated_creature)
  }
  PlayerState(..playerstate, party: party, active_creature: updated_creature)
}

pub fn apply_active_status(
  playerstate: PlayerState,
  status: Effect,
) -> PlayerState {
  let updated_creature =
    creature.update_status(playerstate.active_creature, status)
  let party = case playerstate.slot {
    First -> CreatureParty(..playerstate.party, first: updated_creature)
    Second -> CreatureParty(..playerstate.party, second: updated_creature)
    Third -> CreatureParty(..playerstate.party, third: updated_creature)
  }
  PlayerState(..playerstate, party: party, active_creature: updated_creature)
}

pub fn clear_active_status(playerstate: PlayerState) -> PlayerState {
  apply_active_status(playerstate, move.NONE)
}
