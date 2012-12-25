open Core.Std

let () =
  Command.run begin
    Command.group ~summary:"solve the Rosalind puzzles"
      (List.map Solutions.Std.synchronous ~f:(fun soln ->
        let module Soln = (val soln : Solutions.Synchronous_intf.S) in
        let cmd = Command.basic
          ~summary:(sprintf "solve the '%s' puzzle" Soln.name)
          Command.Spec.empty
          (fun () -> Soln.solve In_channel.stdin Out_channel.stdout)
        in
        (Soln.name, cmd)))
  end
