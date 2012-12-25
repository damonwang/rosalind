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

module Sync = struct
  let name = "revc"
  let solve in_ch out_ch =
    In_channel.iter_lines in_ch ~f:(fun line ->
      match reverse_complement line ~pairing:dna with
      | Ok revc -> Out_channel.output_string out_ch revc
      | Error err -> Error.raise err)
end
