package SampleApp::Index;
use strict;
  
use base 'Alpaka::Component';


sub index : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    my $count = $session->get('count') || 0;
    $response->write("<h1>Sample Application ($count)</h1>");
    my $base = $app->base_path;
    $response->write("<h3><a href=\"$base/example1/example1.do\">Example 1</a></h3>");
    $count++;
    $session->set('count' => $count);  
}


1;
