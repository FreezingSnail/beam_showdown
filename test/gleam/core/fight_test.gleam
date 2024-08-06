import gleeunit/should

import core/fight
import core/party
import core/turn
import test_helper

pub fn player1_turn_test() {
  //setup
  let player1 = test_helper.random_party()
  let player2 = test_helper.random_party()
  let state = fight.FightState(player1: player1, player2: player2, turn_log: [])
  let m = test_helper.random_move()
  let t = turn.Attack(m)

  // test
  let player1_turn_result =
    fight.player_turn(state, t, fight.Player1, fight.Player2)

  // expected values
  let damage =
    fight.calculate_damage(m, player1.active_creature, player2.active_creature)
  let player2_new = party.apply_active_damage(player2, damage)
  let expected_state =
    fight.FightState(
      ..state,
      player2: player2_new,
      turn_log: [t, ..state.turn_log],
    )

  should.equal(expected_state.player1, player1_turn_result.state.player1)
  should.equal(expected_state.player2, player1_turn_result.state.player2)
  should.equal(
    player1_turn_result,
    fight.Attack(state: expected_state, damage: damage),
  )
}

pub fn player2_turn_test() {
  //setup
  let player1 = test_helper.random_party()
  let player2 = test_helper.random_party()
  let state = fight.FightState(player1: player1, player2: player2, turn_log: [])
  let m = test_helper.random_move()
  let t = turn.Attack(m)

  // test
  let player1_turn_result =
    fight.player_turn(state, t, fight.Player2, fight.Player1)

  // expected values
  let damage =
    fight.calculate_damage(m, player2.active_creature, player1.active_creature)
  let player1_new = party.apply_active_damage(player1, damage)
  let expected_state =
    fight.FightState(
      ..state,
      player1: player1_new,
      turn_log: [t, ..state.turn_log],
    )

  should.equal(expected_state.player1, player1_turn_result.state.player1)
  should.equal(expected_state.player2, player1_turn_result.state.player2)
  should.equal(
    player1_turn_result,
    fight.Attack(state: expected_state, damage: damage),
  )
}
