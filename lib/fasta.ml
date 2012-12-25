open Core.Std

(* If we need sequences too large to fit into memory *)
(* module Sequence = struct
 *   module Lazy_sequence = struct
 *     type t =
 *       { in_ch : In_channel.t
 *       ; pos : int
 *       ; len : int
 *       }
 *   end
 *   type t =
 *   | Immediate of string
 *   | Lazy of Lazy_sequence.t
 * end *)

type t =
  { name : string
  ; description : string
  ; sequence : string
  }

let is_header line = String.get line 0 = '>'
let parse_header header =
  let open Option.Monad_infix in
  String.chop_prefix ~prefix:">" header
  >>| fun line ->
  Option.value ~default:(line, "") (String.lsplit2 ~on:' ' line)

let of_string s =
  let header, sequence = String.lsplit2_exn s ~on:'\n' in
  let sequence = String.concat (String.split sequence ~on:'\n') in
  let name, description = Option.value_exn (parse_header header) in
  { name; description; sequence }

let to_string { name; description; sequence } =
  let rec wrap len pos s lines =
    if String.length s - pos <= len then
      String.sub s ~pos ~len :: lines
    else wrap len (pos + len) s
      (String.sub s ~pos ~len :: lines)
  in
  String.concat ~sep:"\n"
    (sprintf ">%s %s" name description :: wrap 80 0 sequence [])


let read_from_channel in_ch =
  let rec iter acc in_ch =
    let pos = In_channel.pos in_ch in
    match In_channel.input_line in_ch with
    | None -> if not (List.is_empty acc) then Some acc else None
    | Some line ->
      if not (is_header line)
      then iter (line :: acc) in_ch
      else begin
        In_channel.seek in_ch pos;
        Some acc
      end
  in
  let pos = In_channel.pos in_ch in
  let retval =
    let open Option.Monad_infix in
    In_channel.input_line in_ch
    >>= fun line -> parse_header line
    >>= fun (name, description) -> iter [] in_ch
    >>| fun sequence ->
    { name; description; sequence = String.concat sequence }
  in
  match retval with
  | Some t -> Ok t
  | None ->
    In_channel.seek in_ch pos;
    Or_error.error_string "Fasta.read_from_channel: failed to read entry"


