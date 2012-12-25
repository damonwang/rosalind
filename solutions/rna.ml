open Core.Std

let translate line = String.map line ~f:(function
  | 'T' -> 'U'
  | other -> other)

module Sync = struct
  let name = "rna"
  let solve in_ch out_ch =
    In_channel.iter_lines in_ch ~f:(fun line ->
      Out_channel.output_string out_ch (translate line))
end
