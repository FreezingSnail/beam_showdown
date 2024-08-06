import gleeunit/should

import core/party
import test_helper

pub fn set_active_creature_test() {
  let playerstate = test_helper.random_party()
  let new_active_creature = test_helper.random_creature()
  let updated_playerstate =
    party.set_active_creature(playerstate, new_active_creature)
  should.equal(updated_playerstate.active_creature, new_active_creature)
}
