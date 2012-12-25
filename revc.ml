open Core.Std

let string_reverse_map s ~f =
  let n = String.length s in
  String.init n ~f:(fun i -> f (String.get s (n - i - 1)))

let dna = function
  | 'A' -> 'T'
  | 'T' -> 'A'
  | 'C' -> 'G'
  | 'G' -> 'C'
  | other -> failwithf "dna cannot contain base %c" other ()

let reverse_complement s ~pairing =
  try Ok (string_reverse_map s ~f:pairing) with
  | exn -> Or_error.of_exn exn

module Cmd = struct
  let name = "revc"
  let cmd = Command.basic ~summary:"solve the 'revc' puzzle"
    Command.Spec.empty
    (fun () ->
      In_channel.iter_lines In_channel.stdin ~f:(fun line ->
        match reverse_complement line ~pairing:dna with
        | Ok revc -> Out_channel.output_string Out_channel.stdout revc
        | Error err -> Error.raise err))
end
