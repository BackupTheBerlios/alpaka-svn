package Alpaka::Request::Alpaka;

use strict;
use CGI::Cookie;
use overload '""'  => \&as_string;
use base 'Alpaka::Request';

#instance methods

sub _initialize {
	my $self = shift;
	
	$self->{request} = shift;
	
	my $method = $self->{request}->method;
	$self->_params_from_get() if ($method eq 'GET');
	$self->_params_from_post() if ($method eq 'POST');

	my $uri = $self->{request}->uri;
	$uri=~s/http:\/\///;
	my $host;
	($host,$self->{application_key},$self->{component_key},$self->{action_key}) = split( /\//, $uri );	
	$self->{action_key}=~s/\?.*//;
	
	my $cookie_string = $self->{request}->header("Cookie");
	my $cookies = parse CGI::Cookie($cookie_string);
	$self->{cookies} = $cookies;

}	

sub _params_from_get {
	my ($self) = @_;

	my $uri = $self->{request}->uri;
	my ($base,$query) = split( /\?/, $uri );	
	my %query_string = ();
 	my @parts = split( /\&/, $query );
	foreach my $part (@parts) {
		my ($name, $value) = split( /\=/, $part );
    	$query_string{ "$name" } = $value;
	}
	$self->{params} = \%query_string;
}

sub _params_from_post {
	my ($self) = @_;
	
	my $content = $self->{request}->content;
	my %post_fields = ();
	my @parts = split( /\&/, $content );
	foreach my $part (@parts) {
		my ( $name, $value ) = split( /\=/, $part );
    	$value =~ ( s/%23/\#/g );
    	$value =~ ( s/%2F/\//g );
    	$post_fields{ "$name" } = $value;
	}
	$self->{params} = \%post_fields;
}

sub get {
	my ($self, $key) = @_;

	return $self->{params}->{$key};
}

sub set {
	my ($self, $key, $value) = @_;

	return $self->{params}->{$key} = $value;
}

sub get_cookie {
	my ($self, $cookie) = @_;

	my $c = $self->{cookies}->{$cookie};
	return $c->value if (defined $c);
	return undef;
}

sub get_server_var {
	my ($self, $key) = @_;
	
	return $self->{request}->header($key)
}

sub keys {
	my ($self, $key) = @_;

	return keys %{$self->{params}};
}

sub clear {
	my ($self) = @_;

	undef $self->{params};
}

sub delete {
	my ($self, $key) = @_;

	return delete $self->{params}->{$key};
}

sub accept {
	my $self = shift;
	
	return $self->{request}->header('Accept')
}

sub accept_language {
	my $self = shift;
	
	return $self->{request}->header('Accept-Language')
}

sub user_agent {
	my ($self) = @_;
	
	return $self->{request}->header('User-Agent')
}

sub referer {
	my $self = shift;
	
	return $self->{request}->header('Referer')
}

sub auth_type {
	my $self = shift;
	
	return $self->{request}->header('Auth-Type')
}

sub remote_user {
	my $self = shift;
	
	return $self->{request}->header('Remotr-User')
}

sub remote_host {
	my $self = shift;
	
	return $self->{request}->header('Remote-Host')
}

sub remote_address {
	my $self = shift;
	
	return $self->{request}->header('Remote-Address')
}

sub method {
	my $self = shift;
	
	return $self->{request}->method;
}

sub as_string {
	my ($self) = @_;

	return $self->{request}->as_string();
}

1;
