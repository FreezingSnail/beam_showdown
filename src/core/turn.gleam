import core/party.{type PlayerState}
import lib/creature.{type Creature}
import lib/move.{type Move}

pub type Turn {
  Attack(selected_move: Move)
  Change(selected_creature: Creature)
}
