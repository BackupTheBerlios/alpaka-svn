package Alpaka::Session::File;

use strict;
use base 'Alpaka::Session';
use Storable qw( lock_store lock_retrieve );

sub load {
	my ($self) = @_;

	my $data;
	eval {$data = lock_retrieve("/tmp/$self->{id}.apksess")};
    $self->data($data);
} 

sub save {
	my ($self) = @_;

    return unless $self->{modified};
	my $data = $self->data;
	eval {lock_store $data, "/tmp/$self->{id}.apksess"};
}

1;
