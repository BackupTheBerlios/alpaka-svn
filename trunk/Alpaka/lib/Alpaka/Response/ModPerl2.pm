package Alpaka::Response::ModPerl2;

use strict;
use base 'Alpaka::Response::Base';
use Apache::Const -compile => 'REDIRECT';

# override methods;

sub header {
	my ($self, $key, $value) = @_;

	$self->{r}->headers_out->set($key => $value)
	   if (defined $key && defined $value);
}

sub _initialize {
	my ($self, $r) = @_;

    $self->{r} = $r;
	$self->{out} ='';
	$self->{content_type} = 'text/html';

	return $self;
}

sub r {
    return $_[0]->{r};
}

sub send { 
	my $self = shift;
	
	if ($self->{redirect}) {
        $self->{r}->headers_out->set(Location => $self->{redirect});
        $self->{r}->status(Apache::REDIRECT);
	}
	else {
    	$self->{r}->content_type( $self->{content_type} );
    	$self->{r}->print( $self->{out} );
	}
}


1;
