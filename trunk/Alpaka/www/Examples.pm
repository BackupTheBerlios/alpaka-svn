package Examples;

use base 'Alpaka::Application';
use strict;
  
sub setup {
	my $self = shift;
	 
	$self->map( 
		'DEFAULT'=> 'Examples::Index',
	  	'example1'=> 'Examples::Example1',  	
	  	
	);
	
	$self->debug(1);
}

1;
