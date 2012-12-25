open Core.Std

let () =
  Command.run begin
    Command.group ~summary:"solve the Rosalind puzzles"
      [ Dna.Cmd.name, Dna.Cmd.cmd ]
  end
