MLNAMES = rosalind dna rna
OBJS = $(addsuffix .native, $(MLNAMES))

.PHONY: $(OBJS)

$(OBJS): %.native: %.ml
	./build.sh $@
