package Examples::Example1;

use base 'Alpaka::Component';
use strict;
use Error qw(:try);

sub hello_world { 
	my ($self, $request, $response, $session) = @_;

	$response->write("<h1>Hello World!!!</h1>");
	$response->write("<h2>Sample Action on Example1 Component</h2>");
	my $nro = $session->get('nro');
	$nro++;
	$session->set('nro',$nro);
	$response->write("<h3>$nro</h3>");
	
	$response->write($request->as_string);

}

sub default {
	my ($self, $request, $response, $session) = @_;
	$response->write("<h1>Example #1</h1>");
	$response->write("<ul>");
	$response->write("<li><a href=\"example1/hello_world\">Hello World</a>");
	
	$response->write("</ul>");

}	

1;
