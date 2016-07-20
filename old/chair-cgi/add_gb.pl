#!/usr/local/bin/perl -w

#$ARGV[0] - language

use DBI;
use CGI qw (:param);
use CGI::Carp qw(fatalsToBrowser);

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

$answer=param('answer');
$number=param('number');
$sth = $dbh->prepare( qq(SELECT * FROM guard WHERE id=$number) ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
if($answer ne $ary[1]) {
        if($ARGV[0] eq 'eng') {
                $meta='';
                $back='to Guest book';
                $ref='/cgi-bin/show_gb.pl?1+1+eng';
                &return_page('Check your answer!');
        }
        if($ARGV[0] eq 'rus') {
                $meta=qq(<meta charset="windows-1251">);
                $back='в гостевую книгу';
                $ref='/cgi-bin/show_gb.pl?1+1+rus';
                &return_page('Проверьте Ваш ответ!');
        }
}


$sth = $dbh->prepare( qq(SELECT COUNT(*) FROM guest_book) ) or die $dbh->errstr;
$sth->execute();
@ary = $sth->fetchrow_array();
$id=$ary[0]+1;

$sender=param('title');
$mail=param('email');
$mes=param('message');

&check_fields;
&get_date;
&check_message;

$sth = $dbh->prepare( qq(INSERT INTO guest_book VALUES  ("$id","$date","$sender","$mail","$mes")
) ) or die $dbh->errstr;
$sth->execute();

&success_page;

sub check_fields
{
        if($sender eq "" or $mes eq "") {
                if($ARGV[0] eq 'eng') {
                        $meta='';
                        $back='back to Guest book';
                        $ref='/cgi-bin/show_gb.pl?1+1+eng';
                        &return_page('It seems you have nothing to say...');
                }
                if($ARGV[0] eq 'rus') {
                        $meta=qq(<meta charset="windows-1251">);
                        $back='в гостевую книгу';
                        $ref='/cgi-bin/show_gb.pl?1+1+rus';
                        &return_page('Похоже, вам нечего сказать...');
                }
                exit;
        }
}

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
                if($ARGV[0] eq 'rus') {
                        $meta=qq(<meta charset="windows-1251">);
                        $back='на главную страницу';
                        $ref='/rus/main.shtml';
                        &return_page('Даже не пытайтесь...');
                }
                if($ARGV[0] eq 'eng') {
                        $meta='';
                        $back='to main page';
                        $ref='/eng/main.shtml';
                        &return_page("Don't waste your time...");
                }
        exit;
        }
}

sub success_page
{
        if($ARGV[0] eq 'eng') {
                $meta='';
                $back='to Guest book';
                $ref='/cgi-bin/show_gb.pl?1+1+eng+guest_book';
                &return_page('Your record has been accepted!');
        }
        if($ARGV[0] eq 'rus') {
                $meta=qq(<meta charset="windows-1251">);
                $back='в гостевую книгу';
                $ref='/cgi-bin/show_gb.pl?1+1+rus+guest_book';
                &return_page('Ваша запись принята!');
        }
}

sub return_page {
print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<TITLE>Error</TITLE>
</HEAD>
<BODY bgcolor=#999999 onload="document.all.back.focus()">
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
<H1>$_[0]</H1>
<P>&nbsp;<P>
<input type=button name=back value="$back" onclick="document.location='$ref'">
</td></tr>
</table>
</CENTER>
</BODY>
</HTML>
EOF
exit;
}