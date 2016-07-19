#!/usr/local/bin/perl -w

use CGI::Carp qw(fatalsToBrowser);

use DBI;
$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/rchair.gdb';
$DB_NAME = 'rchair' if  ($ARGV[0] eq 'rus');
$DB_NAME = 'echair' if  ($ARGV[0] eq 'eng');
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";
my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";


print "Content-type: text/html\n\n";

$RA=$ENV{'REMOTE_ADDR'};

$sth = $dbh->prepare( qq{SELECT * FROM attend WHERE ip='$RA'} ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
$sth = $dbh->prepare( qq(SELECT attend FROM stat ) ) or die $dbh->errstr;
$sth->execute();
@ary2 = $sth->fetchrow_array();

if ($ary[0]!~/$RA/) {
        $sth = $dbh->prepare( qq{INSERT INTO attend VALUES ('$RA')} ) or die $dbh->errstr;
        $sth->execute();
        $ary2[0]++;
        $sth = $dbh->prepare( qq{UPDATE stat SET attend='$ary2[0]'} ) or die $dbh->errstr;
        $sth->execute();
        }

print qq( Число пользователей сайта:<br> $ary2[0] ) if  ($ARGV[0] eq 'rus');
print qq( Amount of site users:<br> $ary2[0] ) if  ($ARGV[0] eq 'eng');


