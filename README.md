# plant-ontology
Repository for the Plant Ontology

What's in this folder?
This folder contains the most current working version of the Plant Ontology editors' file: plant_ontology.obo.  
All editing is done on the plant_ontology.obo file. New versions of the rest of the files are created only with new releases.

Note that as of Jan 2011, the Plant Ontology is now provided as a single file, which contains both the Plant Anatomical Entity branch and the Plant Structure Development Stage branch. 

Files in this folder:
* plant_ontology.obo: 
The editor's version of the plant ontology, in OBO format. Contains all relations. Relations that are inferred based on intersection_of relation are not asserted. 

Note that this file is subject to frequent changes, and may contain terms that will later destroyed (permanently deleted from the ontology, rather than made obsolete). Users should use this file with caution. 

For stable files that correspond to the most current live release (featured on the PO webpage), go into the folder: po-release-files.   These are updated with each release.
 	
https://github.com/Planteome/plant-ontology/tree/master/po-release-files
This folder contains copies of files prepared for the current release, 

For more details of the PO Release procedures please see: http://wiki.plantontology.org/index.php/PO_Release_SOP_Page

Files prepared for the current release (currently version 20):
* plant_ontology_assert.obo
- This version is the same as plant_ontology.obo with all nonredundant implied links asserted (added) by a reasoner.
 
- plant_ontology_assert_basic.obo
This version is the same as plant_ontology_assert.obo, but with only is_a and part_of relations. 

- po_anatomy.obo: 
This file is created by filtering plant_ontology_assert.obo to contain only terms from the plant anatomical entity branch. All cross-aspect relations have been removed.

- po_temporal.obo: 
This file is created by filtering plant_ontology_assert.obo to contain only terms from the plant structure development stage branch. All cross-aspect relations have been removed.
