package Alpaka::Request::Factory;
# the request Factory

use Alpaka::Request::CGI; 
#use Alpaka::Request::ModPerl; 
#use Alpaka::Request::ModPerl2; 
use Alpaka::Request::Alpaka; 
  
sub create_request {
    my $self = shift;
	my $http_request = shift;
    
	return Alpaka::Request::Alpaka->new($http_request) if $http_request;
    return Alpaka::Request::CGI->new; # if CGI
	#return Alpaka::Request::ModPerl->new; # if MODPERL
	#return Alpaka::Request::ModPerl2->new; # if MODPERL2
	#return Alpaka::Request::Alpaka->new; # if ALPAKA
	
  }


1;
