package Alpaka::Request;

use strict;
use CGI;
use overload '""'  => \&as_string;

#class methods

sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	
	$self->_initialize(shift);
	
	return $self;
}

#instance methods

sub application_key {
	my ($self, $application_key) = @_;
	
	$self->{application_key}=$application_key if $application_key;
	return $self->{application_key};
}

sub component_key {
	my ($self, $component_key) = @_;
	
	$self->{component_key}=$component_key if $component_key;
	return $self->{component_key};
}

sub action_key {
	my ($self, $action_key) = @_;
	
	$self->{action_key}=$action_key if $action_key;
	return $self->{action_key};
}

#override methods;

sub _initialize {
	my ($self) = @_;
	$self->{application_key} = undef;
	$self->{component_key} = undef;
	$self->{action_key} = undef;
}	

sub get {
	my ($self, $key) = @_;
	return undef;
}

sub set {
	my ($self, $key, $value) = @_;
	return undef;
}

sub get_cookie {
	my ($self, $key) = @_;
	return undef;
}

sub get_server_var {
	my ($self, $cookie) = @_;
	return undef;
}

sub keys {
	my ($self, $key) = @_;
	return undef;
}

sub clear {
	my ($self) = @_;
	return undef;
}

sub delete {
	my ($self, $key) = @_;
	return undef;
}

sub accept {
	my $self = shift;
	return undef;
}

sub accept_language {
	my $self = shift;
	return undef;
}

sub user_agent {
	my ($self) = @_;
	return undef;
}

sub referer {
	my $self = shift;
	return undef;
}

sub auth_type {
	my $self = shift;
	return undef;
}

sub remote_user {
	my $self = shift;
}

sub remote_host {
	my $self = shift;
	return undef;
}

sub remote_address {
	my $self = shift;
	return undef;
}

sub method {
	my $self = shift;
	return undef;
}

sub as_html {
	my ($self) = @_;
	return $self->as_string;
}

sub as_string {
	my ($self) = @_;
	return undef;
}

1;
