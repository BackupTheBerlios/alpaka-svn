package Alpaka::Request::CGI;

use strict;
use CGI;
use overload '""'  => \&as_string;
use base 'Alpaka::Request';

#instance methods

sub _initialize {
	my ($self) = @_;
	
	$self->{request} = CGI->new();
	my $path = $self->{_request}->path_info();
	$path=~s/^\///g; # saco primer /
	($self->{application_key}, $self->{component_key}, $self->{action_key}) = split /\//, $path;
}	

sub get {
	my ($self, $key) = @_;

	return $self->{request}->param($key);
}

sub set {
	my ($self, $key, $value) = @_;

	return $self->{request}->param($key, $value);
}

sub get_cookie {
	my ($self, $key) = @_;

	return $self->{request}->cookie($key);
}

sub get_server_var {
	my ($self, $key) = @_;
	
	return return $self->{request}->http($key)
}

sub keys {
	my ($self, $key) = @_;

	return $self->{request}->param();
}

sub clear {
	my ($self) = @_;

	return $self->{request}->delete_all();
}

sub delete {
	my ($self, $key) = @_;

	return $self->{request}->delete($key);
}

sub accept {
	my $self = shift;
	
	return $self->{request}->Accept(shift)
}

sub accept_language {
	my $self = shift;
	
	return $self->{request}->http('Accept-language')
}

sub user_agent {
	my ($self) = @_;
	
	return $self->{request}->user_agent()
}

sub referer {
	my $self = shift;
	
	return $self->{request}->referer()
}

sub auth_type {
	my $self = shift;
	
	return $self->{request}->auth_type()
}

sub remote_user {
	my $self = shift;
	return $self->{request}->remote_user()
}

sub remote_host {
	my $self = shift;
	
	return $self->{request}->http('Remote-Host')
}

sub remote_address {
	my $self = shift;
	
	return $self->{request}->http('Remote-Address')
}

sub method {
	my $self = shift;
	
	return $self->{request}->request_method()
}

sub as_string {
	my ($self) = @_;

	return $self->{request}->Dump();
}

1;
