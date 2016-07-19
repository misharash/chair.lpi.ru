#!/usr/local/bin/perl -w

use CGI::Carp qw(fatalsToBrowser);
use Modules::Socket;
use Modules::Request;
use Modules::SQL;


$DB_HOST = 'localhost';
$DB_NAME = 'rchair';
$DB_USER = 'chair';
$DB_PASSWORD = 'casimir';
$DB_CHARSET = 'WIN1251';
$dsn = "DBI:Firebird:database=$DB_NAME;host=$DB_HOST;ib_charset=$DB_CHARSET";

my $dbh = DBI->connect($dsn, $DB_USER, $DB_PASSWORD) or die "Can't connect to $data_source: $DBI::errstr";

my $sql = "CREATE TABLE query_results (
  id int(11) NOT NULL AUTO_INCREMENT,
  host varchar(255) NOT NULL,
  query varchar(255) NOT NULL,
  position int(11) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=cp1251;";

my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
$sth -> execute();

print "Content-type: text/html;charset=windows-1251\n\n";

my ($page, $result, $table);

#my $dbh = default_connect('test');
my $DATA = get_form_data;

my @query = grep /query/, keys %$DATA;


my $host = $DATA->{host};
$host =~ s/\s//g;
$host .= '/';
$host =~ s!(?:http://)?(?:www\.)?(.+?)/+.*!$1!;

my $a;

foreach (@query) {

	$result = '';

	my $query = utf2cp($DATA->{$_});

	foreach (0..2) {
		my $page = get_ya_page($query, $_);
	
		my @blocks = $page =~ m!<li.+?</li>!sg;
		foreach (@blocks) {
			my ($d, $h) = $_ =~ m!="cu">(\d+)\.</b>.+?="ei">(?:http://)?(?:www\.)?(.*?)</span>!s;

			$h =~ s!(<b>|</b>)!!g;
			$result = $d if $h =~ /^$host/;

			last if $result;
		}
		last if $result;
	}

	$result ||= '0';

	sql_do("INSERT INTO query_results (host,query,position) VALUES (?,?,?)", $host, $query, $result);

}

my $list = sql_get_hash("SELECT * FROM query_results ORDER BY id DESC");
foreach (@$list) {
	$table .= "<tr><td align=center>$_->{host}</td><td align=center>$_->{query}</td><td align=center>$_->{position}</td>\n";
}


print <<EOF;
<table width=200 border=1>
	<tr><th align=center>Хост</th><th align=center>Запрос</th><th align=center>Место</th>
	$table
</table>
EOF


1;

