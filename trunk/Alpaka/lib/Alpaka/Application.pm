package Alpaka::Application;

use strict;

use CGI qw( cgi ); 
use Alpaka::Response::Factory;
use Alpaka::Session::Factory;
use CGI::Carp qw(set_message);
use CGI::Cookie;
use Error qw(:try);
use Alpaka::Error::Component;
use Alpaka::Error::ComponentNotFound;
use Alpaka::Error::Unsupported;
use Alpaka::Default;


$WebApp::DEBUG=1;

sub new {
	my $class = shift;
	my @args = @_;

	# Create our object!
	my $self = {};
	bless($self, $class);

	if ($WebApp::DEBUG){
		CGI::Carp->import('fatalsToBrowser');
	}

	#defaults
	$self->{_auto_session}=1;
	
	$self->setup();

	return $self;
}


sub debug {
	my ($self, $debug) = @_;
	
	$WebApp::DEBUG=$debug if $debug;
	return $WebApp::DEBUG;
}

sub setup {
	my $self = shift;

	$self->map( 
	  	'DEFAULT'=> 'Alpaka::DefaultComponent', 	
	);
	
}

sub init {
	my $self = shift;
}

sub cleanup {
	my $self = shift;
}

sub auto_session {
	my ($self, $auto_session) = @_;
	
	$self->{_auto_session}=$auto_session if $auto_session;
	return $self->{_auto_session};
}

sub response {
	my ($self, $response) = @_;
	
	$self->{_response}=$response if $response;
	return $self->{_response};
}


sub request {
	my ($self, $request) = @_;
	
	$self->{_request}=$request if $request;
	return $self->{_request};
}

sub session {
	my ($self, $session) = @_;
	
	$self->{_session}=$session if $session;
	return $self->{_session};
}



sub set {
	my ($self, $key, $value) = @_;
	
	$self->{$key} = $value;
}

sub get {
	my ($self, $key) = @_;
	
	return $self->{$key};
}


sub execute { 
	my ($self) = @_;

	my $response = $self->response();
	my $request = $self->request();

	my $session = $self->session();
	if (!$session){
		$session = $self->session(Alpaka::Session::Factory->create_session($request));
		$session->init() if $self->{_auto_session};
	}
	
	$self->init(); #?

	$self->request->component_key('DEFAULT') if (!$self->request->component_key());
	my $component_key = $self->request->component_key();
	$component_key = 'default' if (!$component_key);
	if (exists($self->{_map}->{$component_key})) {
		$self->_process_component();
	}
	else {
		#algun tipo de autoload?
		throw Alpaka::Error::ComponentNotFound('-text'=>"component: $component_key");
	}

	$response->set_cookie("SESSION",$session->id()) if ($session->is_new());
	$session->save();
	
	# clean up operations
	$self->cleanup();
	return $response;
}

sub map {
	my $self = shift;

	# First use?  Create new _map
	$self->{_map} = {} unless (exists($self->{_map}));
	my $rr_m = $self->{_map};
	# If data is provided, set it!
	if (scalar(@_)) {
		# Is it a hash, or hash-ref?
		if (ref($_[0]) eq 'HASH') {
			# Make a copy, which augments the existing contents (if any)
			%$rr_m = (%$rr_m, %{$_[0]});
		} elsif ((scalar(@_) % 2) == 0) {
			# It appears to be a possible hash (even # of elements)
			%$rr_m = (%$rr_m, @_); # ok
		} else {
			croak("Odd number of elements passed to map().  Not a valid hash");
		}
	}
}

sub _process_component {
	my ($self) = @_;

	my $component_key = $self->request->component_key();
	my $component = $self->{_map}->{$component_key};
	#$component = "Alpaka::Default";
#$self->_process_class_name($component);

	if ( ref($component) && $component->isa('Alpaka::Component')) { # es un obj de clase Component
	#if ( 0) { # es un obj de clase Component
		$self->_process_object($component);
	}
	#elsif ( $component=~m/^[A-Z].*/) { # es una nombre de clase
	elsif ( $component=~m/^[A-Z]*/) { # es una nombre de clase
	#elsif (1) { # es una nombre de clase
		$self->_process_class_name($component);
	}
	else { 
		throw Alpaka::Error::Unsupported ("Mapping not supported, on '$component_key'");
	}
}


sub _process_object {
	my ($self, $component) = @_;

	my $component_key = $self->request->component_key();
	$component->application($self);
	my $obj = $component;
	

	
	$obj->execute($self->request, $self->response, $self->session);
 
	
}

sub _process_class_name {
	my ($self, $component) = @_;

	my $component_key = $self->request->component_key();

	eval ("require $component;");
	my $object = ${component}->new($self);

	if ($object->isa('Alpaka::Component')) {
		$self->_process_object($object);
	}
	else { 
		throw Alpaka::Error::Unsupported ("Mapping not supported, on '$component_key'");
	}
}


BEGIN {
	sub handle_errors {
		my $message = shift;
		require Alpaka::Error;
		throw Alpaka::Error ('-text' => $message);
	}

	set_message(\&handle_errors);
}

1;
