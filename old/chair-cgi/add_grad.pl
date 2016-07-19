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

$sth0 = $dbh->prepare( qq(SELECT * FROM stat) ) or die $dbh->errstr;
$sth0->execute();
while( @ary = $sth0->fetchrow_array() ) {
($grad,$dip,$deg)=@ary[0,1,2];
}

$sth1 = $dbh->prepare( qq(SELECT * FROM grads ORDER BY id) ) or die $dbh->errstr;
$sth1->execute();

$i=1;
@name1 = split /\.\s*/, param('name');
while( @ary = $sth1->fetchrow_array() ) {
        @name2 = split /\.\s*/, $ary[1];
        if($name1[0] eq $name2[0] && $name1[1] eq $name2[1] && param('in') eq $ary[4]) {
#        if(param('name') eq $ary[1] && param('in') eq $ary[4]) {
                $flag=1;
                $id=$ary[0];
                my $dbh2 = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to $data_source: $DBI::errstr";
                my $sth2= $dbh2->prepare( qq(DELETE FROM grads WHERE name='$ary[1]' AND enter='$ary[4]') ) or die $dbh->errstr;
                $sth2->execute();
                
                if (param('defend') eq 'da') {
                        my $sth3 = $dbh2->prepare( qq{UPDATE stat SET degree=$deg} ) or die $dbh->errstr;
                        $sth3->execute();
                        }
                $dbh2->disconnect();        
                }
        if ($ary[0]>$i) {$i=$ary[0];}
        }

$id=$i+1 if ($flag!=1);
$name=param('name');
$sex=param('sex');
$in=param('in');
$out=param('out');
$adv1=param('r_adv1');
$adv2=param('r_adv2');
$adv3=param('r_adv3');
$adv4=param('r_adv4');

$status='б' if (param('status') eq 's' && param('defend') eq 'no');
$status='с' if (param('status') eq 's' && param('defend') eq 'd');
$status='а' if (param('status') eq 'a' && param('defend') eq 'no');
$status='ас' if (param('status') eq 'sa' && param('defend') eq 'da');
$status='са' if (param('status') eq 'sa' && param('defend') eq 'd');
$status='д' if (param('status') eq 'a' && param('defend') eq 'a');

$sth4 = $dbh->prepare( qq(INSERT INTO grads VALUES 
('$id','$name','$sex','$status','$in','$out','$adv1','$adv2','$adv3','$adv4')
) ) or die $dbh->errstr;
$sth4->execute();

if ($flag!=1) {
        $grad++;
        $dip++ if ($status eq 'с' or $status eq 'ас' or $status eq 'са');
        $deg++ if ($status eq 'ас' or $status eq 'д');
        $sth5 = $dbh->prepare( qq{UPDATE stat SET grad=$grad, diploma=$dip, degree=$deg} ) or die $dbh->errstr;
        $sth5->execute();
}


$dbh->disconnect();


print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<TITLE>OK</TITLE>
<meta charset="windows-1251">
</HEAD>
<BODY bgcolor=#999999 onload="document.all.back.focus()">
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
<H1>Выпускник добавлен!</H1>
<P>&nbsp;<P>
<input type=button name=back value="Назад" onclick="document.location='/cgi-bin/chgrads.pl'">
</td></tr>
</table>
</CENTER>
</BODY>
</HTML>
EOF

exit;