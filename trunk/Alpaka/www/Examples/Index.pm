package Examples::Index;

use base 'Alpaka::Component';
use strict;

sub default {
	my ($self, $request, $response, $session) = @_;
	
	$response->write("<ul>");
	$response->write("<li><a href=\"examples/example1\">Example #1</a>");
	
	$response->write("</ul>");

}	

1;
