import decode
import gleam/dict
import gleam/dynamic.{field, int, list, string}
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/string

import data/creature_data
import data/move_data
import lib/creature.{type Creature, Creature}
import lib/move.{type Effect, type Move, Move}
import lib/types.{type DualType}

pub fn get_move_list() -> List(Move) {
  move_data.move_json()
  |> read_moves_from_json()
}

type MoveDTO {
  MoveDTO(
    name: String,
    power: Int,
    accuracy: Int,
    types: String,
    physical: Int,
    effect: String,
  )
}

pub type StatsDTO {
  StatsDTO(
    hp: String,
    attack: String,
    defense: String,
    special_atk: String,
    special_def: String,
    speed: String,
  )
}

pub type CreatureDTO {
  CreatureDTO(
    id: String,
    name: String,
    health: String,
    moves: List(Move),
    stats: StatsDTO,
    dualtype: DualType,
    active_status: Effect,
  )
}

fn string_to_int(s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(_) -> 0
  }
}

pub fn get_creature_data() -> List(Creature) {
  let dto =
    creature_data.creature_json()
    |> read_creature_from_json()

  list.map(dto, fn(dto: CreatureDTO) -> Creature {
    creature.Creature(
      id: string_to_int(dto.id),
      name: dto.name,
      health: string_to_int(dto.health),
      moves: dto.moves,
      stats: creature.Stats(
        hp: string_to_int(dto.stats.hp),
        attack: string_to_int(dto.stats.attack),
        defense: string_to_int(dto.stats.defense),
        special_atk: string_to_int(dto.stats.special_atk),
        special_def: string_to_int(dto.stats.special_def),
        speed: string_to_int(dto.stats.speed),
      ),
      dualtype: dto.dualtype,
      active_status: dto.active_status,
    )
  })
}

fn process_json(json_string: String) -> List(dict.Dict(String, String)) {
  let res =
    json.decode(json_string, dynamic.list(of: dynamic.dict(string, string)))
  case res {
    Ok(d) -> d
    _ -> [dict.from_list([#("", "")])]
  }
}

pub fn read_creature_from_json(json_string: String) -> List(CreatureDTO) {
  let data = process_json(json_string)

  let res =
    decode.into({
      use name <- decode.parameter
      use id <- decode.parameter
      use type1 <- decode.parameter
      use type2 <- decode.parameter
      use atk <- decode.parameter
      use defense <- decode.parameter
      use spca <- decode.parameter
      use spcd <- decode.parameter
      use hp <- decode.parameter
      use spd <- decode.parameter
      CreatureDTO(
        name: name,
        id: id,
        health: "100",
        moves: [],
        stats: StatsDTO(
          hp: hp,
          attack: atk,
          defense: defense,
          speed: spd,
          special_atk: spca,
          special_def: spcd,
        ),
        dualtype: types.DualType(
          types.string_to_type(type1),
          types.string_to_type(type2),
        ),
        active_status: move.NONE,
      )
    })
    |> decode.field("name", decode.string)
    |> decode.field("id", decode.string)
    |> decode.field("type1", decode.string)
    |> decode.field("type2", decode.string)
    |> decode.field("atk", decode.string)
    |> decode.field("def", decode.string)
    |> decode.field("spcatk", decode.string)
    |> decode.field("spcdef", decode.string)
    |> decode.field("hp", decode.string)
    |> decode.field("spd", decode.string)
    |> decode.list()
    |> decode.from(dynamic.from(data))

  case res {
    Ok(data) -> data
    Error(e) -> {
      io.debug(e)
      []
    }
  }
}

pub fn read_moves_from_json(json_string: String) -> List(Move) {
  let move_decoder =
    dynamic.decode6(
      MoveDTO,
      field("name", string),
      field("power", int),
      field("accuracy", int),
      field("type", string),
      field("physical", int),
      field("effect", string),
    )
  let move_list_decoder = dynamic.list(move_decoder)

  let res = json.decode(from: json_string, using: move_list_decoder)
  let dto = case res {
    Ok(moves) -> moves
    Error(_) -> []
  }

  list.map(dto, fn(dto: MoveDTO) {
    Move(
      id: 0,
      name: dto.name,
      power: dto.power,
      accuracy: int.to_float(dto.accuracy) /. 100.0,
      types: types.string_to_type(dto.types),
      physical: dto.physical == 1,
      effect: move.string_to_effect(dto.effect),
      priority: move.Normal,
    )
  })
}
