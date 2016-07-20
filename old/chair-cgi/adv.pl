#!/usr/local/bin/perl -w

use DBI;

use CGI::Carp qw(fatalsToBrowser);

print "Content-type: text/html\n\n";

$DB_HOST = 'localhost';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";

$sth = $dbh->prepare( qq(SELECT * FROM advisors ORDER BY name) ) or die $dbh->errstr;
$sth->execute();

while( @ary = $sth->fetchrow_array() ) {
	$ary[0]=~s!^(.+)\s+?$!$1!;
	print qq(<OPTION value="$ary[0]">$ary[0]</OPTION>\n);
}

exit;