package Alpaka::Request::ModPerl2;

use strict;
use base 'Alpaka::Request';
use Apache2;
use Apache::Request;
use Apache::Connection;
use Apache::RequestRec ( ); # for $r->content_type
use Apache::RequestIO ( );  # for $r->print
use Apache::Const qw( OK );
use Apache::Cookie;

# override methods;

sub _initialize {
	my $self = shift;

    $self->{r} = shift;
    $self->{req} = Apache::Request->new( $self->{r} );
    ( $self->{dispatcher}, $self->{action} ) 
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

sub keys {
	my $self = shift;
	
    return $self->{req}->param;
}

sub params {
	my $self = shift;
	
	my @keys = $self->keys;
	my %params;
	foreach my $key (@keys) {
	   my @values = $self->get($key);
	   $params{$key} = shift @values if (@values == 1);
	   $params{$key} = \@values if (@values > 1);
	}
    return \%params;
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

sub user_agent {
	my $self = shift;
	
	return $self->{r}->headers_in->get('User-Agent');
}

sub referer {
	my $self = shift;
	
	return $self->{r}->headers_in->get('Referer');
}

sub accept {
	my $self = shift;
	
	return $self->{r}->headers_in->get('Accept');
}

sub accept_encoding {
	my $self = shift;
	
	return $self->{r}->headers_in->get('Accept-Encoding');
}

#cookie management

sub get_cookie {
	my ($self, $key) = @_;
	
    my $ac = Apache::Cookie->fetch;
    my $cookie = $ac->{$key} if $ac;
    if ($cookie) {
        return {
            name    => $key,
            value   => $cookie->value,
            expires => $cookie->expires,
            domain  => $cookie->domain,
            path    => $cookie->path,
            secure  => $cookie->secure,
        };
    }
    return undef;
}

1;
