package SampleApp::Example1;
use strict;
  
use base 'Alpaka::Component';
our $_actions = {};

sub index : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    my $count = $session->get('count') || 0;
    $response->write("<h1>Sample Actions</h1>");
    $response->write('<h3><a href="hello_world.do">Hello World</a></h3>');
    $response->write('<h3><a href="counter.do">Counter</a></h3>');
    $response->write('<h3><a href="hello_world.do">Redirect</a></h3>');
    $response->write('<h3><a href="forwarding.do">Forward</a></h3>');
    $count++;
    $session->set('count' => $count);
        
}

sub hello_world : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->write("<h1>Hello World</h1>");
    $response->write('<a href="../">back</a></h3>');
  
}

sub counter : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    my $count = $session->get('count') || 0;
    
    $response->write("<h1>Count: $count</h1>");
    $response->write('<a href="counter.do">reload</a><br>');
    $response->write('<a href="../">back</a></h3>');
    
    $count++;
    $session->set('count' => $count);  
}

sub redirect : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->redirect( $app->base_path . "hello_world.do");
    
}

sub forwarding : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $self->forward("hello_world");
    
}

sub begin { 
	my ($self, $request, $response, $session, $app) = @_;
	
	$response->write("<table bgcolor=\"#aaaaee\" border=\"1\"><tr><td>");
	

}

sub end { 
	my ($self, $request, $response, $session, $app) = @_;
	
	$response->write("</td></tr></table>");
}


1;
