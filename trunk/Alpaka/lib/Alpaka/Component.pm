package Alpaka::Component;

use strict; 
use Alpaka::Error::Component;
use Alpaka::Error::ActionNotFound;
sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	$self->{_application} = shift;	
	return $self;
}

sub application {
	my ($self, $application) = @_;
	
	$self->{_application}=$application if $application;
	return $self->{_application};
}
  
sub execute { 
	my ($self, $request, $response, $session) = @_;
	my $action_key = $request->action_key;
	$self->header($request, $response, $session);
	if ($action_key) {
		if ($self->can($action_key) && $action_key ne "execute" && $action_key ne "new"  && $action_key ne "application" && !($action_key =~ m/^_/)) {
				$self->$action_key($request, $response, $session);
		}
		else {
			throw Alpaka::Error::ActionNotFound( -text=>"action: $action_key");
		}
	}
	else {
		$self->default($request, $response, $session);
	}
	$self->footer($request, $response, $session);
}

sub default { 
	my ($self, $request, $response, $session) = @_;
	

}

sub header { 
	my ($self, $request, $response, $session) = @_;
	

}

sub footer { 
	my ($self, $request, $response, $session) = @_;

}

1;
