
## OBO Library prefix
OBO=http://purl.obolibrary.org/obo
BASE=$(OBO)/$(ONT)
CAT=--use-catalog
SRC=plant-ontology.obo
ONT=po
ROBOT=robot
OWLTOOLS=owltools

all: all_imports po.obo po.owl all_subsets
all_subsets: subsets/po-basic.obo
test: $(ONT).owl
release: all
	echo "build successful. Now commit and push the derived files and make a release here: "

$(ONT).owl: $(SRC)
	$(ROBOT)  reason -x true -t true -i $< -r ELK relax reduce -r ELK annotate -V $(BASE)/releases/`date +%Y-%m-%d`/$(ONT).owl -o $@
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
	$(OWLTOOLS) $(USECAT) $< -o -f obo temp.obo.tmp && grep -v '^owl-axioms:' temp.obo.tmp > $@ && rm temp.obo.tmp

# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%.owl: $(SRC)
	$(OWLTOOLS) $(OBO)/$*.owl --remove-annotation-assertions -l -s -d -r --remove-dangling-annotations  -o $@
.PRECIOUS: mirror/%.owl

mirror/ncbitaxon.owl: 
	$(OWLTOOLS) $(OBO)/ncbitaxon/subsets/taxslim.owl --remove-annotation-assertions -l -s -d --remove-dangling-annotations  --set-ontology-id $(OBO)/ncbitaxon -o $@
.PRECIOUS: mirror/ncbitaxon.owl

# ----------------------------------------
# MINING DEAD SIMPLE DESIGN PATTERNS
# ----------------------------------------
MODDIR=modules
PATTERNDIR=patterns

#MODS = luminal_space_of gland_duct gland_acinus endochondral_bone endochondral_cartilage
MODS = cortex

# OWL->CSV
PSRC = plant-ontology.obo

# reverse engineer CSV from uberon axioms and DOSDPs
modules/%-ldef.csv: $(PSRC)
	blip-findall -debug odp -i $<  -u odputil -i $(PATTERNDIR)/po_patterns.pro "write_tuple($*)" > $@.tmp && mv $@.tmp $@
.PRECIOUS: modules/%.csv
modules/%-lex.csv: $(PSRC)
	blip-findall -debug odp -i $<  -u odputil -i $(PATTERNDIR)/po_patterns.pro "write_tuple_lex($*)" > $@.tmp && mv $@.tmp $@
.PRECIOUS: modules/%.csv

# currently, the pattern source is prolog - generate dosdp yaml from this
$(PATTERNDIR)/%.yaml: patterns/po_patterns.pro
	blip-findall -i $(PSRC)  -u odputil -i $(PATTERNDIR)/po_patterns.pro "write_yaml($*),fail" > $@.tmp && mv $@.tmp $@
.PRECIOUS: $(PATTERNDIR)/%.yaml
