package Alpaka::Response::CGI;

use strict;
use base 'Alpaka::Response::Base';
use CGI qw(:cgi);

# override methods;

sub header {
	my ($self, $key, $value) = @_;

	$self->{r}->headers_out->set($key => $value)
	   if (defined $key && defined $value);
}

sub _initialize {
	my ($self) = @_;

    $self->{r} = CGI->new();
	$self->{out} ='';
	$self->{content_type} = 'text/html';
	$self->{cookies} = [];

	return $self;
}

sub r {
    return $_[0]->{r};
}

sub send { 
	my $self = shift;
	
	if ($self->{redirect}) {
	   print $self->{r}->redirect(
			-uri=>$self->{redirect},
			-cookie=>[@{$self->{cookies}}],
		);
	}
	else {
    	print $self->{r}->header(
			-type=>$self->{content_type},
			-cookie=>[@{$self->{cookies}}],
		);
    	print  $self->{out};
	}
}

#cookie management

sub set_cookie {
	my ($self, $c) = @_;
    
    warn "10";
    return unless $c->name;
    warn "11"; 
    my $cookie = CGI::Cookie->new(
        -name    => $c->name,
        -value   => $c->value,
        -expires => $c->expires,
        -domain  => $c->domain,
        -path    => $c->path,
        -secure  => $c->secure
    );
    warn "12"; 
    push @{ $self->{cookies} }, $cookie;
    warn "13"; 
    return;
}

1;
