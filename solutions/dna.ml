
open Core.Std

module Base = struct
  type t = char
  let dna = ['A'; 'C'; 'G'; 'T' ]
end

module Base_count : sig
  type t
  val empty : t
  val unexpected_bases : expected:Base.t list -> t -> Base.t list
  val count : t -> Base.t -> unit
  val get : t -> Base.t -> int
end = struct
  type t = int Char.Table.t

  let unexpected_bases ~expected t =
    let expected = Char.Set.of_list expected in
    let found = Char.Set.of_list (Hashtbl.keys t) in
    Set.elements (Set.diff found expected)

  let count t base =
    Hashtbl.change t (Char.uppercase base) (fun i ->
      Some (Option.value_map i ~default:1 ~f:(Int.(+) 1)))

  let empty = Char.Table.create ()

  let get t base = Option.value ~default:0 (Hashtbl.find t base)
end

let count_nucleotides_in_line in_ch =
  let rec iter in_ch acc =
    match In_channel.input_char in_ch with
    | None | Some '\n' -> acc
    | Some c ->
      Base_count.count acc c;
      iter in_ch acc
  in
  iter in_ch Base_count.empty

module Cmd = struct
  let name = "dna"
  let cmd =
    Command.basic ~summary:"solve 'dna' puzzle"
      Command.Spec.empty
      (fun () ->
        let count = count_nucleotides_in_line In_channel.stdin in
        Out_channel.output_string Out_channel.stdout begin
          match Base_count.unexpected_bases ~expected:Base.dna count with
          | [] ->
            String.concat ~sep:" " (List.map Base.dna ~f:(fun c ->
              sprintf "%d" (Base_count.get count c)) @ [ "\n" ])
          | other ->
          sprintf "Non-DNA bases detected: %s\n"
            (String.concat (List.map other ~f:(Char.to_string)))
        end)
end

