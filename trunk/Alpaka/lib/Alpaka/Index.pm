package Alpaka::Index;
use strict;
  
use base 'Alpaka::Dispatcher';

sub index : action {
    my ($self, $request, $response) = @_;
    
    $response->write("<h1>Wellcome to Alpaka web Framework</h1>");  
}

1;
