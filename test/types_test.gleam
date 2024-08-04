import gleeunit/should
import lib/types

pub fn get_dualtype_modifier_test() {
  let modifier =
    types.get_dualtype_modifier(
      types.WATER,
      types.DualType(types.WIND, types.EARTH),
    )
  should.equal(modifier, types.Same)
  should.equal(
    types.get_dualtype_modifier(
      types.FIRE,
      types.DualType(types.PLANT, types.NONE),
    ),
    types.Double,
  )
}
