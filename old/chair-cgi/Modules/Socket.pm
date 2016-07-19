package Modules::Socket;

BEGIN {
use IO::Socket;
use Exporter ();

@ISA = "Exporter";
@EXPORT = qw(&get_ya_page);
}


sub get_ya_page {

	my ($path, $p) = @_;
	my $page;
	$port = '80' unless $port;
	my $url = "yandex.ru";

	$path =~ s/(\W)/'%'.unpack("H*",$1)/eg;
	$path = "/yandsearch?text=$path&lr" unless $p;
	$path = "/yandsearch?p=$p&text=$path&lr=213" if $p;

	my $sock = IO::Socket::INET->new(PeerAddr => $url, PeerPort => $port, Proto => 'tcp', Timeout => 60) || die 'Ошибка получения страницы';
	$sock->autoflush;
	print $sock join("\015\012" => "GET $path HTTP/1.0", "Host: $url", "User-Agent: my agent", "", "");

	$page .= $_ while <$sock>;

	close $sock;
	return $page;
}



1;
