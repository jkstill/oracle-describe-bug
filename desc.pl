#!/usr/bin/env perl

# template for DBI programs

use warnings;
use FileHandle;
use DBI;
use strict;
use Data::Dumper;

use Getopt::Long;
my %optctl = ();

# global var
my %opSQL = (
	libcachePins => q{select namespace, pins from v$librarycache where namespace = 'TABLE/PROCEDURE'},
	libcacheGets => q{select namespace, gets from v$librarycache where namespace = 'TABLE/PROCEDURE'},
	rowcache => q{select parameter, gets from v$rowcache where parameter in ('dc_users','dc_objects') and subordinate# is null}
);

# call with name of SQL statement, $dbh and reference to hash to return
sub getOpHash;

# pass refs to 2 hashs plus ref to the new hash
# getHashDiff(\%hStart,\%hEnd,\%newHash);
sub getHashDiff;

my $db='p1';
my $username='jkstill';
my $password='grok';
my $describe=0;
my $sysdba=0;
my $sysoper=0;
my $iterations=10000;

Getopt::Long::GetOptions(
	\%optctl, 
	"database=s" => \$db,
	"username=s" => \$username,
	"password=s" => \$password,
	"iterations=i" => \$iterations,
	"describe!" => \$describe,
	"sysdba!" => \$sysdba,
	"sysoper!" => \$sysoper
);

my $connectionMode;

$connectionMode = 0;
if ( $optctl{sysoper} ) { $connectionMode = 4 }
if ( $optctl{sysdba} ) { $connectionMode = 2 }

print $describe ? "Decribing Tables\n" : "Not Describing Tables\n";

#print "USERNAME: $username\n";
#print "DATABASE: $db\n";
#print "PASSWORD: $password\n";
#exit;

my $dbh = DBI->connect(
	'dbi:Oracle:' . $db, 
	$username, $password, 
	{ 
		RaiseError => 1, 
		AutoCommit => 0,
		ora_session_mode => $connectionMode
	} 
	);

die "Connect to  $db failed \n" unless $dbh;

$dbh->{RowCacheSize} = 10;

my %libcacheGetsBegin=();
my %libcacheGetsEnd=();

my %libcachePinsBegin=();
my %libcachePinsEnd=();

my %rowcacheBegin=();
my %rowcacheEnd=();

getOpHash('libcacheGets',$dbh,\%libcacheGetsBegin);
getOpHash('libcachePins',$dbh,\%libcachePinsBegin);
getOpHash('rowcache',$dbh,\%rowcacheBegin);

my $sql=q{select c256 from describe_bug};

for ( my $i=0; $i < $iterations; $i++ ) {

	my $sth = $dbh->prepare($sql,{ora_check_sql => $describe});
	$sth->execute;

	while( my $ary = $sth->fetchrow_arrayref ) {
		#print "\t\t$ary->[0]\n";
	}

	undef $sth;

}


getOpHash('libcacheGets',$dbh,\%libcacheGetsEnd);
getOpHash('libcachePins',$dbh,\%libcachePinsEnd);
getOpHash('rowcache',$dbh,\%rowcacheEnd);

$dbh->disconnect;

my %libcacheGetsDiff=();
my %libcachePinsDiff=();
my %rowcacheDiff=();

getHashDiff( \%libcacheGetsBegin, \%libcacheGetsEnd, \%libcacheGetsDiff);
getHashDiff( \%libcachePinsBegin, \%libcachePinsEnd, \%libcachePinsDiff);
getHashDiff( \%rowcacheBegin, \%rowcacheEnd, \%rowcacheDiff);

# report
print "libcache gets: $libcacheGetsDiff{'TABLE/PROCEDURE'}\n";
print "libcache pins: $libcachePinsDiff{'TABLE/PROCEDURE'}\n";
foreach my $key (sort keys %rowcacheDiff) { print "$key: $rowcacheDiff{$key}\n" }

sub usage {
	my $exitVal = shift;
	$exitVal = 0 unless defined $exitVal;
	use File::Basename;
	my $basename = basename($0);
	print qq/

usage: $basename

  --database      target instance
  --username      target instance account name
  --password      target instance account password
  --iterations    SQL iterations - default 10000
  --describe      enable describe (default)
  --no-describe   disable describe 
  --sysdba        logon as sysdba
  --sysoper       logon as sysoper

  example:

  $basename -database dv07 -username scott -password tiger -sysdba 
/;
   exit $exitVal;
};

sub errExit {
	my $dbh = shift;
	my $msg = shift;
	warn "Something happened, here is the message:\n";
	warn $msg;

	$dbh->disconnect;
	exit 1;
	
}

# call with name of SQL statement, $dbh and reference to hash to return
sub getOpHash {
	my ($sqlName, $dbh, $hRef)= @_;
	errExit($dbh, "sql statement $sqlName not found") unless exists($opSQL{$sqlName});

	# reduce the effect of this SQL on the stats by not using prepare(ora_check_sql)
	my $sth = $dbh->prepare($opSQL{$sqlName},{ora_check_sql => 0});

	$sth->execute;

	while( my $ary = $sth->fetchrow_arrayref ) {
		#print "\t\t$ary->[0]\n";
		$hRef->{$ary->[0]} = $ary->[1];
	}

}


# pass refs to 2 hashs plus ref to the new hash
# getHashDiff(\%hStart,\%hEnd,\%newHash);
sub getHashDiff {
	my ($hrefStart, $hrefEnd, $newHRef) = @_;

	# number of keys must match
	
	if ( scalar keys %{$hrefStart} != scalar keys %{$hrefEnd} ) {
		# global dbh
		errExit($dbh, 'Uneven number of keys in begin/end hashrefs in getHashDiff()');
	}

	foreach my $key ( keys %{$hrefStart}) {
		$newHRef->{$key} = $hrefEnd->{$key} - $hrefStart->{$key};
	}
	
}


