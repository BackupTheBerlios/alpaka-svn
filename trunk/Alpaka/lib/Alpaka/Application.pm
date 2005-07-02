package Alpaka::Application;

use strict;

use Alpaka::Session::File;
use Data::Dumper;

our $DEBUG = 1;
our $VERSION = '0.62';

=head1 NAME

Alpaka::Application

=head1 SYNOPSIS

    Application base class
    
    package SampleApp;
    use base 'Alpaka::Application';

    sub init {
        my $self = shift;
        
    	$self->map( 
            '_default'  =>  'SampleApp::Index',    
            'example1'  =>  'SampleApp::Example1',
    	);
    }
    
=cut

=head1 DESCRIPTION
    
=cut

BEGIN {
    my ( $software, $version ) = $ENV{MOD_PERL} =~ /^(\S+)\/(\d+(?:[\.\_]\d+)+)/;
    
    if ( $software eq 'mod_perl') {
        if ( $version >= 1.99 ) {
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

=over 4

=item mp2_handler

    Handler to run the application under the ModPerl2 environment.

=cut

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

=item mp1_handler

    Handler to run the application under the ModPerl1 environment.

=cut


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

=item cgi_handler

    Handler to run the application under the CGI environment.

=cut

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

=item instance

    An Application is a Sinlgeton class, you can get an instance of
    the application anytime with this method. Should be rarely used
    because the application object is always passed to every action.

=cut

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
    
    $self->cleanup;
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

=item forward

    $self->forward($dispacher, $action);
    Forward the application control to other action.

=cut

sub forward {
	my ($self, $dispatcher, $action) = @_;

    $self->_execute($dispatcher, $action, 'forward')
}

sub reload {
	$_[0]->_load_dispatchers;
}

=item response

    $self->response;
    $self->response($response);
    
    Get/set the response object.

=cut

sub response {
	my ($self, $response) = @_;
	
	$self->{response} = $response if defined $response;
	return $self->{response};
}

=item request

    $self->request;
    $self->request($request);
    
    Get/set the request object.

=cut

sub request {
	my ($self, $request) = @_;
	
	$self->{request} = $request if defined $request;
	return $self->{request};
}

=item session

    $self->session;
    $self->session($session);
    
    Get/set the session object.

=cut

sub session {
	my ($self, $session) = @_;
	
	$self->{session} = $session if defined $session;
	return $self->{session};
}

=item path

    $app->path;
    
    Return the base path to the application. Util to build absolute
    html links:
    
    my $link = $app->path . "/example1/hello_world.do"

=cut

sub path {
	my ($self, $value) = @_;

	return $self->{path};
}

=item map

    $self->map(%dispatchers);
    
    Get/set the dispatchers mappings.

=cut

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

=item config

    $self->config(%config);
    
    Get/set application configuration parameters. I.e:
    $self->config( sessions => 1 ); 
    #activates session support (default)

=cut


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

=item get

    $self->get('key');
    
    Get globals (application) objects.

=cut

sub get {
	my ($self, $key) = @_;
	return $self->{data}->{$key};
}

=item set

    $self->set('key' => $value);
    
    Set globals (application) objects.

=cut

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

=item slot

    $self->slot('plugin_name');
    
    Gets a slot corresponding to the specified plugin. 
    (used in plugin development)

=cut

sub slot {
    my ($self, $key) = @_;
    
    $self->{plugins}->{$key} = {} unless ( exists $self->{plugins}->{$key} );
	return $self->{plugins}->{$key};
}

#------------------------------
# Override Instance Methods
#------------------------------

=item init

    sub init {
        my $self = shift;
        
    	$self->map( 
            '_default'  =>  'SampleApp::Index',    
            'example1'  =>  'SampleApp::Example1',
    	);
    }

    This method should be overrided to do the proper application
    initialization.

=cut

sub init {
	my $self = shift;
    
	$self->map( '_default'  =>  'Alpaka::Index' );
}

=item init

    sub cleanup {
        my $self = shift;
        
        $self->dbh->disconnect;
    }

    This method should be overrided to do the proper application
    cleanup, i.e: disconnect the db handler, etc.

=cut

sub cleanup {
	my $self = shift;
}

=item begin

    This method is called before action execution. You can override 
    this method to do common heading stuffs, etc.

=cut

sub begin { 
	my ($self, $request, $response, $session) = @_;
	
    return;
}

=item end

    This method is called after action execution. You can override
    this method to do common footer stuffs, etc.

=cut

sub end { 
	my ($self, $request, $response, $session) = @_;

    return;
}

1;