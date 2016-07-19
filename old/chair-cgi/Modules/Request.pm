package Modules::Request;

BEGIN {
use Encode qw(encode decode);
use MIME::Base64;
use Exporter ();

@ISA = "Exporter";
@EXPORT = qw(&get_form_data &utf2cp);
}


sub get_form_data {

	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	my @pairs=split(/&/,$buffer);

	my $FORM = {};

 	foreach (@pairs) {
		my ($name, $value) = split /=/;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C",hex($1))/eg;
		$value =~ s/<!--(.|\n)*-->//g;
		$FORM->{$name} = $value;    
 	}

	return $FORM;
}


sub utf2cp {
	my $v = encode('cp1251', decode('utf-8', $_[0]));
	return $v;
}


1;
