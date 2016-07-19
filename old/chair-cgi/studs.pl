#!/usr/local/bin/perl -w

require "get_form_data.pl";
use DBI;
use CGI::Carp qw(fatalsToBrowser);

&get_form_data;

#years
$y[0]=$y[1]=$y[2]=$y[3]=$y[4]=$y[5]=$y[6]=(localtime(time))[5];
$y[0]=chop($y[0]);
$y[1]--;
$y[1]=chop($y[1]);
$y[2]-=2;
$y[2]=chop($y[2]);
$y[3]-=3;
$y[3]=chop($y[3]);
$y[4]-=4;
$y[4]=chop($y[4]);
$y[5]-=5;
$y[5]=chop($y[5]);
$y[6]-=6;
$y[6]=chop($y[6]);
$y[7]='а';
$y[8]='p';


$DB_HOST = 'localhost';
#$DB_NAME = '/usr/local/www/chair/rus/RCHAIR.GDB';
$DB_NAME = 'rchair' if  ($ARGV[0] eq 'rus');
$DB_NAME = 'echair' if  ($ARGV[0] eq 'eng');
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to 
$data_source: $DBI::errstr";


$i=0;
for ($j=0; $j<9;$j++) {
$sth = $dbh->prepare( qq(SELECT * FROM students WHERE e_year=').$y[$j]."' ORDER BY last_name" ) or die $dbh->errstr;
$sth->execute();

while( @ary = $sth->fetchrow_array() ) {
        $i++;
        @ary = map { defined ($_) ? $_ : "" } @ary;
        $name=$ary[0]."<br>".$ary[1]." ".$ary[2];
        $adv='';
        $adv.="<i>$ary[5]</i><br>$ary[6]" if $ary[6] ne '';
        $adv.="<br><i>$ary[7]</i><br>$ary[8]" if $ary[8] ne '';
        $adv.="<br><i>$ary[9]</i><br>$ary[10]" if $ary[10] ne '';
        $adv.="<br><i>$ary[11]</i><br>$ary[12]" if $ary[12] ne '';
        $entry.= qq(<tr bgcolor=#cccccc align=center>
                <td width=5%>$i</td>
                <td width=35%><a href=mailto:$ary[3] title="E-mail: $ary[3]">$name</a></td>
                <td width=10% align=center>$ary[4]</td>
                <td width=50% align=center>$adv</td>);
}
}
  $dbh->disconnect();


if ($ARGV[0] eq 'rus') {

print <<EOF1;
Content-type: text/html

<html>
<head>
<title>Студенты</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
<STYLE type="text/css">
.off
        {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
.on
        {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
A       
        {font-weight:bold}
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
<tr><td align=center ID=heading>Студенты</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'" 
onclick="window['actype'] ='chstuds&rus'; window.open('/password.html','','left=300,top=300,toolbar=0,scrollbars=0,menubar=0,resizable=0,width=400,height=50');">
Изменить состав</u>
</td></tr>
</table>

<table bgcolor="#333333" border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
        
<table border=0 width=100% cellpadding=4 cellspacing=1>
<tr bgcolor='#cccccc'>
        <td width=5% align=center>&nbsp;</td>
        <td width=35%>&nbsp;</td>
        <td width=10% align=center><b><font size=-1>группа</font></b></td>
        <td width=50% align=center><b><font size=-1>научный руководитель</font></b>
        </td></tr>

        $entry

        </tr>
        </table>
        </tr>
        </table>

        <p>
        <div align=right><a href="#back"><img src="/rus/img/totop.gif" width=80 height=40 border=0 alt="в начало"></a></div>
        <p>
</td></tr>
</table>
</center>

</body>
</html>
EOF1
}


if ($ARGV[0] eq 'eng') {

print <<EOF2;
Content-type: text/html

<html>
<head>
<title>Students</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/eng/comsheet.css" rel="stylesheet">
<STYLE type="text/css">
.off
               {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
.on
             {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
A       
                {font-weight:bold}
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
<tr><td align=center ID=heading>Students</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'" 
onclick="window['actype'] ='chstuds&eng'; window.open('/password.html','','left=300,top=300,toolbar=0,scrollbars=0,menubar=0,resizable=0,width=400,height=50');">
        Change list</u>
</td></tr>
</table>

<table bgcolor="#333333" border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
        
<table border=0 width=100% cellpadding=4 cellspacing=1>
<tr bgcolor='#cccccc'>
        <td width=5% align=center>&nbsp;</td>
        <td width=35%>&nbsp;</td>
        <td width=10% align=center><b><font size=-1>group</font></b></td>
        <td width=50% align=center><b><font size=-1>research advisor</font></b>
        </td></tr>

        $entry

        </tr>
        </table>
        </tr>
        </table>

        <p>
        <div align=right><a href="#back"><img src="/eng/img/totop.gif" width=80 height=40 border=0 alt="to the top"></a></div>
        <p>
</td></tr>
</table>
</center>

</body>
</html>
EOF2
}


exit;
