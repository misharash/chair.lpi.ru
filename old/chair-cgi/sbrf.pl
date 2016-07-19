#!/usr/local/bin/perl -w

use LWP::UserAgent;
use Data::Dumper;

my $lwp = LWP::UserAgent->new; 

my $req = 'http://ya.ru'; 

my $response = $lwp->get($req);


print "Content-type: text/html; charset=windows-1251\n\n";

 if ($response->is_success) {
     print $response->decoded_content;
 }
 else {
     die $response->status_line;
}

exit;