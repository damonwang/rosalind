open OUnit
open Core.Std
open Core_extended.Std

let assert_string_equal got expected =
  assert_equal ~cmp:String.(=) ~printer:Fn.id got expected

let fasta_tests =
  let open Rosalindlib in
  "fasta" >:::
    [ "of_string" >:: (fun () ->
      let fasta = Fasta.of_string ">foo\nAGCT\n" in
      assert_string_equal "foo" fasta.Fasta.name;
      assert_string_equal "" fasta.Fasta.description;
      assert_string_equal "AGCT" fasta.Fasta.sequence)
    ]

let whole_program_tests =
  "whole-program" >::: List.map Solutions.Std.synchronous ~f:(fun m ->
    let module Soln = (val m : Solutions.Synchronous_intf.S) in
    let name name ext = sprintf "whole-program-data/%s.%s" name ext in
    let infname = name Soln.name "in" in
    let outfname = name Soln.name "out" in
    Soln.name >:: bracket_tmpfile (fun (name, out_ch) ->
      In_channel.with_file ~binary:false infname ~f:(fun in_ch ->
        Soln.solve in_ch out_ch);
      Out_channel.close out_ch;
      assert_equal ~cmp:String.(=) ~printer:Fn.id "" begin
        try Shell.run_full "diff" [outfname; name ] with
        | Shell.Process.Failed result -> result.Shell.Process.stdout
      end))

let _ = run_test_tt_main begin
  TestList [ whole_program_tests
           ; fasta_tests
           ]
end
