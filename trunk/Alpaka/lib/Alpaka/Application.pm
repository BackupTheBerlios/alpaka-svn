package Alpaka::Application;

use strict;

use Alpaka::Session::File;
use Data::Dumper;

our $DEBUG = 1;
our $VERSION = '0.62';

BEGIN {
    my ( $software, $version ) = $ENV{MOD_PERL} =~ /^(\S+)\/(\d+(?:[\.\_]\d+)+)/;
    
    if ( $software eq 'mod_perl') {
        if ( $version >= 1.999 ) {
            require Alpaka::Response::ModPerl2;
            require Alpaka::Request::ModPerl2;
        }
        elsif ( $version >= 1.13 ) {
            require Alpaka::Response::ModPerl1;
            require Alpaka::Request::ModPerl1;
        }
    }
    else {
        require Alpaka::Response::CGI;
        require Alpaka::Request::CGI
    }
}

#------------------------------
# Handlers
#------------------------------

sub mp2_handler : method {
    my($class, $r) = @_;
    
    my $self = $class->instance;
    $self->request( Alpaka::Request::ModPerl2->new( $r ) );
    $self->response( Alpaka::Response::ModPerl2->new( $r ) );
    (undef, $self->{path}) = split '/', $self->request->r->uri;
    $self->{path} = '/' . $self->{path}; 
    $self->_handle;
 
    return Alpaka::Response::ModPerl2::OK();
}

sub mp1_handler ($$) {
    my($class, $r) = @_;
    
    my $self = $class->instance;
    $self->request( Alpaka::Request::ModPerl1->new( $r ) );
    $self->response( Alpaka::Response::ModPerl1->new( $r ) );
    (undef, $self->{path}) = split '/', $self->request->r->uri;
    $self->{path} = '/' . $self->{path}; 
    $self->_handle;

    return Alpaka::Response::ModPerl1::OK();
}

sub cgi_handler {
    my($class) = @_;
    
    my $self = $class->instance;
    $self->request( Alpaka::Request::CGI->new );
    $self->response( Alpaka::Response::CGI->new );
    $self->{path} = $self->request->r->script_name;
    $self->_handle;
}

#------------------------------
# Class Methods
#------------------------------

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
	$self->{config}->{sessions} = 1;
	$self->{data} = {};
	$self->{plugins} = {};
	$self->init();
	$self->_load_dispatchers;
    
	return $self;
}

#------------------------------
# Instance Methods
#------------------------------

sub _handle {
    my($self, $type) = @_;
    
    $self->session( Alpaka::Session::File->new( $self ) );
    $self->session->init( $self ) if $self->{config}->{sessions};

    $self->execute( $self->request->dispatcher, $self->request->action );
    $self->session->save if $self->{config}->{sessions};
    $self->response->send;
}

sub execute {
	my ($self, $dispatcher, $action) = @_;

    $self->begin($self->request, $self->response, $self->session, $self);
    $self->_execute($dispatcher, $action);
    $self->end($self->request, $self->response, $self->session, $self);
    #$self->dump_objects() if $DEBUG;
}

sub _execute {
	my ($self, $dispatcher, $action, $type ) = @_;
	
	$type ||= 'execute';
    my $dispatcher_class = $self->{_map}->{$dispatcher} || $dispatcher;
	if ($dispatcher_class) {
    	eval {
    	   $dispatcher_class->instance($self)->$type( $action );
    	};
    	if ($@) {
    	   #$self->response->clear(); # ?
    	   $self->response->write("<h1>Error executing $dispatcher -> $action</h1>");
    	   $self->response->write("<pre>$@</pre>") if $DEBUG;
    	}
	}
	else {
	   $self->response->write("<h1>Dispatcher Not Found</h1>");
	}
}
	
sub forward {
	my ($self, $dispatcher, $action) = @_;

    $self->_execute($dispatcher, $action, 'forward')
}

sub reload {
	$_[0]->_load_dispatchers;
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

sub path {
	my ($self, $value) = @_;

	return $self->{path};
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

sub _load_dispatchers {
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

sub config {
	my $self = shift;

	# First use?  Create new _map
	$self->{config} = {} unless (exists($self->{config}));
	my $rr_m = $self->{config};
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
			croak("Odd number of elements passed to config().  Not a valid hash");
		}
	}
	return $self->{config};
}

sub get {
	my ($self, $key) = @_;
	return $self->{data}->{$key};
}


sub set {
	my ($self, $key, $value) = @_;
	
	if ( defined $value ) {
	   $self->{data}->{$key} = $value;
	   $self->{modified} = 1;
    };
	return $self->{data}->{$key};
}

sub data {
	return $_[0]->{data};
}

sub plugins {
	return $_[0]->{plugins};
}

#------------------------------
# Override Instance Methods
#------------------------------

sub init {
	my $self = shift;
    
	$self->map( '_default'  =>  'Alpaka::Index' );
}

sub cleanup {
	my $self = shift;
}

sub begin { 
	my ($self, $request, $response, $session) = @_;
	
    return;
}

sub end { 
	my ($self, $request, $response, $session) = @_;

    return;
}

1;