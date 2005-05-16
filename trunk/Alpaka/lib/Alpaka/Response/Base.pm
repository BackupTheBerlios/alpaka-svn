package Alpaka::Response::Base;

use strict;

#class methods

sub new {
	my $class = shift;
	my $self = {};
	
	bless($self, $class);
	
	$self->{out} ='';
	$self->{content_type} = 'text/html';
	$self->_initialize(@_);
	
	return $self;
}

#instance methods

sub _initialize {
	return;
}

sub header {
	return;
}

sub send {
	return;
}

sub content_type {
	my ($self, $type) = @_;

	$self->{content_type} = $type if defined $type ;
	return $self->{content_type};
}

sub write {
	my ($self, $out) = @_;

	$self->{out} .= $out;
}

sub clear {
	my ($self) = @_;

	$self->{out} ="";
}

sub redirect {
	my ($self, $uri) = @_;

	$self->{redirect} = $uri if defined $uri;
}

sub buffer_size {
	my ($self) = @_;

	return length($self->{out});
}

sub output { 
	my $self = shift;
	
	return $self->{out};
}

sub as_string {
	my ($self) = @_;
	
    return
}


1;
