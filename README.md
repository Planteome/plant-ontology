# plant-ontology
Repository for the Plant Ontology

What's in this folder?
This folder contains the most current working version of the Plant Ontology editors' file: plant-ontology.obo.  
All editing is done on the plant-ontology.obo file. New versions of the rest of the files are created only with new releases.

Note that as of Jan 2011, the Plant Ontology is now provided as a single file, which contains both the Plant Anatomical Entity branch and the Plant Structure Development Stage branch. 

Files in this folder:
* plant-ontology.obo: 
The editor's version of the plant ontology, in OBO format. Contains all relations. Relations that are inferred based on intersection_of relation are not asserted. 

Note that this file is subject to frequent changes, and may contain terms that will later destroyed (permanently deleted from the ontology, rather than made obsolete). Users should use this file with caution. 

For stable files that correspond to the most current live release (featured on the PO webpage), go into the folder: po-release-files.   These are updated with each release.
 	
https://github.com/Planteome/plant-ontology/tree/master/po-release-files
This folder contains copies of files prepared for the current release. 

For more details of the PO Release procedures please see: http://wiki.plantontology.org/index.php/PO_Release_SOP_Page

Files prepared for the current release (currently version 21):
* plant-ontology-assert.obo
- This version is the same as plant-ontology.obo with all nonredundant implied links asserted (added) by a reasoner.
 
- plant-ontology-assert-basic.obo
This version is the same as plant-ontology-assert.obo, but with only is_a and part_of relations. 

- plant-ontology-anatomy.obo: 
This file is created by filtering plant-ontology-assert.obo to contain only terms from the plant anatomical entity branch. All cross-aspect relations have been removed.

- plant-ontology-temporal.obo: 
This file is created by filtering plant-ontology-assert.obo to contain only terms from the plant structure development stage branch. All cross-aspect relations have been removed.

Other files: 
- Creative_Commons_License.txt
- translations of PAE terms in Spanish and English
- text format versions of the plant-ontology.obo files
