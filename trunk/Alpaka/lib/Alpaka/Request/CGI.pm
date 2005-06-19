package Alpaka::Request::CGI;

use strict;
use base 'Alpaka::Request';
use CGI qw( :cgi );
use CGI::Cookie;
# override methods;

sub _initialize {
	my $self = shift;


    $self->{r} = CGI->new();
    ( $self->{dispatcher}, $self->{action} ) 
        = $self->_parse_action( $self->{r}->path_info );

	return $self;
}

sub r {
    return $_[0]->{r};
}

sub get {
	my ($self, $key) = @_;
	
    return $self->{r}->param($key);
}

sub keys {
	my $self = shift;
	
    return $self->{req}->param;
}

sub params {
	my $self = shift;
	
    return $self->{r}->Vars;
}

sub remote_host {
	my $self = shift;
	
	return $self->{r}->remote_host;
}

sub remote_address {
	my $self = shift;
	
	return $self->{r}->remote_host;
}

sub method {
	my $self = shift;
	
	return $self->{r}->request_method;
}

sub user {
	my $self = shift;
	
	return $self->{r}->remote_user;
}

sub user_agent {
	my $self = shift;
	
	return $self->{r}->http('User-Agent')
}

sub referer {
	my $self = shift;
	
	return $self->{r}->http('Referer');
}

sub accept {
	my $self = shift;
	
	return $self->{r}->http('Accept');
}

sub accept_encoding {
	my $self = shift;
	
	return $self->{r}->http('Accept-Encoding');
}
#cookie management

sub get_cookie {
	my ($self, $key) = @_;
	
	my %cookies = CGI::Cookie->fetch;
	my $cookie = $cookies{$key};
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
