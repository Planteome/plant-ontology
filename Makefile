## OBO Library prefix
OBO=http://purl.obolibrary.org/obo
BASE=$(OBO)/$(ONT)
CAT=--use-catalog
SRC=plant-ontology.obo
ONT=po
ROBOT=robot
OWLTOOLS=owltools

all: po.obo po.owl all_subsets
all_subsets: subsets/po-basic.obo
test: all_subsets
release: all
	echo "build successful. Now commit and push the derived files and make a release here: "

$(ONT).owl: $(SRC)
	$(ROBOT)  reason -x true -i $< -r ELK relax reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@
$(ONT).obo: $(ONT).owl
	$(OWLTOOLS) $(CAT) $< -o -f obo --no-check $(ONT).obo.tmp && grep -v '^owl-axioms:' $(ONT).obo.tmp > $@ && rm $(ONT).obo.tmp
#	$(ROBOT) convert -i $< -f obo -o $(ONT).obo.tmp && grep -v '^owl-axioms:' $(ONT).obo.tmp > $@ && rm $(ONT).obo.tmp

reasoner-report.txt: plant-ontology.obo
	owltools $(CAT) $< --run-reasoner -r elk -u > $@.tmp && egrep '(INFERENCE|UNSAT)' $@.tmp > $@

# TODO: switch to using robot
subsets/po-basic.obo: po.obo
	owltools $(CAT) $< --remove-imports-declarations --make-subset-by-properties -f BFO:0000050 // --set-ontology-id $(OBO)/po/subsets/po-basic.owl -o -f obo $@

# ----------------------------------------
# Imports
# ----------------------------------------

IMPORTS = ncbitaxon
IMPORTS_OWL = $(patsubst %, imports/%_import.owl,$(IMPORTS)) $(patsubst %, imports/%_import.obo,$(IMPORTS))

# Make this target to regenerate ALL
all_imports: $(IMPORTS_OWL)

# Use ROBOT, driven entirely by terms lists NOT from source ontology
imports/%_import.owl: mirror/%.owl imports/%_terms.txt
	$(ROBOT) extract -i $< -T imports/$*_terms.txt --method BOT -O $(BASE)/$@ -o $@
.PRECIOUS: imports/%_import.owl

imports/%_import.obo: imports/%_import.owl
	$(OWLTOOLS) $(USECAT) $< -o -f obo $@

# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%.owl: $(SRC)
	$(OWLTOOLS) $(OBO)/$*.owl --remove-annotation-assertions -l -s -d --remove-dangling-annotations  -o $@
.PRECIOUS: mirror/%.owl

mirror/ncbitaxon.owl: 
	$(OWLTOOLS) $(OBO)/ncbitaxon/subsets/taxslim.obo --remove-annotation-assertions -l -s -d --remove-dangling-annotations  --set-ontology-id $(OBO)/ncbitaxon -o $@
.PRECIOUS: mirror/ncbitaxon.owl
