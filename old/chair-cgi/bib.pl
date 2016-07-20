#!/usr/local/bin/perl -w

my ($buffer,$name);

read(STDIN,$buffer,$ENV{'CONTENT_LENGTH'});

$buffer =~ m/^.+name="(.+)".+Content-Type.+?\n\s+(.+)\s+\n.+-+.+$/s;

$name = $1;
$buffer = $2;

my ($body, @cites, @sort_cites, $bib, $bibs, $here_bib);

my $i = 0;
my $j = 0;

	foreach (split /\n/, $buffer) {
            
		while (/\\cite{(.+?)}/g) {
			my $cites = $1;
			$cites =~ s/\s+//g;
			my @l_cites = split ',', $cites;
			push @cites, @l_cites;
		}
		$i -- if /\\end\{thebibliography\}/;
		$body .= $_."\n" unless $i;
		$bib .= $_."\n" if $i;
		if (/\\begin{thebibliography}/) {
			$i ++;
			$body .= "\nhere_bib\n";	
		}
	}

	map {/{(.+?)}((\n|.)+)$/; $bibs->{$1} = $2 if $1} split /\\bibitem/, $bib;

	foreach my $c (@cites) {
		push @sort_cites, $c unless grep /^$c$/, @sort_cites;
	}

	$here_bib .= "\\bibitem{$_}$bibs->{$_}" foreach (@sort_cites);	
	$body =~ s/here_bib/$here_bib/;

	$name = join '', reverse (split '', $name);
	$name =~ m/^(.+?\..+?)(\\|$)/;
	$name = join '', reverse (split '', $1);
	$name =~ s/(.+)\.(.+)/$1_bib.$2/;	

print "Content-Type: text/plain\n";
print "Content-Disposition: attachment; filename=\"$name\"\n\n";
print $body;

1;