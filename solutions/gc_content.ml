open Core.Std
open Rosalindlib.Std

let gc_content s =
  let gc = String.fold ~init:0 s ~f:(fun acc c ->
    match c with
    | 'G' | 'C' -> acc + 1
    | _ -> acc)
  in
  Int.to_float gc /. Int.to_float (String.length s)

module Sync = struct
  let name = "gc"
  let solve in_ch out_ch =
    let max_gc, max_id = Util.hylomorphism in_ch (-1., "")
      ~ana:(fun in_ch ->
        match Fasta.read_from_channel in_ch with
        | Ok fasta -> Some (in_ch, fasta)
        | Error _ -> None)
      ~cata:(fun elt acc->
        let gc = gc_content elt.Fasta.sequence in
        if fst acc < gc then (gc, elt.Fasta.name) else acc)
    in
    Out_channel.output_string out_ch
      (sprintf "%s\n%.6f%%\n" max_id (100. *. max_gc))
end
