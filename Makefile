.PHONY: all clean test

all: _tags
	./build.sh

_tags: _oasis
	oasis setup
	ocaml setup.ml -configure --enable-tests
	touch _tags

clean:
	ocaml setup.ml -clean

test:
	ocaml setup.ml -test
