package Alpaka;

use strict; 
use Alpaka::Request::Factory;
use Alpaka::Response::Factory;
use Error qw(:try);
use Alpaka::Error;
use Alpaka::Error::Application;
use Alpaka::Error::ApplicationNotFound;
use Alpaka::Error::Component;
use Alpaka::Error::ComponentNotFound;
use Alpaka::Error::ActionNotFound;
use Alpaka::Error::Validator;
use Alpaka::Error::Unsupported;

#use lib qw(../examples);
#use lib qw(../lib);
#use lib LIB_DIR;



our %classes;
our $VERSION = '0.60';

sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	
	my %applications;
	$self->{applications} =  \%applications;
	return $self;
}

sub run {
	my ($self, $http_request, $http_response) = @_;

	my $request = Alpaka::Request::Factory->create_request($http_request); 
	my $response = Alpaka::Response::Factory->create_response($http_response); 
	# y crear el request de alpaka (?) el request/response http debe ser igual/distinto(?) 
	# de request/response alpaka -> creo que no los de alpaka so wraper con otra api mas alto nivel (?)

	#create app
	my $application_key = $request->application_key;
	$application_key = 'DEFAULT' if (!$application_key);

	my $application;

	if (!defined($self->{applications}->{$application_key})) {
		my $class= $classes{$application_key};
		try {	
			$application =  ${class}->new();
			$self->{application}->{$application_key} = $application;
		}catch Error with {
    		my $ex = shift;   # Get hold of the exception object
			
			$response->write("<h1>Alpaka::Error Exception</h1><pre>$ex</pre>");
  		}
	}
	else {
		$application = $self->{applications}->{$application_key};
	}

	try {	
		$application->request($request);
		$application->response($response);
		$response = $application->execute();
	   }
	catch Alpaka::Error::Validator with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error::Unsupported with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error::ActionNotFound with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error::ComponentNotFound with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error::Component with {
	  	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}		
	catch Alpaka::Error::ApplicationNotFound with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error::Application with {
	  	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Alpaka::Error with {
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("$ex");
	}
	catch Error with {
		# estos son errores del sistema no mostrar si debug=0 
	   	my $ex = shift;   # Get hold of the exception object
		$response->write("<h1>Alpaka::Error Exception</h1><pre>$ex</pre>");
	}
	finally {
		$response->send();
	}; 
  	
}


BEGIN {
	use FindBin qw($Bin);
	use lib "$Bin/../lib";
	use lib "$Bin/../www";
	
	open (FILE, "$Bin/../conf/applications.alpaka") || die("error: $!\n");
	while (<FILE>) {
		chomp;
		my ($key, $value) = split /\s*=>\s*/, $_;
		$classes{$key} = $value;
	}
	close (FILE);	
	foreach my $class (values %classes){
		eval ("require $class;");
	}	
}

1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Alpaka - Perl MVC framework for web applications

=head1 SYNOPSIS

  use Alpaka;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Alpaka, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Pablo Daniel Cano<lt>canpaniel@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Pablo Daniel Cano

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

