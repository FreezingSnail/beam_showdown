import gleam/float
import gleam/int
import gleam/io

import core/party.{type PlayerState}
import core/turn.{type Turn}
import lib/creature.{type Creature}
import lib/move.{type Effect, type Move}
import lib/types

pub type WhichPlayer {
  Player1
  Player2
}

pub type FightState {
  FightState(player1: PlayerState, player2: PlayerState, turn_log: List(Turn))
}

pub type TurnResult {
  Attack(state: FightState, damage: Int)
  Change(state: FightState, name: String)
}

pub fn new_random_fight() -> FightState {
  FightState(
    player1: party.build_random_party(),
    player2: party.build_random_party(),
    turn_log: [],
  )
}

pub fn new_fight(p1, p2: PlayerState) -> FightState {
  FightState(player1: p1, player2: p2, turn_log: [])
}

pub fn calculate_damage(input: Move, source: Creature, target: Creature) -> Int {
  let damage =
    { input.power * source.stats.attack } / { target.stats.defense / 2 }
  let mod =
    types.get_dualtype_modifier(input.types, target.dualtype)
    |> types.modifier_value()

  let calc = float.round(int.to_float(damage) *. mod)
  case calc {
    calc if calc < 0 -> 0
    _ -> calc
  }
}

pub fn player_turn(
  state: FightState,
  turn: Turn,
  committer: WhichPlayer,
  target: WhichPlayer,
) -> TurnResult {
  let state = FightState(..state, turn_log: [turn, ..state.turn_log])
  let actor = case committer {
    Player1 -> state.player1
    Player2 -> state.player2
  }
  let reciver = case target {
    Player1 -> state.player1
    Player2 -> state.player2
  }

  case turn {
    turn.Change(creature) -> {
      let new_player_state = party.set_active_creature(actor, creature)
      Change(
        state: new_fight_state(state, new_player_state, committer),
        name: creature.name,
      )
    }

    turn.Attack(move) -> {
      let damage =
        calculate_damage(move, actor.active_creature, reciver.active_creature)
      let new_player_state = party.apply_active_damage(reciver, damage)
      Attack(
        state: new_fight_state(state, new_player_state, target),
        damage: damage,
      )
    }
  }
}

fn new_fight_state(
  state: FightState,
  player_state: PlayerState,
  who: WhichPlayer,
) -> FightState {
  case who {
    Player1 -> FightState(..state, player1: player_state)
    Player2 -> FightState(..state, player2: player_state)
  }
}
