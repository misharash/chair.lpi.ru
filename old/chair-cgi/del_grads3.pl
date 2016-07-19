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

@list = split /,/, param('list');
$size = @list;
$i=0;

while($i<$size)
{
    if(param($i+1) eq 'on')
    {
        my $id0=$list[$i];
	my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to $data_source: $DBI::errstr";
	my $sth = $dbh->prepare( qq(DELETE FROM grads WHERE id=$id0) ) or die $dbh->errstr;
	$sth->execute();
	$dbh->disconnect();
    }
    $i++;
}

print <<EOF;
Content-type: text/html

<html>
<head>
<title>Выпускники</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
<STYLE type="text/css">
.off
        {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
.on
        {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
A 
        {font-weight:bold}
A:hover
        {color: black}
</STYLE>
</head> 
<body bgcolor=#999999 text=#111111 alink=black vlink=black link=black>
<a name="back"></a>
<center>
<table width=85% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>

<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center ID=heading>Удаление прошло успешно</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top>
<td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
   onclick="document.location='/cgi-bin/del_grads.pl'">Вернуться к поиску</u>
</td>
<td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
   onclick="document.location='/rus/grad.shtml'">Вернуться к списку выпускников</u>
</td>
</tr>
</table>

</td></tr>
</table>

</center>
</body>
</html>

EOF
exit;