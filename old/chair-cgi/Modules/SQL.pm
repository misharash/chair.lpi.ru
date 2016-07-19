package Modules::SQL;

BEGIN {
use DBI;
use Exporter ();
@ISA = "Exporter";
@EXPORT = qw(&sql_connect &default_connect &sql_get_hash &sql_get_row  &sql_get_scalar &sql_get_array &sql_count &sql_do);
}

sub sql_connect {
	my $init = shift;
	my $dsn = "DBI:mysql:$$init{db}:$$init{host}";

	$dbh = DBI -> connect($dsn, $$init{user}, $$init{pass}) or die "Can't connect: $DBI::errstr";

	return $dbh;
}


sub default_connect {
	my $db = shift;
	my $dsn = "DBI:mysql:$db;mysql_read_default_file=/etc/my.cnf";

	$dbh = DBI -> connect($dsn, 'root', '') or die "Can't connect: $DBI::errstr";

	return $dbh;
}


sub sql_get_hash {
	
	my $sql = shift;
	my @params = @_;
	$sql =~ s!\?!<?param?>!sg;
	$sql =~ s!<\?param\?>!'$_'! foreach (@params);

	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();

	my $res = ();
	while (my $str = $sth -> fetchrow_hashref) {
		defined ($_) ? 1 : ($_ = '') foreach values %$str;
		push @$res, $str;
	}

	return $res;
}


sub sql_get_row {
	
	my $sql = shift;
	my @params = @_;
	$sql =~ s!\?!<?param?>!sg;
	$sql =~ s!<\?param\?>!'$_'! foreach (@params);

	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();

	my $res = $sth -> fetchrow_hashref;
	defined ($_) ? 1 : ($_ = '') foreach values %$res;
	
	return $res;
}



sub sql_get_array {
	
	my $sql = shift;
	my @params = @_;
	$sql =~ s!\?!<?param?>!sg;
	$sql =~ s!<\?param\?>!'$_'! foreach (@params);

	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();

	my @res = ();
	while ($sql = $sth -> fetchrow_arrayref) {
#		defined ($_) ? 1 : ($_ = '') foreach @$res;
		push @res, $sql;
	}
	return @res;
}


sub sql_get_scalar {
	
	my $sql = shift;
	my @params = @_;
	$sql =~ s!\?!<?param?>!sg;
	$sql =~ s!<\?param\?>!'$_'! foreach (@params);

	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();
	return $sth -> fetchrow_array;
}


sub sql_count {
	
	my $base = shift;
	my $params = shift;
	my $conditions = ''; 
	$conditions .= " AND $_ = $params->{$_}" foreach (keys %$params);
	my $sql = "SELECT COUNT(*) FROM $base WHERE 1 $conditions";

	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();
	return $sth -> fetchrow_array;
}

sub sql_do {
	
	my $sql = shift;

print "Content-type: text/html;charset=windows-1251\n\n";
print $dbh;

	my @params = @_;
	$sql =~ s!\?!<?param?>!sg;
	$sql =~ s!<\?param\?>!'$_'! foreach (@params);
	my $sth = $dbh -> prepare($sql) or die $dbh -> errstr;
	$sth -> execute();
}



1;
