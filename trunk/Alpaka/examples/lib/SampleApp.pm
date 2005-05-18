package SampleApp;
use strict;
  
use base 'Alpaka::Application';
  
  
sub setup {
    my $self = shift;

    $self->session_support(1); 
    $self->base_path('/example'); 
    
	$self->map( 
        '_default'  =>  'SampleApp::Index', 	    
        'example1'  =>  'SampleApp::Example1', 	
	);
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
