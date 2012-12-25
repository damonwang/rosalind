.PHONY: all clean

all: _tags
	./build.sh

_tags: _oasis
	oasis setup
	ocaml setup.ml -configure

clean:
	ocaml setup.ml -clean
