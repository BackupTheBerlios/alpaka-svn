package SampleApp::Example1;
use strict;
  
use base 'Alpaka::Component';
our $_actions = {};

sub index : action {
    my ($self, $request, $response, $session, $app) = @_;
    $response->write("<h2>App Path : " . $app->path. "</h2>");
    
    $response->write("<h1>Sample Actions</h1>");
    $response->write('<h3><a href="example1/hello_world.do">Hello World</a></h3>');
    $response->write('<h3><a href="example1/counter.do">Counter</a></h3>');
    $response->write('<h3><a href="example1/redirect.do">Redirect</a></h3>');
    $response->write('<h3><a href="example1/forwarding.do">Forward</a></h3>');
    $response->write('<h3><a href="example1/request.do">Request</a></h3>');
        
}

sub hello_world : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->write("<h1>Hello World</h1>");
    $response->write('<a href="../">back</a></h3>');
  
}

sub counter : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $session->close if $request->get('reset');
    
    my $count = $session->get('count') || 0;
    
    $response->write("<h1>Count: $count</h1>");
    $response->write('<a href="counter.do">reload</a><br>');
    $response->write('<a href="counter.do?reset=1">reset</a><br>');
    $response->write('<a href="../">back</a></h3>');
    
    $count++;
    $session->set('count' => $count);  
}

sub redirect : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->redirect( $app->path . "/example1/hello_world.do");
    
}

sub forwarding : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $self->forward("hello_world");  
    
}

sub request : action {
    my ($self, $request, $response, $session, $app) = @_;
    
    $response->write('<ul>');
    $response->write('<li>Remote Host : ' . $request->remote_host);
    $response->write('<li>Remote Address : ' . $request->remote_address);
    $response->write('<li>Method : ' . $request->method);
    $response->write('<li>User : ' . $request->user);
    $response->write('<li>User Agent: ' . $request->user_agent);
    $response->write('<li>Referer: ' . $request->referer);
    $response->write('<li>Accept: ' . $request->accept);
    $response->write('<li>Accept Encoding: ' . $request->accept_encoding);
    
    $response->write('</ul>');
    $response->write('<a href="../">back</a></h3>');
    
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
