package Alpaka::Session::File;

use strict;
use base 'Alpaka::Session';


use Storable;


sub load {
	my ($self) = @_;

	my $session;
	eval {$session = retrieve("/tmp/$self->{ID}.session")};

	foreach my $key (keys %$session) {
		$self->{$key}=$session->{$key};
	}
} 


sub save {
	my ($self) = @_;

	if ($self->{_initialized}) {
		my $session;
		foreach my $key (keys %$self){
			$session->{$key} = $self->{$key} unless ($key=~m/^_/) ;
		};
		eval {store $session, "/tmp/$self->{ID}.session"};
	}
}


1;
