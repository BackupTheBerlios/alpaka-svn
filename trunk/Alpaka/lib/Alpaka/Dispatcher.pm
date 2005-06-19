package Alpaka::Dispatcher;

use strict; 
use Data::Dumper;
use attributes;

=head1 NAME

Alpaka::Dispatcher

=head1 SYNOPSIS

    Dispatcher base class
    
    package MyDispatcher;
    use base 'Alpaka::Dispatcher';

    sub my_action : action { ... };
    
=cut

=head1 DESCRIPTION
    
=cut

#------------------------------
# Constants
#------------------------------

#transform to constant
our %_bad_names = qw( 
    execute 1 forward 1 begin 1 end 1 app 1 MODIFY_CODE_ATTRIBUTES 1 FETCH_CODE_ATTRIBUTES 1
);

#------------------------------
# Class Methods
#------------------------------

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

sub _actions {
    my $obclass = shift;	
    my $class   = ref($obclass) || $obclass;
    my $varname = $class . "::_actions";
    no strict "refs"; 	# to access package data symbolically
    $$varname = shift if @_;
    return \%$varname;
}  

=item instance

    A Dispatcher is a Sinlgeton class, you can get an instance of
    the dispatcher anytime with this method. Should be rarely used
    because the current dispatcher object is always passed to
    every action as parameter.

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
	my $self = {};
	bless($self, $class);
	$self->{_app} = shift;	
	return $self;
}

#------------------------------
# Instance Methods
#------------------------------

=item app

    Get th application object.

=cut

sub app {
	my ($self, $app) = @_;
	
	$self->{_app} = $app if $app;
	return $self->{_app};
}
  
sub execute { 
	my ($self, $action) = @_;

    $action = 'index' unless $action;
    my $app = $self->app;
	$self->begin($app->request, $app->response, $app->session, $app);
	if ($action) {
        $self->_execute($action);
	}
	else {
		$self->index($app->request, $app->response, $app->session, $app);
	}
	$self->end($app->request, $app->response, $app->session, $app);
}

sub _execute { 
	my ($self, $action) = @_;
    my $app = $self->app;

    if ( attributes::get( $self->can( $action ) ) && !$_bad_names{$action} && !($action =~ m/^_/) ) {
        $self->$action($app->request, $app->response, $app->session, $app);
	}
	else {
	   $app->response->write("<h1>Action Not Found</h1>");
	}
}

=item forward

    $self->forward($action);
    
    Forward the control to other action insede the same dispatcher.
    To do a global (between other dispatcher) forward you should use
    the forward method from the application class.

=cut

sub forward {
	my ($self, $action) = @_;

    $self->_execute($action);
}

#------------------------------
# Override Instance Methods
#------------------------------

=item index

    Default action for the dispatcher. Should be overrided.

=cut

sub index : action { 
	my ($self, $request, $response, $session) = @_;
	
    return;
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