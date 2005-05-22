package Alpaka::Application;

use strict;

use Alpaka::Response::ModPerl2;
use Alpaka::Request::ModPerl2;

use Alpaka::Response::CGI;
use Alpaka::Request::CGI;

use Alpaka::Session::File;

use Data::Dumper;
our $DEBUG = 1;
our $VERSION = '0.62';


sub modperl2 : method {
    my($class, $r) = @_;
    
    my $self = $class->instance;
    $self->request( Alpaka::Request::ModPerl2->new( $r ) );
    $self->response( Alpaka::Response::ModPerl2->new( $r ) );
    $self->_handle;
 
    return Apache::OK;
}

sub modperl1 ($$) {
    my($class, $r) = @_;
    
    my $self = $class->instance;
    #$self->request( Alpaka::Request::ModPerl1->new( $r ) );
    #$self->response( Alpaka::Response::ModPerl1->new( $r ) );
    $self->_handle;
}

sub cgi {
    my($class) = @_;
    
    my $self = $class->instance;
    $self->request( Alpaka::Request::CGI->new );
    $self->response( Alpaka::Response::CGI->new );
    $self->_handle;
}

sub _handle {
    my($self, $type) = @_;
    
    $self->session( Alpaka::Session::File->new( $self ) );
    $self->session->init( $self ) if $self->{session_support};

    $self->execute( $self->request->compo, $self->request->action );
    $self->session->save if $self->{session_support};
    $self->response->send;
}


sub instance {
    my $class = shift;

    # get a reference to the _instance variable in the $class package 
    no strict 'refs';
    my $instance = \${ "$class\::_instance" };

    defined $$instance
	? $$instance
	: ($$instance = $class->_new_instance(@_));
}

sub _new_instance {
	my $class = shift;
	my @args = @_;

	# Create our object!
	my $self = {};
	bless($self, $class);

	#defaults
	$self->{session_support} = 1;
	$self->{base_path} = '/';
	
	$self->setup();
	$self->_load_components;
    
	return $self;
}

sub execute {
	my ($self, $compo, $action) = @_;

    $self->begin($self->request, $self->response, $self->session, $self);
    $self->_execute($compo, $action);
    $self->end($self->request, $self->response, $self->session, $self);
    #$self->dump_objects() if $DEBUG;
}

sub _execute {
	my ($self, $compo, $action, $dispatcher ) = @_;
	
	$dispatcher ||= 'execute';
    my $component =  $self->{_map}->{$compo} || $compo;
	if ($component) {
    	eval {
    	   $component->instance($self)->$dispatcher( $action );
    	};
    	if ($@) {
    	   #$self->response->clear(); # ?
    	   $self->response->write("<h1>Error executing $compo -> $action</h1>");
    	   $self->response->write("<pre>$@</pre>") if $DEBUG;
    	}
	}
	else {
	   $self->response->write("<h1>Component Not Found</h1>");
	}
}
	
sub forward {
	my ($self, $compo, $action) = @_;

    $self->_execute($compo, $action, 'forward')
}

sub setup {
	my $self = shift;
    
	$self->map( '_default'  =>  'Alpaka::Index' );
}

sub reload {
	$_[0]->_load_components;
}

sub cleanup {
	my $self = shift;
}

sub response {
	my ($self, $response) = @_;
	
	$self->{response} = $response if defined $response;
	return $self->{response};
}

sub request {
	my ($self, $request) = @_;
	
	$self->{request} = $request if defined $request;
	return $self->{request};
}

sub session {
	my ($self, $session) = @_;
	
	$self->{session} = $session if defined $session;
	return $self->{session};
}

sub session_support {
	my ($self, $value) = @_;
	
	$self->{session_support}=$value if defined $value;
	return $self->{session_support};
}

sub base_path {
	my ($self, $value) = @_;
	
	$self->{base_path}=$value if defined $value;
	return $self->{base_path};
}

sub app_name {
	my ($self, $value) = @_;
	
	$self->{app_name}=$value if defined $value;
	return $self->{app_name};
}

sub begin { 
	my ($self, $request, $response, $session) = @_;
	
    return;
}

sub end { 
	my ($self, $request, $response, $session) = @_;

    return;
}

sub index {  #hmmm, sacar y poner default component? hmmm, psee...
	my ($self, $request, $response, $session) = @_;
	
    return;
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

sub _load_components {
    my $self = shift;
 
    # do not load if already loaded (how?)
    foreach my $package ( values %{ $self->{_map} } ) {
        eval "require $package";
        # alert if missing packages ?
    }
}
sub dump_objects {
    my $self = shift;
    
    $self->response->write( '<h1>Request :</h1>' );
    $self->response->write( '<pre>' );
    $self->response->write( $self->request->as_string );
    $self->response->write( '</pre>' );

    $self->response->write( '<h1>Session :</h1>' );
    $self->response->write( '<pre>' );
    $self->response->write( $self->session->as_string );
    $self->response->write( '</pre>' );
}

1;
