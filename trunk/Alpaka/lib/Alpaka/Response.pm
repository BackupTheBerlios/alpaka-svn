package Alpaka::Response;

use strict;

=head1 NAME

Alpaka::Response

=head1 SYNOPSIS

    The Response class
    
    $response->content_type('text/html');
    $response->write('Hello World!');
    $response->clear;
    $response->redirect('http://alpaka.berlios.de');
    
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
	
	$self->{out} ='';
	$self->{content_type} = 'text/html';
	$self->_initialize(@_);
	
	return $self;
}

#------------------------------
# Instance Methods
#------------------------------

sub _initialize {
	return;
}

sub header {
	return;
}

sub send {
	return;
}

=over 4

=item content_type

    Sets the response content type. The default content-type is
    'text/html'.

=cut

sub content_type {
	my ($self, $type) = @_;

	$self->{content_type} = $type if defined $type ;
	return $self->{content_type};
}

=item write

    Write to the response object. The response is buffered until
    the application is ready to send it.

=cut

sub write {
	my ($self, $out) = @_;

	$self->{out} .= $out;
}

=item clear

    Clear the response buffer.

=cut

sub clear {
	my ($self) = @_;

	$self->{out} ="";
}

=item redirect

    Redirect to another URI.

=cut

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
	
    return $self->{out}
}


1;
