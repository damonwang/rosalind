open Core.Std

let rec hylomorphism ~ana ~cata ana_init cata_init =
  match ana ana_init with
  | None -> cata_init
  | Some (ana_init, elt) ->
    hylomorphism ~ana ~cata ana_init (cata elt cata_init)
