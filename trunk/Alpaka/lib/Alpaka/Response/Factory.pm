package Alpaka::Response::Factory;
# the response Factory

use Alpaka::Response::CGI; 
#use Alpaka::Request::ModPerl; 
#use Alpaka::Request::ModPerl2; 
use Alpaka::Response::Alpaka; 
  
sub create_response {
    my $self = shift;
	my $http_response = shift;
    
	return Alpaka::Response::Alpaka->new($http_response) if $http_response;
  	return Alpaka::Response::CGI->new; # if CGI
	#return Alpaka::Response::ModPerl->new; # if MODPERL
	#return Alpaka::Response::ModPerl2->new; # if MODPERL2
	
	
}


1;
