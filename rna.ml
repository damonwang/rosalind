open Core.Std

let translate line = String.map line ~f:(function
  | 'T' -> 'U'
  | other -> other)

module Cmd = struct
  let name = "rna"
  let cmd = Command.basic ~summary:"solve the 'rna' puzzle"
    Command.Spec.empty
    (fun () ->
      In_channel.iter_lines In_channel.stdin ~f:(fun line ->
      Out_channel.output_string Out_channel.stdout (translate line)))
end
