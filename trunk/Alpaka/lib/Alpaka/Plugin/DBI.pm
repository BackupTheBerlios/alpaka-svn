package Alpaka::Plugin::DBI;
use strict;

use DBI;
use Exporter;

use vars qw(@ISA @EXPORT );
@ISA = qw(Exporter);

@EXPORT = qw( db_connect db_disconnect dbh );

sub dbh {
    my $self = shift;
    
    my $dbi_slot = $self->slot('dbi');
    return $dbi_slot->{dbh} ;
}

sub db_connect {
    my $self = shift;
    
    my $dbi_slot = $self->slot('dbi');
    $dbi_slot->{dbh} = DBI->connect(@_);
}

sub db_disconnect {
    my $self = shift;
    
    $self->dbh->disconnect if $self->dbh;
}
1;