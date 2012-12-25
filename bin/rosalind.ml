open Core.Std

let () =
  Command.run begin
    Command.group ~summary:"solve the Rosalind puzzles"
      [ Dna.Cmd.name, Dna.Cmd.cmd
      ; Rna.Cmd.name, Rna.Cmd.cmd
      ; Revc.Cmd.name, Revc.Cmd.cmd
      ]
  end
