#!/usr/bin/perl
#
# Posts post-processor.
#
# Dirty (but -sadly- not quick) script to apply after blogspot->jekyll importer.
#
# 2020-12-06
#

# Where to search for a blog post file during local link replacement.
my $postsdir = "_posts";
my $description_file = "descriptions.dat";
my $default_description = "";
my $assets_local_dir = "/home/reinoso/pruebas-blog/docs/assets";
my $assets_base_url = "/assets";
my $newmetafile = "newmeta.yml";

binmode STDOUT, ':raw';

use strict;
use warnings;
use Data::Dumper;
use YAML::XS qw/Load Dump LoadFile/;
use File::Basename;

# ---
# key: value
# key:
# - value1
# - value2
# ---
# <space>
# body


my %parts;
my $featured_image;
my $assets_url;
my $assets_local;

# Get description from title.
# beware with ':'
sub get_description {
	my $title = shift;
	open my $fh, "< $description_file" or 
		print STDERR "Warning: cannot open description file\n" and return;
	while (<$fh>) {
		chomp;
		my ($t, $d) = /"(.+)";"(.*)"/ or next;
		return $d if ($t eq $title);
	}
	close $fh;
	return $default_description;
}

# Return the relative url for file name
sub get_assets_location {
	my $filename = shift;
	my ($year, $mon, $day, $title) = $filename =~ m{^.*/(\d+)-(\d+)-(\d+)-(.+)\.html$} or 
		die "Filename $filename non conformant.\n";
	
	return ("$assets_base_url/$year/$mon/$title", "$assets_local_dir/$year/$mon/$title");
}


sub parts_store {
	my $str = shift;
	my $type = shift || "part";
	
	my %inpara = (
	 	link => 1,
		postlink => 1,
		'spanmono-line' => 0, # there are spans inside of divs
		
		paragraph => 0,
		table => 0,
		img => 0,
		eqn => 0,  # display
		codeblock => 0,
		'divmono-line' => 0,
		'divmono-block' => 0,
		'spanmono-block' => 0,
		monogroup => 0,
		section => 0,
		object => 0,
		ol => 0,
		ul => 0,
		quote => 0,
	  );

	my $delimiter_in = "";
	my $delimiter_out = "";

	# This object can be inside a paragraph or not?
	if (not defined $inpara{$type}) {
		printf STDERR "Unknown object type: $type.\n";
		return "";
	}
	elsif ($inpara{$type} == 1) {
		$delimiter_in = '--##';
		$delimiter_out = '##--';  # inside para
	}
	else {
		$delimiter_in = '||##';
		$delimiter_out = '##||';
	}

	$parts{_counter}{$type}++;

	my $counter = $parts{_counter}{$type};
	my $id = "$type-$counter";

	$parts{$id} = $str;	

	return $delimiter_in.$id.$delimiter_out;
}


# Regenerate text from parts
sub recompose {
	my $structure = shift;
	my $text;

	# outer elements
	for my $element ($structure =~ m{\|\|##([-\w]+-\d+)##\|\|}g) {
		my ($type, $num) = $element =~ /([-\w]+)-(\d+)/;

		if ($type eq "paragraph") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "object") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "img") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "section") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "quote") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "table") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "eqn") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "codeblock") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "ol" or $type eq "ul") {
			$text .= $parts{$element}."\n\n";
		}
		# Un-grouped mono elements
		elsif ($type eq "spanmono-line" or $type eq "divmono-line") {
			$text .= $parts{$element}."\n\n";
		}
		elsif ($type eq "spanmono-block" or $type eq "divmono-block") {
			$text .= $parts{$element}."\n\n";
		}
		# Mono elements part of a group
		elsif ($type eq "monogroup") {
			for my $monoelement ($parts{$element} =~ m{\|\|##([-\w]+-\d+)##\|\|}g) {
				my ($type, $num) = $monoelement =~ /([-\w]+)-(\d+)/;
				#print STDERR "Debug: monoelement($type - $num) = $parts{$monoelement}\n";
				$text .= $parts{$monoelement}."\n";
			}
		    $text .= "\n";	
		}
		else {
			print STDERR "Warning: unknown type '$type' recomposing: '$element'.\n"
		}
	}

	# inner elements
	for my $element ($text =~ m{--##([-\w]+-\d+)##--}g) {
		my ($type, $num) = $element =~ /([-\w]+)-(\d+)/;

		if ($type eq "link") {
			$text =~ s{--##$element##--}{$parts{$element}};
		}
		elsif ($type eq "postlink") {
			$text =~ s{--##$element##--}{$parts{$element}};
		}
		else {
			print STDERR "Warning: unknown type '$type' recomposing: '$element'.\n";
		}
	}

	$text =~ s{^\s+}{}g;
	$text =~ s{\s+$}{}g;

	if ($text =~ m{\|\|##} or $text =~ m{--##}) {
			print STDERR "Warning: incomplete substitution.\n";
	}

	return $text;
}


sub getlang {
  	my $c = shift;

	if ($c =~ m{my\s+\$}) {
	    return "perl";
	}

	if ($c =~ m{subplot} or $c =~ m{^\s*%}m or $c =~ m{\w+\(:,\d+\)}) {
	    return "matlab";
	}

	if ($c =~ m{#define} or $c =~ m{int main}) {
	    return "c";
	}

	return "";
}


sub html2md {
  	my $s = shift;
	my $vars_allowed = shift; # image captions do not allow variables

	# Remove empty
	$s =~ s{<b>\s*</b>}{}g;
	$s =~ s{<em>\s*</em>}{}g;
	$s =~ s{<b>\s*</b>}{}g;
	$s =~ s{<em>\s*</em>}{}g;

	# Go to markdown
	$s =~ s{<b>}{**}g;
	$s =~ s{</b>}{**}g;
	$s =~ s{<em>}{*}g;
	$s =~ s{</em>}{*}g;
	
	# Links
	$s =~ s{<a[^>]*href="([^"]+)"[^>]*>(.*?)</a>}{format_link($1, $2, $vars_allowed)}ge;

	# Font size or color: deprecated
	# wait until monospaced divs/spans have been identified
	$s =~ s{<span [^>]*font-size:[^>]*>(.*?)</span>}{$1}g;
	$s =~ s{<span [^>]*Apple-style-span[^>]*>(.*?)</span>}{$1}g;
	$s =~ s{<span [^>]*color[^>]*>(.*?)</span>}{$1}smg;
	$s =~ s{<div [^>]*color[^>]*>(.*?)</div>}{$1  \n}smg;
	$s =~ s{<div [^>]*font-family: inherit;[^>]*>(.*?)</div>}{$1  \n}smg;

	$s =~ s{<span[^>]*>(.*?)</span>}{$1}g;

	return $s;
}


sub trim {
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}


# Needs global variable assets.
# Arguments: 
#   meta: a hashref from YAML Load.
#   newmeta: hashref with new metadata structure
# Output:
#   a hashref with the new head
sub process_head {
	my $meta = shift;
	my $newmeta = shift;

	my %meta = %{$meta}; # more confortable

	# Remove date headers from front matter. 
	# Cause issues with timezone and relative links.
	delete $meta{date};
	delete $meta{modified_time};
	
	# Author is always the same
	delete $meta{author};

	# Blogger ID is not needed
	delete $meta{blogger_id};
	delete $meta{blogger_orig_url};
	delete $meta{thumbnail};

	# Add featured image and assets
	$meta{assets} = $assets_url if $assets_url;
	$meta{image} = "$assets_url/img/$featured_image" if $featured_image;

	# Merge new metadata (if present)
	if ($newmeta) {
		my %newmeta = %{$newmeta};
		$meta{description} = $newmeta{description} if $newmeta{description};
		$meta{featured} = "true" if $newmeta{featured};
		$meta{tags} = $newmeta{tags};
	}

	return \%meta;
}


# Format an image include
sub format_image {
	my ($name, $width, $caption) = @_;

	print STDERR "DEBUG: Image name: $name, Width: $width\n";

	$name =~ s/%25/%/g;
	$name =~ s/%../-/g;

	# Not here, because image order may be different if first image has no caption but second does.
	#if (not defined $featured_image) {
	#	$featured_image = $name;
	#}

	# remove caption format
	$caption =~ s{<span.*?>}{}g;
	$caption =~ s{</span>}{}g;

	# seriously, also format on br tags: <br style="..."/>
	$caption =~ s{<br.*?>}{<br />}g;
	
	# Replace breaks
	$caption =~ s{(\s*<br[^>]*>\s*)+}{  \n}g;

	$caption =~ s{\sEP}{ EyC}g;

	$caption = html2md($caption, 0); # no vars allowed.

	# escape quotes
	$caption =~ s{"}{\\"}g;

	# Blogger standard sizes (width):
	#   small   200px
	#   medium  320px
	#   large   400px
	#   x-large 640px
	# Is size standard?
	my $class;
	
	if ($width eq "") {
		$class = "original-width";
	}
	elsif ($width < (200+320)/2) {
		$class = "small-width";
	}
	elsif ($width < (320+400)/2) {
		$class = "medium-width";
	}
	elsif ($width < (400+640)/2) {
		$class = "large-width";
	}
	else {
		$class = "x-large-width";
	}

	my $string = "{% include image.html class=\"${class}\" file=\"$name\" caption=\"$caption\" %}";
	return parts_store($string, "img");
}

sub link_post_to_local {
	my ($route, $text) = @_;
	my $postname;

	#print STDERR "Getting link for $route ($text)...\n";

	my ($year, $mon, $name) = $route =~ m{(\d+)/(\d+)/(.+)};

	my @files = glob("$postsdir/$year-$mon-*$name*");
	if (scalar @files != 1) {
		print STDERR "Warning: no file or multiple files for '$name'.\n";
		return parts_store("[$text]()", "postlink");
	}

	if ($files[0] =~ m{.*/(.*?)\..{1,4}}) {
		$postname = $1;
	}
	else {
		print STDERR "Warning: unknown post file for '$name'.\n";
		return parts_store("[$text]()", "postlink");
	}

	return parts_store("[$text]({{site.baseurl}}{% post_url $postname %})", "postlink");
}


sub format_pre {
	my $block = shift;
	my $lang = "";

	if ($block =~ m{name="code"}) {
	    ($lang) = $block =~ /class="([^"]+)"/;
		#print STDERR "Code block: $lang\n";
	}

	if (not $block =~ m{<pre[^>]*>(.*?)</pre>}ms) {
		print STDERR "Warning: unknown pre format: '$block'.\n";
		return $block;
	}

	my $c = $1;

	$c =~ s{<br>}{\n}mg;

	$c =~ s{&lt;}{<}g;
	$c =~ s{&gt;}{>}g;
	$c =~ s{&amp;}{&}g;

	# Pre inside markdown does not support formats
	$c =~ s{<b>}{}g;
	$c =~ s{</b>}{}g;
	$c =~ s{<em>}{}g;
	$c =~ s{</em>}{}g;
	$c =~ s{<span[^>]*>(.*?)</span>}{$1}smg;
	$c =~ s{<div[^>]*>(.*?)</div>}{$1}smg;
	$c =~ s{<span[^>]*>(.*?)</span>}{$1}smg;
	$c =~ s{<div[^>]*>(.*?)</div>}{$1}smg;


	# prevent empty line at the end of the block
	$c =~ s{\n+$}{}g;
	$c =~ s{^\n+}{}g;
	
	$lang = getlang($c) || $lang;
	
	return parts_store("```$lang\n$c\n```", "codeblock");
}

sub format_list {
	my ($block, $tag) = @_;

	if (not $block =~ m{<[ou]l[^>]*>(.*?)</[ou]l>}ms) {
		print STDERR "Warning: unknown list format: '$block'.\n";
		return $block;
	}

	my $c = $1;

	$c = html2md($block);

	my @items = $c =~ m{<li>(.*?)</li>}gm;

	return "" unless @items;
	
	map (html2md($_), @items);
	map (s{(<br>|\s+)+$}{}g, @items);
	map (s{^(<br>|\s+)+}{}g, @items);
	
	#- list item
	#  
	#  continuation
	#
	#- list item 2
	map (s{(<br>)+}{\n\n  }g, @items);


	$tag eq "ul" and s/^/- / for @items;
	$tag eq "ol" and s/^/1. / for @items;

	return parts_store(join("\n", @items), $tag);
}


# Pre lines in markdown cannot have tags
sub format_monospace {
	my ($block, $tag) = @_;

	# Remove format tags
	$block =~ s{<div[^>]*>}{}g;
	$block =~ s{</div>}{}g;
	$block =~ s{<span[^>]*>}{}g;
	$block =~ s{</span}{}g;
	$block =~ s{<b>}{}g;
	$block =~ s{</b>}{}g;
	$block =~ s{<em>}{}g;
	$block =~ s{</em>}{}g;
	$block =~ s{&lt;}{<}g;
	$block =~ s{&gt;}{>}g;
	$block =~ s{&amp;}{&}g;

	# Replace br and trim
	$block =~ s{<br>}{\n}g;
	$block =~ s{\n+$}{}g;
	$block =~ s{^\n+}{}g;

	$block =~ s{^}{    }mg; # indent 4 spaces

	# It's just one line or multiple lines?
	if ($block =~ /\n/) {
		return parts_store("$block", "${tag}mono-block");
	}
	else {
		return parts_store("$block", "${tag}mono-line");
	}
}

sub format_blockquote {
	my $block = shift;

	# Remove format tags
	$block =~ s{<span[^>]*>}{}g;
	$block =~ s{</span>}{}g;

	$block =~ s{<br>}{\n}g;
	$block =~ s{^}{> }gm;
	
	# Not needed and can cause problems
	#$block =~ s{<em></em>}{}g;  # empty tags
	#$block =~ s{<em>(.+)</em>}{*$1*}g;  # italic tags

	$block =~ s{<em>}{}g;  # italic tags not supported on blockquote
	$block =~ s{</em>}{}g;
	
	$block =~ s{<quote>}{}g; # not needed
	$block =~ s{</quote>}{}g;
	
	$block = html2md($block);

	return parts_store($block, "quote");
}

sub format_table {
	my $block = shift;

	# Still cannot process a table

	return parts_store($block, "table");
}

sub format_equation {
	my $block = shift;

	# Remove format tags and entities if any
	$block =~ s{<span[^>]*>}{}g;
	$block =~ s{</span>}{}g;
	$block =~ s{<b>}{}g;
	$block =~ s{</b>}{}g;
	$block =~ s{<em>}{}g;
	$block =~ s{</em>}{}g;
	$block =~ s{&lt;}{<}g;
	$block =~ s{&gt;}{>}g;
	$block =~ s{&amp;}{&}g;
	$block =~ s{<br>}{\n}g;
	
	$block =~ s{^\s+}{}g;
	$block =~ s{\s+$}{}g;

	return parts_store("\$\$\n$block\n\$\$", "eqn");
}

sub format_link {
	my ($href, $text, $vars_allowed) = @_;
	my $asset = 0;

	$vars_allowed = 1 unless defined $vars_allowed;

	$text = html2md($text);

	my $link = $href;
	$link =~ s/#.*$//; # strip this, is local to browser
	if ($link =~ m{.*/([^/]+\.[a-z]\w+)($|\?.*)}i) {

		my $file = $1;
		$file =~ s/%25/%/g;
		$file =~ s/%../-/g;

		# Link may be a local asset?
		if ($file and -e "$assets_local/$file") {
			#print STDERR "Debug: link '$href' now is local '$file'.\n";
			
			# Image captions do not allow variables.
			if ($vars_allowed) {
				return parts_store("[$text]({{page.assets | relative_url}}/$file)", "link");
			}
			else {
				return parts_store("[$text]($assets_url/$file)", "link");
			}
		}
	}

	return parts_store("[$text]($href)", "link");
}

sub format_section {
	my $s = shift;
	$s = html2md($s);
	return parts_store("## $s", "section");
}

sub format_monogroup {
	my $block = shift;
	$block =~ s{<br>}{}g;
	return parts_store($block, "monogroup");
}

# Parameter: video ID or URL
sub format_youtube {
	my $url = shift;
	my $id;

	# remove options from embed link
	$url =~ s{\?.*$}{};

	if ($url =~ /youtube/) {
		($id) = $url =~ m{/([^/]{5,20})$};
	}
	else {
		$id = $url;
	}

	if (not $id) {
		print STDERR "Warning: no video ID on this link: '$url'.\n";
		return "";
	}

	return parts_store("{% include youtube.html id=\"$id\" %}", "object");
}

sub format_paragraph {
	my $block = shift;
	
	# Replace br and trim
	$block =~ s{<br>}{\n}g;
	$block =~ s{\s+$}{}g;
	$block =~ s{^\s+}{}g;

	if ($block =~ m{\|\|}) {
		print STDERR "Warning, outside-paragraph delimiter found in: '$block'.\n";
		return "";
	}
	
	if ($block =~ m{<div}) {
		print STDERR "Warning, div tag inside paragraph: '$block'.\n";
		return "";
	}

	# Embebed object, do not touch
	if ($block =~ m{<iframe}) {
	  print STDERR "Video? -- \n$block\n\n";
		return parts_store($block, "object");
	}

	$block = html2md($block);

	if ($block eq "") {  # null par
		return "";
	}
	
	if (not $block =~ /\w/) {  # only format par?
		return "";
	}

	return parts_store($block, "paragraph");
}

sub process_body {
	my $s = shift;
	$s = trim($s);

	# Pre - processing
	# ------------------------------------------------------
	
	# Fixes for particular cases
	$s =~ s{Exploit K</b>it}{Exploit Kit</b>}g;
    $s =~ s{"<span [^>]*monospace[^>]*>(.*?)</span>"}{`$1`}g;      # for afsk-desde-cero
	#	$s =~ s{<br />(R1 = [^>]+)<br />}{\n\n```$1```\n\n}g;          # preamplificador-microfono-electret
	$s =~ s{<factor de="" ruido=""></factor>}{};                   # preamplificador-microfono-electret
	$s =~ s{2010/06/difraccion-en-un-dvd}{2010/07/difraccion-en-un-dvd}g;
	#$s =~ s{<div><b>Primer contacto</b>}{<b>Primer contacto</b>}g; # sintetizador-pll
    $s =~ s{\\f_(a|b)}{f_$1}g;                           # thd
	$s =~ s{^<div class="separator".*?</div>Hoy vamos}{Hoy vamos}g;                           # thd
	$s =~ s{bmp280.html"><br />La presión}{bmp280.html">La presión}; #contador-radiactivo
	$s =~ s{<td class="tr-caption" style="text-align: center;"><br /></td>}{}; # espectroscopia-transformada-de-fourier
	$s =~ s{</i></blockquote><blockquote><blockquote class="tr_bq"><i>La buena.*?pida.</i></blockquote></blockquote><ul>  </ul>}
	{<br>- La buena y rápida no será barata.<br>- La rápida y barata no será buena.<br>- La buena y barata no será rápida.</i></blockquote>};

	$s =~ s{(miliroentgen/h.<br />)(<br />A falta de mejores)}{$1.format_image("CDV_700_Gauge.jpg",300,"Medidor de un <a href=\"https://en.wikipedia.org/wiki/CD_V-700\">CDV-700</a>. Wikipedia.").$2}me;
	$s =~ s{<object height="385" width="480">.*?http://www.youtube.com/v/(ycD4XkUtbIw).*?</object>}{format_youtube($1)}ge; # vierten-tinta
	$s =~ s{(esta página) (<a href="http://www.unitedfreeworld.com/[^"]+">).*?(</a>)}{$2$1$3};


	# External images now are local assets:
	$s =~ s{<a href="[^"]+0AjHcMU3xvtO8dHVKaEpMNkVNZmZKQUFMYXI4YjR0VXc.{1,200}?<img.*?</a>}{format_image("lon_pal_es.png",400,"")}e;
	$s =~ s{<a href="[^"]+0AjHcMU3xvtO8dHBpdHdWQ3BNWU54MkY5bzlBTzVkQXc.{1,200}?<img.*?</a>}{format_image("angulo.png","","")}e;
	$s =~ s{<a href="[^"]+webvision.med.utah.edu/imageswv/KallDark12.jpg.*?</a>}{format_image("KallDark12.jpg","400","")}e;
	$s =~ s{<img height="268" src="[^"]+0AjHcMU3xvtO8dDdZSVhpNXZTaFV0Vk45dlluM0todUE&amp.*?/>}{format_image("sensacion_luminosa.png","","")}e;

	# Remove fixed texts
	$s =~ s{<div class="blogger-post-footer">.*?</div>}{}g;
	$s =~ s{<a name='more'></a>}{format_paragraph("<!--more-->")}ge;
	$s =~ s{<div[^>]*separator[^>]*>(.*?)</div>}{$1}msg;

	# Remove stiles from simple tags, replace uncommon format tags and simplify br tags
	$s =~ s{<b [^>]*>}{<b>}g;
	$s =~ s{<i [^>]*>}{<i>}g;
	$s =~ s{<strong>}{<b>}g;
	$s =~ s{</strong>}{</b>}g;
	$s =~ s{<k>}{<em>}g;
	$s =~ s{</k>}{</em>}g;
	$s =~ s{<i>}{<em>}g;
	$s =~ s{</i>}{</em>}g;
	$s =~ s{<u>}{}g;  # not supported
	$s =~ s{</u>}{}g; # not supported
	$s =~ s{<br[^>]*>}{<br>}g;
	$s =~ s{&nbsp;}{ }g;
	$s =~ s{<break>}{}g;
	$s =~ s{</break>}{}g;

	# Old italic and bold tags
	$s =~ s{<span [^>]*font-weight: bold;[^>]*>(.*?)</span>}{<b>$1</b>}g;
	$s =~ s{<span [^>]*font-style: italic;[^>]*>(.*?)</span>}{<em>$1</em>}g;

	# Trailing or leading spaces in tags
	$s =~ s{<b>(\s+)}{$1<b>}g;
	$s =~ s{(\s+)</b>}{</b>$1}g;
	$s =~ s{<em>(\s+)}{$1<em>}g;
	$s =~ s{(\s+)</em>}{</em>$1}g;
	# $s =~ s{<span([^>]*)>(\s+)}{$2<span$1>}g; # no, maybe a monospaced line

	# Remove empty formats
	$s =~ s{<b>\s*</b>}{}g;
	$s =~ s{<em>\s*</em>}{}g;
	
	$s =~ s{<b>\s*<br>\s*</b>}{<br>}g;
	$s =~ s{<em>\s*<br>\s*</em>}{<br>}g;
	
	$s =~ s{<span[^>]*>\s*</span>}{}g;
	$s =~ s{<span\s*>(.*?)</span}{$1}g;
	#$s =~ s{<span[^>]*>\s*<br>\s*</span>}{<br>}mg;

	$s =~ s{<div[^>]*>\s*</div>}{<br>}g;
	$s =~ s{<div\s*>(.*?)</div>}{$1<br>}g;
	#$s =~ s{<div[^>]*>\s*(?:<br>)*\s*</div>}{<br>}mg; # maybe blank line inside a monospaced block


	# Markdown does not support alignment
	$s =~ s{<div align=[^>]*>(.*?)</div>}{$1}msg;
	$s =~ s{<div style="text-align: [^"]+;">(.*?)</div>}{$1}msg;
	
	# Identify special structures
	# ------------------------------------------------------

	# Images with caption and link
	# <table ... <a href="...blogspot.com/.../div_by_5.png" src="...blogspot.com/.../div_by_5.png" width="640" ...>CAPTION</td></tr></tbody></table>
	$s =~ s{<table.{1,200}<a href="[^"]*bp.blogspot.com[^"]*?/([^/"]+)".{1,300}?src="([^"]+)" width="(\d+)".{1,300}?<td[^>]+>(.+?)</td>[^"]+?</table>}{format_image($1,$3,$4)}sge;
	
	# Same, without width
	$s =~ s{<table.{1,200}<a href="[^"]*bp.blogspot.com[^"]*?/([^/"]+)".{1,300}?src="([^"]+)".{1,300}?<td[^>]+>(.+?)</td>[^"]+?</table>}{format_image($1,"",$3)}sge;
	
	# Images with link and width, but no caption
	$s =~ s{<a href="[^"]*bp.blogspot.com[^"]*?/([^/"]+)".{1,300}?src="([^"]+)"[^>]*width="(\d+)".{1,120}?</a>}{format_image($1,$3,"")}sge;

	# Images with link only
	# <a href="...blogspot.com/.../Imagen149.jpg" ... ><img ... src="...blogspot.com/.../Imagen149.jpg" ... /></a>
	$s =~ s{<a href="[^>]*bp.blogspot.com.*?/([^/"]+)".*?src="(.+?)".*?/></a>}{format_image($1,"","")}sge;

	# Direct images, no caption, no link
	# <img ... src="http://2.bp.blogspot.com/.../db9_null_loop.png" ... />
	$s =~ s{<img.*?src=".*?bp.blogspot.com.*?/([^/"]+)".*?/>}{format_image($1,"","")}sge;

	# Replace internal links to other posts
	$s =~ s{<a href="[^"]+electronicayciencia.blogspot.com/(.+?).html">(.*?)</a>}{link_post_to_local($1, $2)}gmse;
	$s =~ s{<a href="[^"]+electronicayciencia.blogspot.com.es/(.+?).html">(.*?)</a>}{link_post_to_local($1, $2)}gmse;
	
	# <blockquote></blockquote>
	$s =~ s{<blockquote[^>]*>(.+?)</blockquote>}{format_blockquote($1)}msge;
	
	# Youtube videos
	$s =~ s{<iframe[^>]*src="([^"]*youtube[^"]*)"[^>]*>(.*?)</iframe>}{format_youtube($1)}msge;
	
	# Format unordered list blocks
	$s =~ s{(<ul>.*?</ul>)}{format_list($1, "ul")}msge;
	
	# Format unordered list blocks
	$s =~ s{(<ol>.*?</ol>)}{format_list($1, "ol")}msge;

	# Format pre blocks
	$s =~ s{(<pre.*?</pre>)}{format_pre($1)}msge;

	# convert span monospaced into pre blocks
	$s =~ s{<div[^>]*monospace[^>]*>(.*?)</div>}{format_monospace($1, "div")}mge;
	$s =~ s{<span[^>]*monospace[^>]*>(.*?)</span>}{format_monospace($1, "span")}mge;

	# Equations
	$s =~ s{\\\[(.*?)\\\]}{format_equation($1, "display")}msge;

	# HTML tables
	$s =~ s{(<table[^>]*>.*?</table>)}{format_table($1)}ge;

	# Section titles
	$s =~ s{(<br>|\|\|)\s*<b>([^\(].{2,80}?)</b>\s*(<br>|\|\|)}{$1.format_section($2).$3}ge;

	# Second level structures
	# ------------------------------------------------------
	
	# Remove styles of the remainder at this point
	# This will remove divs from non captured structures, like iframes or objects.
	# But it is neccesary in order to group monolines.
	$s =~ s{<div[^>]*>(.*?)</div>}{$1}msg;
	$s =~ s{<span[^>]*>(.*?)</span>}{$1}msg;
	$s =~ s{<div[^>]*>(.*?)</div>}{$1}msg;
	$s =~ s{<span[^>]*>(.*?)</span>}{$1}msg;

	# block of monolines
	$s =~ s{<br>((?:(?:\|\|##(?:span|div)mono-(?:line|block)-\d+##\|\|)(?:<br>)*)+)<br>}{"<br>".format_monogroup($1)."<br>"}ge;

	# paragraphs
	# Okay, that's black magic
	$s =~ s{(^|<br>|##\|\|)([^\|].*?)($|<br>|\|\|##)}{$1.format_paragraph($2).$3}mge;
	$s =~ s{(^|<br>|##\|\|)([^\|].*?)($|<br>|\|\|##)}{$1.format_paragraph($2).$3}mge;

	# Only <br> and parts. Now only parts.
	$s =~ s{<br>}{}g;
	

	# Process non-structured text
	# ------------------------------------------------------
	
	# New paragraph
	#$s =~ s{<br>}{\n}g;

	# Recompose post body from abstract structure
	# ------------------------------------------------------
	
	$s = recompose($s);

	for my $tag ($s =~ m{(<.*?>)}g) {
	  #next if $tag !~ /img/; # OMIT ALMOST ANY
		#next if $tag eq "<br />";
		next if $tag eq "<sup>";
		next if $tag eq "</sup>";
		next if $tag eq "<sub>";
		next if $tag eq "</sub>";
		next if $tag =~ /^<iframe/;
		next if $tag eq "</iframe>";
		next if $tag =~ /^<audio/;
		next if $tag eq "</audio>";
		next if $tag =~ /^<script/;
		next if $tag eq "</script>";
		next if $tag eq "<!--more-->";
		print STDERR "Warning: text seems to still have HTML tags: $tag\n";
	}


	# Fix some particular cases
	# ------------------------------------------------------
	#$s =~ s{<img border="0" height="231" src="https://spreadsheets.google.com/oimg?key=0AjHcMU3xvtO8dHVKaEpMNkVNZmZKQUFMYXI4YjR0VXc&amp;oid=3&amp;v=1274193059773" width="400" />}
	#       {format_image("lon-pal-es.png",400,"")}e;
	

	# Dive into now formatted text to get info
	($featured_image) = $s =~ m|{% include image.html[^}]+file="([^"]+)"|;

	return $s;
}

# Arguments: post filename
# Output: string with the text, hash with yaml header
sub parse_post {
	my $filename = shift;
	my $content = do{local(@ARGV,$/)=$filename;<>};

	my ($head, $text) = split("\n---\n", $content);
	
	$head =~ s/^- /  - /mg; # Ruby YAML is a little bit non-compliant
	
	my $meta = Load($head) or die "$!\n";
	
	$text = trim($text);

	return ($meta, $text);
}

sub rewrite_post {
	my ($meta, $text) = @_;
	print Dump($meta)."---\n\n$text\n";
	exit;
}


my $filename = $ARGV[0] or die "Usage: $0 yyyy-mm-dd-posttitle.html\n";

my $postname = basename($filename, ".md", ".html");

($assets_url, $assets_local) = get_assets_location($filename);

my ($meta, $body) = parse_post($filename);

# Get the new netadata file
my $newmeta = LoadFile($newmetafile) or die "$!";
my %newmeta = %{$newmeta};

# Process the body before the head in order to get first image as featured one
$body = process_body($body);

# Process the header
$meta = process_head($meta, $newmeta{$postname});

# Recompose jekyll post.
rewrite_post($meta, $body);

#print "\n\n".Dumper(\%parts)."\n\n";

