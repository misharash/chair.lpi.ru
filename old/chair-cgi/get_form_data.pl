sub get_form_data
{
read(STDIN,$buffer,$ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$buffer);
 foreach $pair (@pairs)
 {
	($name,$value)=split(/=/,$pair);
	$value=~tr/+/ /;
	$value=~s/%([a-fA-F0-9][a-fA-F0-9])/pack("C",hex($1))/eg;
	$value=~s/<!--(.|\n)*-->//g;

	$FORM{$name}=$value;
 }
}
1;