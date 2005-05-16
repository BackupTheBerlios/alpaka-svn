package Alpaka::Session::File;

use strict;
use Storable;
use base 'Alpaka::Session::Base';

sub load {
	my ($self) = @_;

	my $session;
	eval {$session = retrieve("/tmp/$self->{id}.apksess")};

	foreach my $key (keys %$session) {
		$self->{$key}=$session->{$key};
	}
} 

sub save {
	my ($self) = @_;

    return unless $self->{modified};
	my $session;
	foreach my $key (keys %$self){
		$session->{$key} = $self->{$key} unless ($key=~m/^_/) ;
	};
	eval {store $session, "/tmp/$self->{id}.apksess"};
}

1;
