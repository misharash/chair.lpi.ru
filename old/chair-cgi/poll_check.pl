#!/usr/local/bin/perl -w

require "get_form_data.pl";
use DBI;
&get_form_data;

$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/rchair.gdb';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to $data_source: $DBI::errstr";

$sth = $dbh->prepare( qq(SELECT * FROM marks) ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
$sum=$ary[0]+2*$ary[1]+3*$ary[2]+4*$ary[3]+5*$ary[4];
$num=$ary[0]+$ary[1]+$ary[2]+$ary[3]+$ary[4];
print "Content-type: text/html\n\n";
exit if($num==0);
$mark=$sum/$num;
printf(" %.2f",$mark);

exit;