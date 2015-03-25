out.svg: in.svg mathpuzzle.pl
	perl mathpuzzle.pl $(OPTS) < in.svg > out.svg

