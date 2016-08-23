## OBO Library prefix
OBO=http://purl.obolibrary.org/obo
BASE=$(OBO)/$(ONT)
CAT=
SRC=plant-ontology.obo
ONT=po
ROBOT=robot

all: po.obo po.owl 
test: all
release: all
	echo "build successful. Now commit and push the derived files and make a release here: "

$(ONT).owl: $(SRC)
	$(ROBOT)  reason -i $< -r ELK relax reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@
$(ONT).obo: $(ONT).owl
	$(ROBOT) convert -i $< -f obo -o $(ONT).obo.tmp && mv $(ONT).obo.tmp $@

reasoner-report.txt: plant-ontology.obo
	owltools $(CAT) $< --run-reasoner -r elk -u > $@.tmp && egrep '(INFERENCE|UNSAT)' $@.tmp > $@

# TODO: switch to using robot
subsets/po-basic.obo: target/po-simple.obo
	owltools $(CAT) $< --make-subset-by-properties BFO:0000050 // --set-ontology-id $(OBO)/po/subsets/po-basic.owl -o -f obo $@
