BASE = calcP++
BISON = bison
CXX = g++
FLEX = flex 
XSLTPROC = xsltproc 

all: $(BASE)

%.cc %.hh %.html %.gv: %.yy
	$(BISON) $(BISONFLAGS) --xml --graph -o $*.cc $<

%.cc: %.ll
	$(FLEX) $(FLEXFLAGS) -o$@ $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o$@ $<

$(BASE): $(BASE).o driverP.o parserP.o scannerP.o
	$(CXX) -o $@ $^

$(BASE).o: parserP.hh
parserP.o: parserP.hh
scannerP.o: parserP.hh

run: $(BASE)
	@echo "Apreta Ctrl+D para salir."
	./$< -

html: parserP.html
%.html: %.xml
	$(XSLTPROC) %(XSLTPROCFLAGS) -o $@ $$($(BISON) --print-datadir)/xslt.xml2xhtml.xsl $<

CLEANFILES = 					\
	$(BASE) *.o					\
	parserP.hh parserP.gv parserP.cc parserP.output parserP.xml parserP.html location.hh	\
	scannerP.cc

clean:
	rm -f $(CLEANFILES)
