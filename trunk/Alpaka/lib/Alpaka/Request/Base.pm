package Alpaka::Request::Base;

use strict;

# class methods;

sub new {
	my $class = shift;
	my $self = {};
	
	bless($self, $class);
	$self->_initialize(@_);
	
	return $self;
}

# instance methods

sub _initialize {
	return;
}

sub get {
	my ($self, $key) = @_;
	return;
}

sub params {
	my ($self) = @_;
	return;
}

sub clear {
	my ($self) = @_;
	return;
}

sub delete {
	my ($self, $key) = @_;
	return;
}

sub accept {
	my $self = shift;
	return;
}

sub accept_language {
	my $self = shift;
	return;
}

sub user_agent {
	my ($self) = @_;
	return;
}

sub referer {
	my $self = shift;
	return;
}

sub auth_type {
	my $self = shift;
	return;
}

sub remote_user {
	my $self = shift;
	return;
}

sub remote_host {
	my $self = shift;
	return;
}

sub remote_address {
	my $self = shift;
	return;
}

sub method {
	my $self = shift;
	return;
}

sub as_string {
	my ($self) = @_;
    return
}

1;
