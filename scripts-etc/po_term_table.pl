#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(strftime);

if ($#ARGV != 1) {
		print "usage: po_term_table.pl obo_file output_file\n";
		exit;
}

my $obofile = $ARGV[0];
my $outfile = $ARGV[1];

open(OBO, "$obofile");
open(OUTFILE, ">$outfile");

my $version = `git log --pretty=format:"%h" -n 1 $obofile | awk '{print "git Version: ",\$1}'`;
chomp $version;
my $date = strftime "%m-%d-%Y", localtime;
print OUTFILE "$date\t$version\n";

print OUTFILE "id\tname\tdefn\tsynonyms\tis_a id\tis_a name\n";

my $id = "";
my $name = "";
my $def = "";
my $synonym = "";
my $isa_id = "";
my $isa_name = "";

while (my $line = <OBO>) {
		chomp $line;
		$line =~ s/\s\[.+\]//g;
		$line =~ s/\s\[\]//g;
		$line =~ s/\"//g;
		
		if ($line =~ m/^id:/) {
				if ($id ne "") {
						print OUTFILE "$id\t$name\t$def\t$synonym\t$isa_id\t$isa_name\n";
				}
				$id = "";
				$name = "";
				$synonym = "";
				$def = "";
				$isa_id = "";
				$isa_name = "";
				$line =~ s/^id: //;
				$id = $line;
		}elsif ($line =~ m/^name:/) {
				$line =~ s/^name: //;
				$name = $line;
		}elsif ($line =~ m/^def:/) {
				$line =~ s/^def: //;
				$def = $line;
		}elsif ($line =~ m/^synonym:/) {
				$line =~ s/^synonym: //;
				$line =~ s/EXACT Spanish/EXACT/g;
				$line =~ s/EXACT Japanese/EXACT/g;
				if($synonym eq "") {
						$synonym = $line;
				}else{
						$synonym = "$synonym; $line";
				}
		}elsif ($line =~ m/^is_a:/) {
				$line =~ s/^is_a: //;
				$line =~ /(\w+:\d+)\s\!\s(.+)/;
				if($isa_id eq "") {
						$isa_id = $1;
						$isa_name = $2;
				}else{
						$isa_id = "$isa_id; $1";
						$isa_name = "$isa_name; $2";
				}
		}
}

print OUTFILE "$id\t$name\t$def\t$synonym\t$isa_id\t$isa_name\n";

close (OBO);
close (OUTFILE);

