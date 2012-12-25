open OUnit
open Core.Std
open Core_extended.Std

let make_test soln infname outfname =
  let module Soln = (val soln : Solutions.Synchronous_intf.S) in
  Soln.name >:: bracket_tmpfile (fun (name, out_ch) ->
    In_channel.with_file ~binary:false infname ~f:(fun in_ch ->
      Soln.solve in_ch out_ch);
    Out_channel.close out_ch;
    assert_equal ~cmp:String.(=) ~printer:Fn.id "" begin
      try Shell.run_full "diff" [ outfname; name ] with
      | Shell.Process.Failed result -> result.Shell.Process.stdout
    end)

let make_whole_program_test soln =
  let module Soln = (val soln : Solutions.Synchronous_intf.S) in
  let fname name ext = sprintf "whole-program-data/%s.%s" name ext in
  make_test soln (fname Soln.name "in") (fname Soln.name "out")

let whole_program_tests =
  "whole-program" >::: List.map ~f:make_whole_program_test
    Solutions.Std.synchronous

let () = ignore (run_test_tt_main whole_program_tests)
