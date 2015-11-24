## OBO Library prefix
OBO=http://purl.obolibrary.org/obo

#CAT=--catalog-xml catalog-v001.xml
CAT=
SRC=plant-ontology.obo

all: po.obo po.owl
test: all

#plant-ontology-reasoned.owl: plant-ontology.obo
#	robot reason -i $< -r ELK -o $@
#plant-ontology-reasoned.obo: plant-ontology-reasoned.owl
#	robot convert -i $< -f OBO -o $@

reasoner-report.txt: plant-ontology.obo
	owltools $(CAT) $< --run-reasoner -r elk -u > $@.tmp && egrep '(INFERENCE|UNSAT)' $@.tmp > $@

target/po.obo target/po.owl target/po-simple.obo: $(SRC)
	ontology-release-runner $(CAT)  $<  --allow-overwrite --reasoner elk --simple --skip-format owx --outdir target --run-obo-basic-dag-check
target/po.owl: target/po.obo

po.owl: target/po.owl
	cp $< $@
po.obo: target/po.obo
	cp $< $@

subsets/po-basic.obo: target/po-simple.obo
	owltools $(CAT) $< --make-subset-by-properties BFO:0000050 // --set-ontology-id $(OBO)/po/subsets/po-basic.owl -o -f obo $@
