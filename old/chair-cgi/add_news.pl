#!/usr/local/bin/perl -w


use DBI;
use CGI qw (:param);
use CGI::Carp qw(fatalsToBrowser);

$Pass{'malex'}="casimir";
$Pass{'beskin'}="dwbh116";

if($Pass{param('user')} && (param('pass') eq $Pass{param('user')}) ) {

$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/RCHAIR.GDB';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";



$sth = $dbh->prepare( qq(SELECT COUNT(*) FROM news) ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
$id=$ary[0]+1;

$title=param('title');
$mes=param('message');

&get_date;
&check_message;

$sth = $dbh->prepare( qq(INSERT INTO news VALUES  ('$id','$date','$title','$mes','n') ) ) or die $dbh->errstr;
$sth->execute();

&success_page;

} 
exit;

sub get_date
{
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdat)=localtime(time);
        $mon++;
        @j=('','','','');
        @k=($hour,$min,$mday,$mon);
        for($i=0;$i<4;$i++) {
        $j[$i].="0" if($k[$i]<10);
        }
        $year+=1900;
        $date="$j[0]$k[0]:$j[1]$k[1] $j[2]$k[2]\/$j[3]$k[3]\/$year";
}

sub check_message       #script/applet-analyser
{
        if ($mes=~/(script|applet)/i) {
                        $meta=qq(<meta charset="windows-1251">);
                        $back='на главную страницу';
                        $ref='/rus/main.shtml';
                        &return_page('ѕодозрительный текст...');
                exit;
        }
}


sub success_page {
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
<H1>¬аша новость прин€та!</H1>
<P>&nbsp;<P>
<input type=button name=back value="к новост€м" onclick="document.location='/cgi-bin/show_news.pl?1+1'">
</td></tr>
</table>
</CENTER>
</BODY>
</HTML>
EOF
}