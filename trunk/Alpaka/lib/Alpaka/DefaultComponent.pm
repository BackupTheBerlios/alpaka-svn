package Alpaka::DefaultComponent;

use strict; 
use base 'Alpaka::Component';


sub default { 
	my ($self, $request, $response, $session) = @_;
		
		$response->write("<h1>Welcome to Alpaka</h1>");

}

1;
