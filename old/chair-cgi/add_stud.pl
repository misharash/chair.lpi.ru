#!/usr/local/bin/perl -w

#$ARGV[0] - language, $ARGV[1] - add/del (1|2)

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
$y[7]='à';
$y[8]='p';


&del_rec if($ARGV[1]==1);
&add_rec if($ARGV[1]==2);
exit;

sub del_rec 
{
$i=0;
for ($j=0; $j<9;$j++) {
$sth1 = $dbh->prepare( qq(SELECT * FROM students WHERE e_year='$y[$j]' ORDER BY last_name) ) or die $dbh->errstr;
$sth1->execute();

while( @ary = $sth1->fetchrow_array() ) {
        $i++;
        if(param($i) eq 'on') {
                $sth2= $dbh->prepare( qq(DELETE FROM students WHERE last_name='$ary[0]') ) or die $dbh->errstr;
                $sth2->execute();
                }
        }
}
$dbh->disconnect();
&success_page;
}

sub add_rec 
{
$sth1 = $dbh->prepare( qq(SELECT * FROM students ) ) or die $dbh->errstr;
$sth1->execute();

while( @ary = $sth1->fetchrow_array() ) {
        if(param('lastname') eq $ary[0] && param('name') eq $ary[1].' '.$ary[2]) {
                $sth2= $dbh->prepare( qq(DELETE FROM students WHERE last_name='$ary[0]') ) or die $dbh->errstr;
                $sth2->execute();
                }
        }

$year=substr(param('group'),0,1);
($name,$otch)=split(/\s/,param('name'));
$last=param('lastname');
$mail=param('mail');
$group=param('group');
$sci_deg1=param('sci_deg1');
$r_adv1=param('r_adv1');
$sci_deg2=param('sci_deg2');
$r_adv2=param('r_adv2');
$sci_deg3=param('sci_deg3');
$r_adv3=param('r_adv3');
$sci_deg4=param('sci_deg4');
$r_adv4=param('r_adv4');

$sth3 = $dbh->prepare( qq(INSERT INTO students VALUES 
('$last','$name','$otch','$mail','$group','$sci_deg1','$r_adv1','$sci_deg2','$r_adv2',
'$sci_deg3','$r_adv3','$sci_deg4','$r_adv4','$year')
) ) or die $dbh->errstr;
$sth3->execute();

$dbh->disconnect();
        &success_page;
}

sub success_page
{
        if ($ARGV[0] eq 'eng') {
                $meta='';
                $back='to Students';
                $ref='/cgi-bin/chstuds.pl?eng';
                &return_page('Your changes have been accepted!');
        }
        if ($ARGV[0] eq 'rus') {
                $meta=qq(<meta charset="windows-1251">);
                $back='back to editing';
                $ref='/cgi-bin/chstuds.pl?rus';
                &return_page('update is successfull!');
        }
}

sub return_page {
print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<TITLE>OK</TITLE>
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

}