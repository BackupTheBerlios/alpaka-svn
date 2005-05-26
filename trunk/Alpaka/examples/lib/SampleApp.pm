package SampleApp;
use strict;
  
use base 'Alpaka::Application';
  
sub init {
    my $self = shift;

    $self->config( sessions => 1);
        
	$self->map( 
        '_default'  =>  'SampleApp::Index',    
        'example1'  =>  'SampleApp::Example1',
	);
	
	$self->set('message' => 'Hello World! This message is global data!');
}

sub begin { 
	my ($self, $request, $response, $session, $app) = @_;
	
	$response->write("<html>");
	$response->write("<head><title>Sample Application</title></head>");
	$response->write("<body style=\"margin-left: 10\%\">");
	$response->write('<img src="/examples/html/alpaka-logo.gif" name="logo" align="bottom" width="324" height="86" border="0">');
	

}

sub end { 
	my ($self, $request, $response, $session, $app) = @_;
    
    $response->write("<pre>");
    $response->write("Application path : " . $app->path . "\n");
    $response->write("Dispatcher       : " . $request->dispatcher . "\n");
    $response->write("Action           : " . $request->action . "\n");
    $response->write("</pre>");
    $response->write("</body>");
    $response->write("</html>");
}
1;
