package MiniNews::Model;

use strict;
use warnings;
use v5.10;
use DBIx::Simple;
use SQL::Abstract;
use Carp qw/croak/;

use Mojo::Loader;

# Reloadable Model
my $modules = Mojo::Loader->search('MiniNews::Model');
for my $module (@$modules) {
    Mojo::Loader->load($module)
}

my $DB;

sub init {
    my ($class, $config) = @_;
    croak "No dsn was passed!" unless $config && $config->{dsn};

    unless ($DB) {
        $DB = DBIx::Simple->connect(@$config{qw/dsn user password/}, {RaiseError => 1}) 
	      or die DBIx::Simple->error;
	$DB->abstract = SQL::Abstract->new(
	      case    => 'lower',
	      logic   => 'and'
	);
    }

    return $DB;
}

sub db {
    return $DB if $DB;
    croak "You should init model first!";
}

1;

