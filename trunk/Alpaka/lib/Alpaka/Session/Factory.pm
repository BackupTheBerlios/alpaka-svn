package Alpaka::Session::Factory;
# the request Factory

use Alpaka::Session::File; 

  
sub create_session {
    my $self = shift;
    
    return Alpaka::Session::File->new(shift); 
	
  }


1;
