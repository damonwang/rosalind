MLNAMES = rosalind dna
OBJS = $(addsuffix .native, $(MLNAMES))

.PHONY: $(OBJS)

$(OBJS): %.native: %.ml
	./build.sh $@
