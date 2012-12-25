<Solutions to the [Rosalind Project](http://rosalind.info/) in
[Ocaml](http://ocaml.org/) using the
[Core](https://bitbucket.org/yminsky/ocaml-core/wiki/Home) alternative
standard library implementation.

This check-in demonstrates an error in the build process which is mysteriously solved by adding

     CompiledObject: native

to the executable section of _oasis.  The error is

    + ocamlfind ocamlc -g threads.cma -thread -linkpkg -package variantslib.syntax -package sexplib.syntax -package fieldslib.syntax -package core_extended -package core -package comparelib.syntax -package bin_prot.syntax bin/dna.cmo bin/revc.cmo bin/rna.cmo bin/rosalind.cmo -o bin/rosalind.byte
    /home/damonwang/.opam/4.01.0dev+endian/lib/core/libcore_stubs.a(unix_stubs.o): In function `unix_initgroups':
    /home/damonwang/.opam/4.01.0dev+endian/build/core.108.08.00/_build/lib/unix_stubs.c:1235: multiple definition of `unix_initgroups'
    /home/damonwang/.opam/4.01.0dev+endian/lib/ocaml/libunix.a(initgroups.o):initgroups.c:(.text+0x0): first defined here
    /home/damonwang/.opam/4.01.0dev+endian/lib/core/libcore_stubs.a(unix_stubs.o): In function `unix_nice':
    /home/damonwang/.opam/4.01.0dev+endian/build/core.108.08.00/_build/lib/unix_stubs.c:1458: multiple definition of `unix_nice'
    /home/damonwang/.opam/4.01.0dev+endian/lib/ocaml/libunix.a(nice.o):nice.c:(.text+0x0): first defined here
    collect2: error: ld returned 1 exit status
    File "_none_", line 1:
    Error: Error while building custom runtime system
    Command exited with code 2.
    Compilation unsuccessful after building 20 targets (19 cached) in 00:00:00.
    E: Failure("Command ''/home/damonwang/.opam/4.01.0dev+endian/bin/ocamlbuild' lib/rosalind_general.cma lib/rosalind_general.cmxa lib/rosalind_general.a lib/rosalind_general.cmxs bin/rosalind.byte -tag debug' terminated with error code 10")
