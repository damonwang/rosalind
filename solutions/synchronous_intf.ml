open Core.Std

module type S = sig
  val name : string
  val solve : In_channel.t -> Out_channel.t -> unit
end
