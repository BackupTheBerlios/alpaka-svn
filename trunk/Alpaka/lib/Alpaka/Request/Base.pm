package Alpaka::Request::Base;

use strict;
use Data::Dumper;

# class methods;

sub new {
	my $class = shift;
	my $self = {};
	
	bless($self, $class);
	$self->_initialize(@_);
	
	return $self;
}

# instance methods

sub _parse_action {
	my ( $self, $path ) = @_;

    $path =~ m/^\/(.+)\/(.+)\.do$/;
    my $dispatcher = $1 || $path;
    my $action = $2 || 'index';
    $dispatcher = '' if $dispatcher =~ m/\.do$/;
    $dispatcher =~ s/^\///;
    $dispatcher =~ s/\/$//;
    $dispatcher = $dispatcher || '_default';

    return ($dispatcher, $action);
}

sub _initialize {
	return;
}

sub dispatcher {
	return $_[0]->{dispatcher};
}

sub action {
	return $_[0]->{action};
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

sub is_get {
	my $self = shift;
	
	return ($self->method eq 'GET');
}

sub is_post {
	my $self = shift;
	
	return ($self->method eq 'POST') || 0;
}

sub as_string {
	my ($self) = @_;
    
    return Dumper($self->params)
}

1;
