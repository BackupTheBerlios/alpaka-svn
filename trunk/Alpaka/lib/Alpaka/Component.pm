package Alpaka::Component;

use strict; 
use Data::Dumper;
use attributes;

sub _actions {
    my $obclass = shift;	
    my $class   = ref($obclass) || $obclass;
    my $varname = $class . "::_actions";
    no strict "refs"; 	# to access package data symbolically
    $$varname = shift if @_;
    return \%$varname;
}  

sub MODIFY_CODE_ATTRIBUTES {
    my ( $class, $code, $attr ) = @_;
    my $actions = $class->_actions;
    $actions->{ $code } = 1 if ( $attr eq 'action' );
    return ();
}

sub FETCH_CODE_ATTRIBUTES {
    my ( $class, $code ) = @_;
    my $actions = $class->_actions;
    return $actions->{ $code } ;
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
	my $self = {};
	bless($self, $class);
	$self->{_app} = shift;	
	return $self;
}

sub app {
	my ($self, $app) = @_;
	
	$self->{_app} = $app if $app;
	return $self->{_app};
}
  
sub execute { 
	my ($self, $action) = @_;

    $action = 'index' unless $action;
    my $app = $self->app;
	$self->header($app->request, $app->response, $app->session, $app);
	if ($action) {
        if ( attributes::get( $self->can( $action ) ) ) {
				$self->$action($app->request, $app->response, $app->session, $app);
		}
		else {
		  $app->response->write("<h1>Action Not Found</h1>");
		}
	}
	else {
		$self->index($app->request, $app->response, $app->session, $app);
	}
	$self->footer($app->request, $app->response, $app->session, $app);
}

sub forward {
	my ($self, $action) = @_;

    $self->execute($action);
}

sub index : action { 
	my ($self, $request, $response, $session) = @_;
	
    return;
}

sub header { 
	my ($self, $request, $response, $session) = @_;
	
    return;
}

sub footer { 
	my ($self, $request, $response, $session) = @_;

    return;
}

1;
