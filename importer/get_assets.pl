#!/usr/bin/perl
#
# Get all files that could be local assets.
# 2020-12-09
#

# Absolute path, no ~
my $assets_dir = "/home/reinoso/pruebas-blog/docs/assets";

use strict;
use warnings;
use Data::Dumper;
use LWP::Simple;
#print "\n\n".Dumper(\%parts)."\n\n";


# ---
# key: value
# key:
# - value1
# - value2
# ---
# <space>
# body

sub getfile {
	my ($url, $local) = @_;

}



my $filename = $ARGV[0] or die "Usage: $0 yyyy-mm-dd-posttitle.html\n";

my ($year, $mon, $day, $title) = $filename =~ m{^.*/(\d+)-(\d+)-(\d+)-(.+)\.html$} or 
	die "Filename $filename non conformant.\n";

open my $fh, $filename or die "$!\n";
my $content = do { local $/; <> };
close $fh;

my ($head, $body) = $content =~ m/^---$(.+?)^---$(.*)/ms;

my (@hrefs) = $body =~ m{(href|src)="([^"]+)"}g;

for my $link (@hrefs) {
	# Need the raw name as-is unescaped
	$link =~ s/#.*$//; # this is local to browser
	my ($file) = $link =~ m{.*/([^/]+\.[a-z]\w+)($|\?.*)}i;

	if (not $file) {
		#print "Debug: No file in link $link\n";
	}

	elsif ($link =~ m{bp.blogspot.com}) {

		$file =~ s/%25/%/g;
		$file =~ s/%../-/g;
		
		# Check if exists or not
		if (-e "$assets_dir/$year/$mon/$title/img/$file") {
			#print "Debug: Blog image '$file' ($link): File exists.\n";
		}
		else {
			print "Warning: Blog image '$file' ($link): File not found!\n";
		}
	}

	elsif ($link =~ /electronicayciencia\.blogspot\.com/) {
		#print "Debug: Internal post link to $link.\n";
	}

	elsif ($file =~ /\.(cfm|js|aspx|cgi|g|do|asp|shtml|html|htm|php)$/i) {
		#print "Debug: External resource '$file' do not download from $link.\n";

	}
	elsif ($file !~ /\./) {
		#print "Debug: No extension file. Do not download from $link.\n";
	}
	elsif ($file =~ /\.(mp3|wav|font|cfm|cpp|pl|pm|m|c|h|py|pdf|doc|docx|xlsx|xls|zip|rar|txt|jpg|gif|png|svg|dat)$/i) {
		#print "External file '$file' downloadable from $link.\n";
		
		$file =~ s/%25/%/g;
		$file =~ s/%../-/g;
		
		my $localfile = "$assets_dir/$year/$mon/$title/$file";

		# Check if exists or not
		if (-e $localfile) {
		  #print "Debug: Asset '$localfile' ($link) already exists.\n";
		}
		else {
			print "Debug: downloading $link to $localfile\n";
			#getstore($link, $localfile) or print "Warning: $!\n";
		}
	}

	else {
		print "Warning: What is this? $link\n";
	}
}


