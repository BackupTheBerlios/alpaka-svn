package Alpaka::Request::ModPerl2;

use strict;
use base 'Alpaka::Request::Base';
use Apache2;
use Apache::Request;


# override methods;

sub _initialize {
	my $self = shift;

    $self->{r} = shift;
    $self->{req} = Apache::Request->new( $self->{r} );

	return $self;
}

sub r {
    return $_[0]->{r};
}

sub req {
    return $_[0]->{req};
}

sub get {
	my ($self, $key) = @_;
	
    return $self->{req}->param($key);
}

sub params {
	my $self = shift;
	
    return $self->{req}->param;
}

1;
