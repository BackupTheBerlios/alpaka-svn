package Alpaka::DefaultApplication;

use base 'Alpaka::Application';
use strict;
use Alpaka::Default;
  
sub setup {
	my $self = shift;
	 
	my $default = Alpaka::Default->new;
	$self->map( 
	  	'DEFAULT'=> $default
	);
	
	$self->debug(1);
}

1;
