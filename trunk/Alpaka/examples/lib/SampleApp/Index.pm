package SampleApp::Index;
use strict;
  
use base 'Alpaka::Component';


sub index : action {
    my ($self, $request, $response, $session, $app) = @_;
   
    $response->redirect($app->path . "/example1");
    
}


1;
