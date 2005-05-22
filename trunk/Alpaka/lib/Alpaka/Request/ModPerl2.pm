package Alpaka::Request::ModPerl2;

use strict;
use base 'Alpaka::Request::Base';
use Apache2;
use Apache::Request;
use Apache::Connection;
use Apache::RequestRec ( ); # for $r->content_type
use Apache::RequestIO ( );  # for $r->print
use Apache::Const -compile => 'OK';
use Apache::Cookie;
use Alpaka::Cookie;

# override methods;

sub _initialize {
	my $self = shift;

    $self->{r} = shift;
    $self->{req} = Apache::Request->new( $self->{r} );
    ( $self->{component}, $self->{action} ) 
        = $self->_parse_action( $self->{r}->path_info );

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

sub remote_host {

	return $_[0]->{r}->connection->remote_host || $_[0]->{r}->connection->get_remote_host;
}

sub remote_address {

	return $_[0]->{r}->connection->remote_ip;
}

sub method {
	my $self = shift;
	
	return $self->{r}->method
}

sub user {
	my $self = shift;
	
	return $self->{r}->user;
}

#cookie management

sub get_cookie {
	my ($self, $key) = @_;
	
    my $cookie = Apache::Cookie->fetch->{$key};
    #use Data::Dumper;
    #warn $cookie->expires;
    if ($cookie) {
        return Alpaka::Cookie->new(
            name    => $key,
            value   => $cookie->value,
            expires => $cookie->expires,
            domain  => $cookie->domain,
            path    => $cookie->path,
            secure  => $cookie->secure,
        );
    }
    return Alpaka::Cookie->new();
}

1;
