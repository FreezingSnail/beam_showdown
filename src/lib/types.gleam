import gleam/dict.{type Dict}

pub type Types {
  SPIRIT
  WATER
  WIND
  EARTH
  FIRE
  LIGHTNING
  PLANT
  ELDER
  NONE
}

pub type Modifier {
  None
  Same
  Half
  Double
  Quarter
  Quadruple
}

pub fn type_table() -> Dict(Types, Dict(Types, Modifier)) {
  dict.from_list([
    #(
      SPIRIT,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, Same),
        #(WIND, Same),
        #(EARTH, Same),
        #(FIRE, Same),
        #(LIGHTNING, Same),
        #(PLANT, Same),
        #(ELDER, None),
      ]),
    ),
    #(
      WATER,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, Same),
        #(WIND, Double),
        #(EARTH, Half),
        #(FIRE, Double),
        #(LIGHTNING, Same),
        #(PLANT, Half),
        #(ELDER, Half),
      ]),
    ),
    #(
      WIND,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, Same),
        #(WIND, Same),
        #(EARTH, Double),
        #(FIRE, Half),
        #(LIGHTNING, Half),
        #(PLANT, Double),
        #(ELDER, Half),
      ]),
    ),
    #(
      EARTH,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, Double),
        #(WIND, Half),
        #(EARTH, Same),
        #(FIRE, Same),
        #(LIGHTNING, Double),
        #(PLANT, Half),
        #(ELDER, Half),
      ]),
    ),
    #(
      FIRE,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, None),
        #(WIND, Double),
        #(EARTH, Half),
        #(FIRE, Same),
        #(LIGHTNING, Double),
        #(PLANT, Double),
        #(ELDER, Same),
      ]),
    ),
    #(
      LIGHTNING,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, Double),
        #(WIND, Double),
        #(EARTH, Half),
        #(FIRE, Same),
        #(LIGHTNING, Double),
        #(PLANT, Double),
        #(ELDER, Same),
      ]),
    ),
    #(
      PLANT,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, None),
        #(WIND, Double),
        #(EARTH, Half),
        #(FIRE, Same),
        #(LIGHTNING, Double),
        #(PLANT, Double),
        #(ELDER, Same),
      ]),
    ),
    #(
      ELDER,
      dict.from_list([
        #(SPIRIT, Same),
        #(WATER, None),
        #(WIND, Double),
        #(EARTH, Half),
        #(FIRE, Same),
        #(LIGHTNING, Double),
        #(PLANT, Double),
        #(ELDER, Same),
      ]),
    ),
  ])
}

pub type DualType {
  DualType(type1: Types, type2: Types)
}

pub fn get_type_modifier(source: Types, target: Types) -> Modifier {
  let res = type_table() |> dict.get(source)
  let mod = case res {
    Ok(v) -> dict.get(v, target)
    Error(e) -> Error(e)
  }

  case mod {
    Ok(v) -> v
    Error(_) -> Same
  }
}

pub fn combine_modifiers(mod1: Modifier, mod2: Modifier) -> Modifier {
  case mod1 {
    None -> None
    Same -> mod2
    Half ->
      case mod2 {
        None -> Half
        Same -> Half
        Half -> Quarter
        Double -> Same
        Quarter -> Half
        Quadruple -> Double
      }
    Double ->
      case mod2 {
        None -> Double
        Same -> Double
        Half -> Same
        Double -> Quadruple
        Quarter -> Half
        Quadruple -> Quadruple
      }
    Quarter ->
      case mod2 {
        None -> Quarter
        Same -> Quarter
        Half -> Quarter
        Double -> Half
        Quarter -> Quarter
        Quadruple -> Same
      }
    Quadruple ->
      case mod2 {
        None -> Quadruple
        Same -> Quadruple
        Half -> Double
        Double -> Quadruple
        Quarter -> Same
        Quadruple -> Quadruple
      }
  }
}

pub fn get_dualtype_modifier(souce: Types, target: DualType) -> Modifier {
  let DualType(type1, type2) = target
  let mod1 = get_type_modifier(souce, type1)
  let mod2 = get_type_modifier(souce, type2)

  combine_modifiers(mod1, mod2)
}
