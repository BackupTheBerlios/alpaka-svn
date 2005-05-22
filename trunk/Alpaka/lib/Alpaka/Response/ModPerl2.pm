package Alpaka::Response::ModPerl2;

use strict;
use base 'Alpaka::Response::Base';
use Apache2;
use Apache::Request;
use Apache::Connection;
use Apache::RequestRec ( ); # for $r->content_type
use Apache::RequestIO ( );  # for $r->print
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
