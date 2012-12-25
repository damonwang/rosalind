open Core.Std
open Rosalindlib.Std

module Util : sig
  val hylomorphism :
    ana:('a -> ('a *'b) option)
    -> cata:('b -> 'c -> 'c)
    -> 'a
    -> 'c
    -> 'c
end = struct
  let rec hylomorphism ~ana ~cata ana_init cata_init =
    match ana ana_init with
    | None -> cata_init
    | Some (ana_init, elt) ->
      hylomorphism ~ana ~cata ana_init (cata elt cata_init)
end
open Util

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
    let max_gc, max_id = hylomorphism in_ch (-1., "")
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
