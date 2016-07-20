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

$dat=param('search');
@name = split /\.\s*/, param('search');
$list = "";
$i=0;

$grads=qq(<table bgcolor="#333333" border=0 width=85% cellpadding=0 cellspacing=0>
	  <tr><td>
	  <FORM name='send1' action="/cgi-bin/del_grads3.pl" method=post>
	  <table border=0 width=100% cellpadding=4 cellspacing=1>
	  <tr bgcolor='#cccccc'>
		<b><font size=-1>
		<td align=center width=8%>удалить</td>
		<td align=center width=26%>Ф.И.О.</td>
                <td align=center width=18%>статус</td>
                <td align=center width=6%>принят</td>
                <td align=center width=6%>окончил</td>
                <td align=center width=28%>научный руководитель</td>
                <td align=center width=18%>защитил</font></b></td></tr>);

$sth = $dbh->prepare( qq(SELECT * FROM grads WHERE name LIKE '%$dat%' ORDER BY id) ) or die $dbh->errstr;
$sth->execute();

while(@ary = $sth->fetchrow_array())
{
    $i++;
    @ary = map { defined ($_) ? $_ : "" } @ary;
    $list.=qq($ary[0],);
    &status;
    $adv=$ary[6];
    $adv.="<br>$ary[7]" if ($ary[7] ne "");
    $adv.="<br>$ary[8]" if ($ary[8] ne "");
    $adv.="<br>$ary[9]" if ($ary[9] ne "");
    $grads.= qq(<tr bgcolor=#cccccc align=center>
                <td><input type=checkbox name='$i'/></td>
                <td>$ary[1]</td>
                <td width=20%>$stat</td>
                <td width=6%>$ary[4]</td>
                <td width=6%>$ary[5]</td>
                <td width=30%>$adv</td>
                <td width=20%>$def</td>
                </tr>);
}

$sth2 = $dbh->prepare( qq(SELECT * FROM grads WHERE name='$name[0]. $name[1].' ORDER BY id) ) or die $dbh->errstr;
$sth2->execute();

if($i==0) {$grads= qq(<td rowspan=2 align=center bgcolor=#cccccc><font size=+3><p>Попробуйте ввести другую фамилию.</font></td>);}
else	  {$grads.=qq[</table>
		      <input type="hidden" name="list" value="$list">
		      </FORM>
		      </td></tr>
		      </table>
		      
		      
		      <p>
		      <table border=0 width=85% cellpadding=0 cellspacing=0>
		      <tr><td>
		      <button onclick="if(confirm('Вы уверены?')) document.forms.send1.submit()">Удалить</button><button onclick=" document.forms.send1.reset()">Снять выделение</button>
		      </td></tr>
		      </table>];
          }

sub status {
        $gen='';
        $gen='ка' if ($ary[2] eq 'ж');
        if ($ary[3] eq "с") {
                $stat="студент$gen";
                $def="диплом";
        }
        if ($ary[3] eq "а") {
                $stat="аспирант$gen";
                $def="";
        }
        if ($ary[3] eq "д") {
                $stat="аспирант$gen";
                $def="диссертация";
        }
        if ($ary[3] eq "са") {
                $stat="студент$gen,<BR>аспирант$gen";
                $def="диплом";
        }
        if ($ary[3] eq "ас") {
                $stat="студент$gen,<BR>аспирант$gen";
                $def="диплом,<BR>диссертация";
        }
        if ($ary[3] eq "б") {
                $stat="студент$gen";
                $def="бакалаврский диплом";
        }
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
<tr><td align=center ID=heading>Выпускники</td>
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

$grads

</td></tr>
</table>

</center>
</body>
</html>

EOF
exit;