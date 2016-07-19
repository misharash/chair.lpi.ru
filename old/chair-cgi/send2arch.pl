#!/usr/local/bin/perl -w

use DBI;
use CGI qw (:param);
use CGI::Carp qw(fatalsToBrowser);

$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/RCHAIR.GDB';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";

$sth = $dbh->prepare( qq(UPDATE news SET age='o' WHERE age='n') ) or die $dbh->errstr;
$sth->execute();


print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<TITLE>Error</TITLE>
<meta charset="windows-1251">
</HEAD>
<BODY bgcolor=#999999 onload="document.all.back.focus()">
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
<H1>Все новости успешно отправлены в архив!</H1>
<P>&nbsp;<P>
<input type=button name=back value="к новостям" onclick="top.frames.main.location='/cgi-bin/show_news.pl?1+1'">
</table>
</CENTER>
</BODY>
</HTML>
EOF

