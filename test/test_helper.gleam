import gleam/dynamic.{field, int, list, string}
import gleam/int
import gleam/json
import gleam/list

import core/party.{type PlayerState}
import lib/creature.{type Creature}
import lib/data
import lib/move.{type Move, Move}
import lib/types

import data/move_data

pub fn random_creature() -> Creature {
  creature.Creature(
    id: 1,
    name: "snail",
    health: 100,
    dualtype: types.DualType(types.SPIRIT, types.WATER),
    active_status: move.NONE,
    moves: [random_move(), random_move(), random_move(), random_move()],
    stats: creature.Stats(10, 10, 10, 10, 10, 10),
  )
}

pub fn random_move() -> Move {
  let moves =
    move_data.move_json()
    |> data.read_moves_from_json()
    |> list.shuffle()
  case list.first(moves) {
    Ok(move) -> move
    Error(_) ->
      Move(
        id: 0,
        name: "smite",
        power: 10,
        accuracy: 1.0,
        types: types.SPIRIT,
        physical: True,
        effect: move.NONE,
        priority: move.Normal,
      )
  }
}

pub fn random_party() -> PlayerState {
  let active = random_creature()
  party.PlayerState(
    party: #(active, random_creature(), random_creature()),
    active_creature: active,
  )
}
