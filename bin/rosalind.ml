open Core.Std

let () =
  Command.run begin
    Command.group ~summary:"solve the Rosalind puzzles"
      (List.map ~f:(fun soln ->
        let module Intf = Solutions.Synchronous_intf in
        let module Soln = (val soln : Solutions.Synchronous_intf.S) in
        (Soln.name, Soln.cmd))
         [ (module Solutions.Dna.Cmd : Solutions.Synchronous_intf.S)
         ; (module Solutions.Rna.Cmd : Solutions.Synchronous_intf.S)
         ; (module Solutions.Revc.Cmd : Solutions.Synchronous_intf.S)
         ; (module Solutions.Gc_content.Cmd : Solutions.Synchronous_intf.S)
         ])
  end
