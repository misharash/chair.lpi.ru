#!/usr/local/bin/perl -w

# $ARGV[0]-selected page, $ARGV[1]-1st page shown

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

$sth = $dbh->prepare( qq(SELECT COUNT(*) FROM news WHERE age='n') ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
$num_of_rec=$ary[0];

$news2show=2;
$buts2show=5;

&get_news;
&get_buts;
&show_page;
exit;


sub get_news {

$sth = $dbh->prepare( qq(SELECT * FROM news WHERE age='n' ORDER BY num DESC) ) or die $dbh->errstr;
$sth->execute();
$i=0;
while( @ary = $sth->fetchrow_array() ) {
                $i++;
                next if( $i<$news2show*($ARGV[0]-1) +1);

        $ary[3]=~s/(\bwww\.\S+\.\S+\b)/<A href=\"http:\/\/$1\">$1<\/A>/ig;
        $ary[3]=~s/(\b\S+\@\S+(\.\S+)+\b)/<A href=\"mailto:$1\">$1<\/A>/ig;
        $ary[3]=~s/\n/<BR>/ig;
        $recs.="<TR><TD><div align=right><B>".$ary[1]."</B></div><BR>
<div align=left><Font size=+1><B>&nbsp;&nbsp;&nbsp;&nbsp;Тема:
<U>".$ary[2]."</U></B></Font></div><BR>".$ary[3]."<hr noshade color=#ffffff><P></TD>\n";

                last  if( ($i==$news2show*$ARGV[0]) || ($i==$num_of_rec) );
        }
}

sub get_buts {
        $buts='';
        $slash='/';
        $total=1;
        $total=2 if (0!=$num_of_rec % $news2show);
        $total+=int ($num_of_rec / $news2show);
        goto EMPTY if($total==2);
        if($ARGV[1]>1) {
        $j=$ARGV[1]-$buts2show;
        $buts.=qq(<A href="/cgi-bin/show_news.pl?$ARGV[0]+$j"><< </A>);
        }
        else {
        $buts.='';
        }
        for ($i=$ARGV[1]; ($i<$ARGV[1]+$buts2show) && ($i<$total); $i++) {
                local $slash='' if( ($i==$ARGV[1]+$buts2show-1) || ($i==$total-1) );
                if($i==$ARGV[0]) {
                        $buts.=qq(<B style="color:#666666">$i </B> $slash\n);
                }
                else {
                        $buts.=qq(<A href="/cgi-bin/show_news.pl?$i+$ARGV[1]">$i </A>$slash \n);
                }
        }
        if($ARGV[1]+$buts2show<$total) {
        $j=$ARGV[1]+$buts2show;
        $buts.=qq(<A href="/cgi-bin/show_news.pl?$ARGV[0]+$j">>></A>);
        }
        else {
        $buts.='';
        }
EMPTY:
}

sub show_page {

print <<EOF;
Content-type: text/html

<html>
<head>
<title>Новости</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
<STYLE type="text/css">
.off
        {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
.on
        {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
A 
        {font-weight:bold; font-family:Arial}
</STYLE>
<META HTTP-EQUIV="Expires" CONTENT="1 Jan 2000">
</head>     

<body bgcolor=#999999 text=#111111 alink=black vlink=black link=black>

<center>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center valign=top>

<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td rowspan=2 width=67% align=right ID=heading>Новости <Font face="Wingdings">.</Font></td>
    <td align=right valign=bottom>
        <u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
onclick="window['actype'] ='add&rus'; window.open('/password.html','','left=300,top=300,toolbar=0,scrollbars=0,menubar=0,resizable=0,width=400,height=50');">
        Добавить новость</u></td>
<tr><td align=right valign=top>
        <u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
onclick="window['actype'] ='del&rus'; window.open('/password.html','','left=300,top=300,toolbar=0,scrollbars=0,menubar=0,resizable=0,width=400,height=50');"
        title='отправить новости в архив'>Удалить новости</u></td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=left><font size=+1 color=black>
$buts
</font>
</td>
</tr>
</table>

<table width=80% border=0 cellpadding=10 cellspacing=0>
$recs
</table>

</td></tr>
</table>
</center>

</body>
</html>
EOF
}