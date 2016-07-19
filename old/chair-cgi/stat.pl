#!/usr/local/bin/perl -w

require "get_form_data.pl";
use DBI;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type: text/html\n\n";

$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/rchair.gdb';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";

$sth = $dbh->prepare( qq(SELECT * FROM grads) ) or die $dbh->errstr;
$sth->execute();
$ref=$sth->fetchall_arrayref;
$grad=@{$ref};

&end($grad);
print qq(<A href=/cgi-bin/grads.pl?all><font size=+3 face='wingdings'>&middot;</font>
<font size=+2 face='Arial narrow'>Кафедру окончили $grad человек$end.</font></A><br><br>);


$sth2 = $dbh->prepare( qq(SELECT id FROM grads WHERE status='с' OR status='ас' OR status='са') ) or die $dbh->errstr;
$sth2->execute();
$ref=$sth2->fetchall_arrayref;
$dip=@{$ref};

&end($dip);
print qq(<A href=/cgi-bin/grads.pl?stud><font size=+3 face='wingdings'>&middot;</font>
<font size=+2 face='Arial narrow'>Дипломы получили $dip человек$end.</font></A><br><br>);

$sth3 = $dbh->prepare( qq(SELECT id FROM grads WHERE status='д' OR status='ас') ) or die $dbh->errstr;
$sth3->execute();
$ref=$sth3->fetchall_arrayref;
$deg=@{$ref};

&end($deg);
print qq(<A href=/cgi-bin/grads.pl?phd><font size=+3 face='wingdings'>&middot;</font>
<font size=+2 face='Arial narrow'>Диссертации защитили $deg человек$end.</font></A>);


sub end {
        $end=$_[0];
        if ($end=~/[234]$/) {
                chop $end;
                if ($end!~/1$/) { $end='а' ; }
                else { $end='' ; }
        }
        else { $end='' ; }
}


exit;