#!/usr/local/bin/perl -w

#ARGV[0] - seminar number
#use lib qw(.);

use LWP::UserAgent; 
        $ua = LWP::UserAgent->new; 
#        $ua->proxy('http', 'http://www:3128/');
        
$req = HTTP::Request->new('GET' => 'http://www.tamm.lpi.ru/seminars1/ag_vol.html') if $ARGV[0]==1;
$req = HTTP::Request->new('GET' => 'http://www.tamm.lpi.ru/seminars1/ag_keld.html') if $ARGV[0]==2;
$req = HTTP::Request->new('GET' => 'http://www.tamm.lpi.ru/seminars1/ag_gur.html') if $ARGV[0]==3;
$req = HTTP::Request->new('GET' => 'http://www.tamm.lpi.ru/seminars1/ag_vas.html') if $ARGV[0]==4;
        
        $page = $ua->request($req)->content;
#$page=~s|^(.+)<!--start-->(.+)<br>(.+)<!--end-->(.+)$|$<b>2</b><br>$3|si; 
$page=~s#^(.+)<!-- begin -->(.+?)<!-- end -->#$2#si;



print "Content-type: text/html\n\n";
print $page;

exit;