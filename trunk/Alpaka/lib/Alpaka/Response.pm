package Alpaka::Response;

use strict;
use CGI;
use CGI::Cookie;

#use overload '""'  => \&as_string; # ver porque no se puede usar a veces la sobrecarga (en setters/getters)

#class methods

sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	
	$self->_initialize(shift);
	
	return $self;
}

#instance methods

sub content_type{
	my ($self, $type) = @_;

	$self->{content_type} = $type if $type ;
	return $self->{content_type};
}

sub set_cookie {
	my ($self, $name, $value, $expire, $domain, $path, $secure) = @_;
	
	push @{$self->{cookies}}, new CGI::Cookie ($name, $value, $expire, $domain, $path, $secure);
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

	$self->{redirect} = $uri;
}

sub buffer_size {
	my ($self) = @_;

	return length($self->{out});
}



#override methods;

sub _initialize {
	my ($self) = @_;

	$self->{out} ="";
	
	$self->{status} =0;
	$self->{content_type} = "text/html";
	my @cookies;
	$self->{cookies} = \@cookies;

	return $self;
}

sub as_string { 
	my $self = shift;
	
	my $out = $self->_get_header;
	if (!$self->{redirect}) {
		$out .= $self->{out};
	}	
	return $out;
}

sub send {
	my $self = shift;
	
	$self->{out} .= shift;
	print $self->as_string();
}

sub _get_header {
	my $self = shift;
	
	my $header_out;
 	if ($self->{redirect}) { 
		$header_out = CGI::redirect(
			-uri=>$self->{redirect},
			-cookie=>[@{$self->{cookies}}],
		);
	}
	else {
		$header_out = CGI::header(
			-type=>$self->{content_type},
			-cookie=>[@{$self->{cookies}}],
		);	# si es hay error enviar un header mas pequeño ?
	}	
}

1;
