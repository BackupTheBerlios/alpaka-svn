package Alpaka::Response::Alpaka;

use strict;

use base 'Alpaka::Response';

#use overload '""'  => \&as_string; # ver porque no se puede usar a veces la sobrecarga (en setters/getters)


sub _initialize {
	my $self = shift;

	$self->{out} ="";
	$self->{response} = shift;
	$self->{status} =0;
	$self->{content_type} = "text/html";
	my @cookies;
	$self->{cookies} = \@cookies;

	return $self;
}

sub send {
	my $self = shift;
   
	my $out;
	if (!$self->{redirect}) {
		$out .= $self->{out};
	}	
	foreach my $cookie (@{$self->{cookies}}) {
		$self->{response}->push_header('Set-Cookie'=>$cookie)
	}	
	$self->{response}->content_type($self->{content_type});
    $self->{response}->content($out);
	
}


1;
