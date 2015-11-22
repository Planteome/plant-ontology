## OBO Library prefix
OBO=http://purl.obolibrary.org/obo

#CAT=--catalog-xml catalog-v001.xml
CAT=
SRC=plant-ontology.obo

all: plant-ontology-reasoned.obo target/po.obo
test: all

plant-ontology.obo.owl: plant-ontology.obo 
	robot convert -i $<  -o $@

plant-ontology-reasoned.owl: plant-ontology.obo
	robot reason -i $< -r ELK -o $@
plant-ontology-reasoned.obo: plant-ontology-reasoned.owl
	robot convert -i $< -f OBO -o $@

reasoner-report.txt: plant-ontology.obo
	owltools $(CAT) $< --run-reasoner -r elk -u > $@.tmp && egrep '(INFERENCE|UNSAT)' $@.tmp > $@

target/po.obo: $(SRC)
	ontology-release-runner $(CAT)  $< --reasoner elk --simple --skip-format owx --outdir target --run-obo-basic-dag-check
target/po.owl: target/po.obo

po.owl: target/po.owl
	cp $< $@
po.owl: target/po.owl
	cp $< $@

subsets/po-basic.obo: target/po.obo
	owltools $(CAT) $< --remove-imports-declarations  --make-subset-by-properties -f // --set-ontology-id $(OBO)/po/subsets/po-basic.owl -o -f obo $@

