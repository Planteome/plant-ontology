# Plant Ontology Editors' Guide

This repository contains the most current, working version of the Plant Ontology editors' file: plant-ontology.obo

Note that if you are NOT a Planteome ontology developer then you are probably in the wrong place.

All editing is done on the plant-ontology.obo file 

** DO NOT EDIT po.obo OR po.owl **

Files in this repository:

* plant-ontology.obo: 
The editor's version of the Plant Ontology, in OBO format. Contains all relations. Relations that are inferred based on intersection_of relation are not asserted. 

Note that this file is subject to frequent changes, and may contain terms that will later destroyed (permanently deleted from the ontology, rather than made obsolete). Users should use this file with caution. 

* plant-ontology-dev.txt
A text version of the plant-ontology.obo editors' file, automatically created nightly

* plant-ontology.obo.owl

An OWL version of the plant-ontology.obo editors' file, automatically created nightly

New versions of the following two files are created only with new releases:

* po.obo

The current Release file of the Plant Ontology, in OBO format.  All relations that are inferred are asserted in the release process

* po.owl

The current release file of the Plant Ontology, in OWL format. All relations that are inferred are asserted in the release process

All releases can be found here:   https://github.com/Planteome/plant-ontology/releases 	

## ID Ranges

http://wiki.plantontology.org/index.php/Accession_IDS_Guide

** Please only use IDs within your range!! **

## Setting ID ranges in Protege

Please see the guide on obofoundry.org
 
## Git Quick Guide

TODO add instructions here

## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, and the Travis build passes.

to release, change into this directory, and type

    make release

This generates derived files such as po.owl and po.obo. The version IRI
will be added.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

Finally type

    git push origin master

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/Planteome/plant-ontology/releases/
 * https://github.com/Planteome/plant-ontology/releases/new

The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the version IRI of the derived po.owl (data-version in
po.obo).

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "January release")

Then click "publish release"

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies. Try it!

 * http://purl.obolibrary.org/obo/po.owl <-- current ontology PURL
 * http://purl.obolibrary.org/obo/po/releases/YYYY-MM-DD.owl <-- change to the release you just made

For questions on this contact Chris Mungall or email obo-admin AT obofoundry.org

# Travis Continuous Integration System

Check the build status here: [![Build Status] 
(https://travis-ci.org/Planteome/to.svg?branch=master)](https://travis-ci.org/Planteome/plant-ontology)

This replaces Jenkins for this ontology

## General Guidelines

See:
http://wiki.geneontology.org/index.php/Curator_Guide:_General_Conventions


