open Core.Std

type t =
  { name : string
  ; description : string
  ; sequence : string
  }

include Stringable.S with type t := t

(* The [In_channel.t] is advanced to the next entry iff [read_from_channel] returns [Ok
   t]; otherwise, it is reset back to its original position. *)
val read_from_channel : In_channel.t -> t Or_error.t
