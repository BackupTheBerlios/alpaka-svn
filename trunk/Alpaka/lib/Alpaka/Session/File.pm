package Alpaka::Session::File;

use strict;
use Storable;
use base 'Alpaka::Session::Base';

sub load {
	my ($self) = @_;

	my $data;
	eval {$data = retrieve("/tmp/$self->{id}.apksess")};

    $self->{data}= $data
} 

sub save {
	my ($self) = @_;

    return unless $self->{modified};
	my $data = $self->{data};
	eval {store $data, "/tmp/$self->{id}.apksess"};
}

1;
