package SampleApp::Example1;
use strict;
  
use base 'Alpaka::Component';
our $_actions = {};

sub example1 : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    my $count = $session->get('count') || 0;
    $response->write("<h1>Example No.1 ($count)</h1>");
    $count++;
    $session->set('count' => $count);
    
}


sub index : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $self->forward('example1');
        
}


sub redirect {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->redirect( $app->base_path . "/example1.do");
    
}

sub header { 
	my ($self, $request, $response, $session, $app) = @_;
	
	$response->write("<table bgcolor=\"#aaaaee\"><tr><td>");
	

}

sub footer { 
	my ($self, $request, $response, $session, $app) = @_;
	
	$response->write("</td></tr></table>");
}


1;
