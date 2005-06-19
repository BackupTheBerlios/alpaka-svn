package Alpaka::Request;

use strict;
use Data::Dumper;

=head1 NAME

Alpaka::Request

=head1 SYNOPSIS

    The Request class
    
    my $param = $resquest->get('param');
    my $params = $request->params; # return a hashref 
    my $ua = $request->user_agent;
    my $referer = $request->referer;
    
=cut

=head1 DESCRIPTION
    
=cut


#------------------------------
# Class Methods
#------------------------------

sub new {
	my $class = shift;
	my $self = {};
	
	bless($self, $class);
	$self->_initialize(@_);
	
	return $self;
}

#------------------------------
# Instance Methods
#------------------------------

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

=over 4

=item dispatcher

=cut

sub dispatcher {
	return $_[0]->{dispatcher};
}

=item action

=cut

sub action {
	return $_[0]->{action};
}

=item get

=cut

sub get {
	my ($self, $key) = @_;
	return;
}

=item params

=cut

sub params {
	my ($self) = @_;
	return;
}

=item clear

=cut

sub clear {
	my ($self) = @_;
	return;
}

=item delete

=cut

sub delete {
	my ($self, $key) = @_;
	return;
}

=item accept

=cut

sub accept {
	my $self = shift;
	return;
}

=item accept_language

=cut

sub accept_language {
	my $self = shift;
	return;
}

=item user_agent

=cut

sub user_agent {
	my ($self) = @_;
	return;
}

=item referer

=cut

sub referer {
	my $self = shift;
	return;
}

=item auth_type

=cut

sub auth_type {
	my $self = shift;
	return;
}

=item remote_user

=cut

sub remote_user {
	my $self = shift;
	return;
}

=item remote_host

=cut

sub remote_host {
	my $self = shift;
	return;
}

=item remote_address

=cut

sub remote_address {
	my $self = shift;
	return;
}

=item method

=cut

sub method {
	my $self = shift;
	return;
}

=item is_get

=cut

sub is_get {
	my $self = shift;
	
	return ($self->method eq 'GET');
}

=item is_post

=cut

sub is_post {
	my $self = shift;
	
	return ($self->method eq 'POST') || 0;
}

=item as_string

=cut

sub as_string {
	my ($self) = @_;
    
    return Dumper($self->params)
}

1;
