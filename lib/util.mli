open Core.Std

val hylomorphism :
  ana:('a -> ('a *'b) option)
  -> cata:('b -> 'c -> 'c)
  -> 'a
  -> 'c
  -> 'c
