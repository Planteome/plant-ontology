#!/usr/bin/perl

use strict;
use warnings;

if ($#ARGV != 1) {
		print "usage: po_term_table_to_js.pl term_table_file output_file\n";
		exit;
}

my $termfile = $ARGV[0];
my $outfile = $ARGV[1];

open(TERM, "$termfile");
open(OUTFILE, ">$outfile");

print OUTFILE "var dataSet = [\n";

while(<TERM>) {
		my $line = $_;
		chomp $line;
		if($line !~ /^PO/) {
				next;
		}
                if($line =~ /OBSOLETE/) {
                        next;
                }
		
		my ($id, $name, $namespace, $defn, $synonyms, $isaid, $isaname) = split("\t", $line);
		print OUTFILE "   [ \"$name\", \"$namespace\", \"<a href=\\\"https://browser.planteome.org/amigo/term/$id\\\">$id</a>\", \"$defn\" ],\n";
}
print OUTFILE "];\n";
close(OUTFILE);
