package Alpaka::Response::ModPerl1;

use strict;
use base 'Alpaka::Response';

use Apache::Request;
use Apache::Constants qw( OK REDIRECT );

# override methods;

sub header {
	my ($self, $key, $value) = @_;

	$self->{r}->header_out->set($key => $value)
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
        $self->{r}->status( REDIRECT );
        $self->{r}->send_http_header;
	}
	else {
    	$self->{r}->send_http_header( $self->{content_type} );
    	$self->{r}->print( $self->{out} );
	}
}

#cookie management

sub set_cookie {
	my ($self, $c) = @_;
    
    return unless ($c->{name} && $c->{value});
    my $cookie = Apache::Cookie->new($self->{r},
        -name => $c->{name},
        -value =>$c->{value},
    );

    $cookie->expires( $c->{expires} ) if defined $c->{expires};
    $cookie->domain( $c->{domain} ) if defined $c->{domain};
    $cookie->path( $c->{path} )  if defined $c->{path};
    $cookie->secure( $c->{secure} ) if defined $c->{secure};

    $cookie->bake;
    return;
}

1;
