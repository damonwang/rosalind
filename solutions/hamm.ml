open Core.Std

module Sync = struct
  let name = "hamm"
  let solve in_ch out_ch =
    let ab =
      let open Option.Monad_infix in
      In_channel.input_line in_ch
      >>= fun a -> In_channel.input_line in_ch
      >>= fun b ->
      Option.some_if (String.length a = String.length b) (a, b)
    in
    Out_channel.output_string out_ch
      (Option.value_map ab ~default:"invalid_input" ~f:(fun (a, b) ->
        sprintf "%d\n" (String.foldi ~init:0 a ~f:(fun i hamm c ->
          if String.get b i = c then hamm else hamm + 1))))
end
