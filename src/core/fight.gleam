import lib/creature.{type Creature}
import lib/move.{type Effect}
import lib/types

import core/party.{type PlayerState}

pub type FightState {
  FightState(player1: PlayerState, player2: PlayerState)
}
