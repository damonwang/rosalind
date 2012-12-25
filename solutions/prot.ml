open Core.Std

type translation =
| Amino_acid of char
| Stop

let codons = String.Map.of_alist_exn
  [ "UUC", Amino_acid 'F'
  ; "CUC", Amino_acid 'L'
  ; "AUC", Amino_acid 'I'
  ; "GUC", Amino_acid 'V'
  ; "UUA", Amino_acid 'L'
  ; "CUA", Amino_acid 'L'
  ; "AUA", Amino_acid 'I'
  ; "GUA", Amino_acid 'V'
  ; "UUG", Amino_acid 'L'
  ; "CUG", Amino_acid 'L'
  ; "AUG", Amino_acid 'M'
  ; "GUG", Amino_acid 'V'
  ; "UCU", Amino_acid 'S'
  ; "CCU", Amino_acid 'P'
  ; "ACU", Amino_acid 'T'
  ; "GCU", Amino_acid 'A'
  ; "UCC", Amino_acid 'S'
  ; "CCC", Amino_acid 'P'
  ; "ACC", Amino_acid 'T'
  ; "GCC", Amino_acid 'A'
  ; "UCA", Amino_acid 'S'
  ; "CCA", Amino_acid 'P'
  ; "ACA", Amino_acid 'T'
  ; "GCA", Amino_acid 'A'
  ; "UCG", Amino_acid 'S'
  ; "CCG", Amino_acid 'P'
  ; "ACG", Amino_acid 'T'
  ; "GCG", Amino_acid 'A'
  ; "UAU", Amino_acid 'Y'
  ; "CAU", Amino_acid 'H'
  ; "AAU", Amino_acid 'N'
  ; "GAU", Amino_acid 'D'
  ; "UAC", Amino_acid 'Y'
  ; "CAC", Amino_acid 'H'
  ; "AAC", Amino_acid 'N'
  ; "GAC", Amino_acid 'D'
  ; "UAA", Stop
  ; "CAA", Amino_acid 'Q'
  ; "AAA", Amino_acid 'K'
  ; "GAA", Amino_acid 'E'
  ; "UAG", Stop
  ; "CAG", Amino_acid 'Q'
  ; "AAG", Amino_acid 'K'
  ; "GAG", Amino_acid 'E'
  ; "UGU", Amino_acid 'C'
  ; "CGU", Amino_acid 'R'
  ; "AGU", Amino_acid 'S'
  ; "GGU", Amino_acid 'G'
  ; "UGC", Amino_acid 'C'
  ; "CGC", Amino_acid 'R'
  ; "AGC", Amino_acid 'S'
  ; "GGC", Amino_acid 'G'
  ; "UGA", Stop
  ; "CGA", Amino_acid 'R'
  ; "AGA", Amino_acid 'R'
  ; "GGA", Amino_acid 'G'
  ; "UGG", Amino_acid 'W'
  ; "CGG", Amino_acid 'R'
  ; "AGG", Amino_acid 'R'
  ; "GGG", Amino_acid 'G'
  ; "UUU", Amino_acid 'F'
  ; "CUU", Amino_acid 'L'
  ; "AUU", Amino_acid 'I'
  ; "GUU", Amino_acid 'V'
  ]

exception Return of char list Or_error.t

let translate s =
  let f s = Util.hylomorphism (0, s) []
    ~ana:(fun (pos, s) ->
      if String.length s - pos < 3 then None else
        Some ((pos + 3, s), String.sub ~pos ~len:3 s))
    ~cata:(fun triplet acc ->
      match Map.find codons triplet with
      | Some (Amino_acid a) -> a :: acc
      | Some Stop -> raise (Return (Ok acc))
      | None ->
        raise (Return (Error (Error.create "unknown triplet" triplet
                                String.sexp_of_t))))
  in
  Or_error.map (try Ok (f s) with Return err -> err) ~f:(fun acc ->
    String.of_char_list (List.rev ('\n' :: acc)))

module Sync = struct
  let name = "prot"
  let solve in_ch out_ch =
    In_channel.iter_lines in_ch ~f:(fun s ->
      Out_channel.output_string out_ch
        (match translate s with
        | Ok s -> s
        | Error err -> Error.to_string_hum err))
end
