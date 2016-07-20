#!/usr/local/bin/perl -w

require "get_form_data.pl";
use DBI;
&get_form_data;

$RA=$ENV{'REMOTE_ADDR'};
$mark=$FORM{'mark'};
$answer=$FORM{'answer'};
$number=$FORM{'number'};

$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/rchair.gdb';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET= 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";
my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to $data_source: $DBI::errstr";

$sth = $dbh->prepare( qq(SELECT * FROM guard WHERE id=$number) ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
&return_page("Введите верный ответ!") if($answer ne $ary[1]);

&return_page('Вы не сделали выбор!') if($mark eq '');

$sth = $dbh->prepare( qq(SELECT * FROM poll) ) or die $dbh->errstr;
$sth->execute();
$num_of_votes=1;
while ( @ary = $sth->fetchrow_array() ) {
	$num_of_votes++;
	&return_page('Извините, но Вы уже голосовали!') if($ary[0]=~/$RA/);
}

$sth = $dbh->prepare( qq( INSERT INTO poll VALUES('$RA') ) ) or die $dbh->errstr;
$sth->execute();
@m=('one','two','three','four','five');
$sth = $dbh->prepare( qq(UPDATE marks SET $m[$mark-1]=$m[$mark-1]+1  ) ) or die $dbh->errstr;
$sth->execute();

&return_page("Спасибо  за Ваш голос!<BR> Вы $num_of_votes респондент.");

sub return_page 
{
print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<META charset="windows-1251">
<TITLE>Error</TITLE>
</HEAD>
<BODY bgcolor=#999999>
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
<H1>$_[0]</H1>
</td></tr>
</table>
</CENTER>
</BODY>
</HTML>
EOF
exit;
}