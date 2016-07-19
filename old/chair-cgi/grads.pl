#!/usr/local/bin/perl -w

require "get_form_data.pl";
use DBI;
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

&get_form_data;

$year="$FORM{'exit'}";
&year if defined($year) && $FORM{'exit'} ne 'all';
&all if $ARGV[0] eq 'all';
&stud($FORM{'search'}) if defined($FORM{'search'});
&stud($ARGV[0]) if $ARGV[0]=~/\d+/;
&prep if defined($FORM{'advisor'});
&allstud if $ARGV[0] eq 'stud';
&phd if $ARGV[0] eq 'phd';

sub  all {
        $sth = $dbh->prepare( qq(SELECT * FROM grads ORDER BY out,enter,id) ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=28%>Ф.И.О.</td>
                <td width=20%>статус</td>
                <td width=6%>принят</td>
                <td width=6%>окончил</td>
                <td width=30%>научный руководитель</td>
                <td width=20%>защитил</font></b></td>
                );
        $title='Все выпускники кафедры';
        while( @ary = $sth->fetchrow_array() ) {
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $adv=$ary[6];
                $adv.="<br>$ary[7]" if ($ary[7] ne "");
                $adv.="<br>$ary[8]" if ($ary[8] ne "");
                $adv.="<br>$ary[9]" if ($ary[9] ne "");
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=28%>$ary[1]</td>
                        <td width=20%>$stat</td>
                        <td width=6%>$ary[4]</td>
                        <td width=6%>$ary[5]</td>
                        <td width=30%>$adv</td>
                        <td width=20%>$def</font></b></td>);
        }
}


sub  year {
        $sth = $dbh->prepare( qq(SELECT * FROM grads where out='$year' ORDER BY enter,id) ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=30%>Ф.И.О.</td>
                <td width=20%>статус</td>
                <td width=10%>принят</td>
                <td width=30%>научный руководитель</td>
                <td width=20%>защитил</font></b></td>
                );
        $title="Выпускники $year года";
        while( @ary = $sth->fetchrow_array() ) {
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $adv=$ary[6];
                $adv.="<br>$ary[7]" if ($ary[7] ne "");
                $adv.="<br>$ary[8]" if ($ary[8] ne "");
                $adv.="<br>$ary[9]" if ($ary[9] ne "");
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=30%>$ary[1]</td>
                        <td width=20%>$stat</td>
                        <td width=10%>$ary[4]</td>
                        <td width=30%>$adv</td>
                        <td width=20%>$def</font></b></td>);
        }
}

sub  stud {
        $student=$_[0];
        $sth = $dbh->prepare( qq(SELECT * FROM grads ORDER BY out,enter,id) ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=28%>Ф.И.О.</td>
                <td width=20%>статус</td>
                <td width=6%>принят</td>
                <td width=6%>окончил</td>
                <td width=30%>научный руководитель</td>
                <td width=20%>защитил</font></b></td>
                );
        $title="";
        $i=0;
        while( @ary = $sth->fetchrow_array() ) {
                next if $ary[1]!~/^$student/ && $ary[0]!=$student;
                $i++;
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $adv=$ary[6];
                $adv.="<br>$ary[7]" if ($ary[7] ne "");
                $adv.="<br>$ary[8]" if ($ary[8] ne "");
                $adv.="<br>$ary[9]" if ($ary[9] ne "");
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=28%>$ary[1]</td>
                        <td width=20%>$stat</td>
                        <td width=6%>$ary[4]</td>
                        <td width=6%>$ary[5]</td>
                        <td width=30%>$adv</td>
                        <td width=20%>$def</font></b></td>);
        }
        $entry=qq(<td rowspan=2 align=center bgcolor=#cccccc><font size=+3><p>Попробуйте ввести 
                другую фамилию.</font></td>) if ($i==0);
}

sub  prep {
        $adv=$FORM{'advisor'};
        $sth = $dbh->prepare( qq{SELECT * FROM grads where adv1='$adv'  OR adv2='$adv' OR adv3='$adv' OR adv4='$adv' ORDER BY out,enter,id} ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=30%>Ф.И.О.</td>
                <td width=21%>статус</td>
                <td width=12%>принят</td>
                <td width=12%>окончил</td>
                <td width=25%>защитил</font></b></td>
                );
        while( @ary = $sth->fetchrow_array() ) {
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=30%>$ary[1]</td>
                        <td width=21%>$stat</td>
                        <td width=12%>$ary[4]</td>
                        <td width=12%>$ary[5]</td>
                        <td width=25%>$def</font></b></td>);
        }
        $sth2 = $dbh->prepare( qq{SELECT * FROM grads where name='$adv' } ) or die $dbh->errstr;
        $sth2->execute();
        @ary2 = $sth2->fetchrow_array();
        if (defined($ary2[0])) {
                $adv="<A href='/cgi-bin/grads.pl?$ary2[0]'>$adv</A>";
        }
        $title="Научный руководитель - $adv";
}

sub  allstud {
        $sth = $dbh->prepare( qq(SELECT * FROM grads where status='с' OR status='са' OR status='ас' ORDER BY out,enter,id) ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=28%>Ф.И.О.</td>
                <td width=20%>статус</td>
                <td width=6%>принят</td>
                <td width=6%>окончил</td>
                <td width=30%>научный руководитель</td>
                <td width=20%>защитил</font></b></td>
                );
        $title="У нас получили дипломы:";
        while( @ary = $sth->fetchrow_array() ) {
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $adv=$ary[6];
                $adv.="<br>$ary[7]" if ($ary[7] ne "");
                $adv.="<br>$ary[8]" if ($ary[8] ne "");
                $adv.="<br>$ary[9]" if ($ary[9] ne "");
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=28%>$ary[1]</td>
                        <td width=20%>$stat</td>
                        <td width=6%>$ary[4]</td>
                        <td width=6%>$ary[5]</td>
                        <td width=30%>$adv</td>
                        <td width=20%>$def</font></b></td>);
        }
}

sub  phd {
        $sth = $dbh->prepare( qq(SELECT * FROM grads where status='д' OR status='ас' ORDER BY out,enter,id) ) or die $dbh->errstr;
        $sth->execute();
        $entry= qq(<b><font size=-1>
                <td width=28%>Ф.И.О.</td>
                <td width=20%>статус</td>
                <td width=6%>принят</td>
                <td width=6%>окончил</td>
                <td width=30%>научный руководитель</td>
                <td width=20%>защитил</font></b></td>
                );
        $title="У нас защитили диссертации:";
        while( @ary = $sth->fetchrow_array() ) {
                @ary = map { defined ($_) ? $_ : "" } @ary;
                &status;
                $adv=$ary[6];
                $adv.="<br>$ary[7]" if ($ary[7] ne "");
                $adv.="<br>$ary[8]" if ($ary[8] ne "");
                $adv.="<br>$ary[9]" if ($ary[9] ne "");
                $entry.= qq(<tr bgcolor=#eeeeee align=center>
                        <td bgcolor=#dddddd width=28%>$ary[1]</td>
                        <td width=20%>$stat</td>
                        <td width=6%>$ary[4]</td>
                        <td width=6%>$ary[5]</td>
                        <td width=30%>$adv</td>
                        <td width=20%>$def</font></b></td>);
        }
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

<HTML>
<HEAD>
<TITLE>Sorry</TITLE>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
</HEAD>
<BODY bgcolor=#999999>
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center valign=top>
<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center ID=heading>Результаты поиска</td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr><td align=right valign=top>
<A href="/rus/grad.shtml"><U><B>Назад</B></U></A>
</table>
        
<table border=0 width=85% cellpadding=8 cellspacing=0>
<tr><td align=center valign=top><font size=+2><b>$title</b></font>
</td></tr>
</table>

<table width=80% border=0 bgcolor=#333333 cellpadding=0 cellspacing=0>
<tr><td>

<table width=100% border=0 cellpadding=5 cellspacing=1>
<tr align=center bgcolor=#cccccc>

        $entry

</td></table>
</td></table>
<P></td>
</table>
</CENTER>
</BODY>
</HTML>

EOF
exit;