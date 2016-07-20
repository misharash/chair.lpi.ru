#!/usr/local/bin/perl -w

#$ARGV[0] -  language

require "get_form_data.pl";
use DBI;
use CGI::Carp qw(fatalsToBrowser);

&get_form_data;

# years
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
$sth = $dbh->prepare( qq(SELECT * FROM students WHERE e_year='$y[$j]' ORDER BY last_name) ) or die $dbh->errstr;
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
        $studs.= qq(<tr bgcolor=#cccccc align=center>
                <td>$i</td>
                <td><input type=checkbox name='$i'/></td>
                <td>$name</td>
                <td align=center>$ary[4]</td>
                <td align=center>$adv</td></tr>);
}
}
  $dbh->disconnect();


if  ($ARGV[0] eq 'rus') {

print <<EOF;
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
<tr><td align=center ID=heading>Студенты</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
   onclick="document.location='/cgi-bin/studs.pl?rus'">Выход</u>
</td>
</tr>
</table>

<table bgcolor="#333333" border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<FORM name='send1' action="/cgi-bin/add_stud.pl?rus+1" method=post>
<table border=0 width=100% cellpadding=4 cellspacing=1>
<tr bgcolor='#cccccc'>
        <td width=5% align=center>&nbsp;</td>
        <td align=center width=10%><b><font size=-1>удалить</font></b></td>
        <td width=30%>&nbsp;</td><td width=8% align=center><b><font size=-1>                            группа</font></b></td>
        <td width=40% align=center><b><font size=-1>научный             руководитель</font></b></td></tr>

$studs

</table>
</td></tr>
</table>
</FORM>

<p>
<table border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<button onclick="if(confirm('Вы уверены?')) document.forms.send1.submit()">Отчислить</button><button onclick=" document.forms.send1.reset()">Снять выделение</button>
</td></tr>
</table>

<p>
<table border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<FORM name='send2' action="/cgi-bin/add_stud.pl?rus+2" method=post>
<FIELDSET>
<LEGEND><b>Новый студент</b></LEGEND>

<table border=0 width=90% cellpadding=0 cellspacing=0>
<tr><td align=center>Фамилия:</td><td> <input size=20 type=text name="lastname"/></td>
<tr><td align=center>Имя и Отчество:</td><td> <input size=30 type=text name="name"/></td>
<tr><td align=center>E-mail:</td><td> <input size=30 type=text name="mail"/></td>
<tr><td align=center>Группа:</td><td> <input size=12 type=text name="group"/></td>
<tr><td align=center>Научный Руководитель:</td><td> <input size=40 type=text name="r_adv1"/></td>
<tr><td align=center>Ученая степень НР:</td><td> <input size=40 type=text name="sci_deg1"/></td>
<tr><td align=center>Научный Руководитель:</td><td> <input size=40 type=text name="r_adv2"/></td>
<tr><td align=center>Ученая степень НР:</td><td> <input size=40 type=text name="sci_deg2"/></td>
<tr><td align=center>Научный Руководитель:</td><td> <input size=40 type=text name="r_adv3"/></td>
<tr><td align=center>Ученая степень НР:</td><td> <input size=40 type=text name="sci_deg3"/></td>
<tr><td align=center>Научный Руководитель:</td><td> <input size=40 type=text name="r_adv4"/></td>
<tr><td align=center>Ученая степень НР:</td><td> <input size=40 type=text name="sci_deg4"/></td>
</table>

</FIELDSET>
<p>
<tr><td>&nbsp;<button onclick="document.forms.send2.submit()">Готово</button><button onclick="document.forms.send2.reset()">Очистить</button>
</td></tr>
</table>
</FORM>

<p>
<div align=right><a href="#back"><img src="/rus/img/totop.gif" width=80 height=40 border=0 alt="в начало"></a></div>
<p>
</td></tr>
</table>
</center>

</body>
</html>

EOF
}

if  ($ARGV[0] eq 'eng') {

print <<EOF;
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
        {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:hand}
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
<tr><td align=center ID=heading>Students</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
   onclick="document.location='/cgi-bin/studs.pl?eng'">Exit</u>
</td>
</tr>
</table>

<table bgcolor="#333333" border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<FORM name='send1' action="/cgi-bin/add_stud.pl?eng+1" method=post>
<table border=0 width=100% cellpadding=4 cellspacing=1>
<tr bgcolor='#cccccc'>
        <td width=5% align=center>&nbsp;</td>
        <td align=center width=10%><b><font size=-1>delete</font></b></td>
        <td width=30%>&nbsp;</td><td width=8% align=center><b><font size=-1>                            group</font></b></td>
        <td width=40% align=center><b><font size=-1>research adviser</font></b></td></tr>

$studs

</table>
</td></tr>
</table>
</FORM>

<p>
<table border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<button onclick="if(confirm('Are you sure?')) document.forms.send1.submit()">Send down</button><button onclick=" document.forms.send1.reset()">Revoke selection</button>
</td></tr>
</table>

<p>
<table border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<FORM name='send2' action="/cgi-bin/add_stud.pl?eng+2" method=post>
<FIELDSET>
<LEGEND><b>New student</b></LEGEND>

<table border=0 width=90% cellpadding=0 cellspacing=0>
<tr><td align=center>Surname:</td><td> <input size=20 type=text name="lastname"/></td>
<tr><td align=center>First and Middle Name:</td><td> <input size=30 type=text name="name"/></td>
<tr><td align=center>E-mail:</td><td> <input size=30 type=text name="mail"/></td>
<tr><td align=center>Group:</td><td> <input size=12 type=text name="group"/></td>
<tr><td align=center>Research Advisor:</td><td> <input size=40 type=text name="r_adv1"/></td>
<tr><td align=center>RA academic degree:</td><td> <input size=40 type=text name="sci_deg1"/></td>
<tr><td align=center>Research Advisor:</td><td> <input size=40 type=text name="r_adv2"/></td>
<tr><td align=center>RA academic degree:</td><td> <input size=40 type=text name="sci_deg2"/></td>
<tr><td align=center>Research Advisor:</td><td> <input size=40 type=text name="r_adv3"/></td>
<tr><td align=center>RA academic degree:</td><td> <input size=40 type=text name="sci_deg3"/></td>
<tr><td align=center>Research Advisor:</td><td> <input size=40 type=text name="r_adv4"/></td>
<tr><td align=center>RA academic degree:</td><td> <input size=40 type=text name="sci_deg4"/></td>
</table>

</FIELDSET>
<p>
<tr><td>&nbsp;<button onclick="document.forms.send2.submit()">Complete</button><button onclick="document.forms.send2.reset()">Clear</button>
</td></tr>
</table>
</FORM>

<p>
<div align=right><a href="#back"><img src="/eng/img/totop.gif" width=80 height=40 border=0 alt="to the top"></a></div>
<p>
</td></tr>
</table>
</center>

</body>
</html>

EOF
}

exit;