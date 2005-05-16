package SampleApp;
use strict;
  
use base 'Alpaka::Application';
  
  
sub setup {
    my $self = shift;

    $self->session_support(1); 
    $self->base_path('/example'); 
    
	$self->map( 
	  	'example1'  =>  'SampleApp::Example1', 	
	);
}

sub index {
    my ($self, $request, $response, $session, $app) = @_;
    
    my $count = $session->get('count') || 0;
    $response->write("<h1>Sample Application ($count)</h1>");
    my $base = $app->base_path;
    $response->write("<h3><a href=\"$base/example1/example1.do\">Example 1</a></h3>");
    $count++;
    $session->set('count' => $count);
    
}

sub header { 
	my ($self, $request, $response, $session) = @_;
	
	$response->write("<html>");
	$response->write("<head><title>Sample Application</title></head>");
	$response->write("<body>");
	$self->response->write("<h4>".$request->compo."->".$request->action."</h4>");

}

sub footer { 
	my ($self, $request, $response, $session) = @_;

    $response->write("</body>");
    $response->write("</html>");
}
1;
