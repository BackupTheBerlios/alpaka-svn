package Alpaka::Request::CGI;

use strict;
use base 'Alpaka::Request::Base';
use CGI qw( :cgi );
use CGI::Cookie;
# override methods;

sub _initialize {
	my $self = shift;


    $self->{req} = CGI->new();
    ( $self->{component}, $self->{action} ) 
        = $self->_parse_action( $self->{req}->path_info );

	return $self;
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
	
    return $self->{req}->Vars;
}

sub remote_host {
	my $self = shift;
	
	return $self->{req}->http('Remote-Host')
}

sub remote_address {
	my $self = shift;
	
	return $self->{req}->http('Remote-Address')
}

sub method {
	my $self = shift;
	
	return $self->{req}->request_method()
}

sub user {
	my $self = shift;
	
	undef
}

#cookie management

sub get_cookie {
	my ($self, $key) = @_;
	
	my %cookies = CGI::Cookie->fetch;
	my $cookie = $cookies{$key};
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
