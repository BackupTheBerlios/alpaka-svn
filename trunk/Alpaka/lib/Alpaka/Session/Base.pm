package Alpaka::Session::Base;

use strict;

use Digest::MD5 qw(md5_hex);
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	
	$self->{app} = shift;
	$self->{request} = $self->{app}->request;
	$self->{response} = $self->{app}->response;
	$self->{modified} = 0;
	$self->{data} = {};

	return $self;
}


sub init {
    my ($self, $app) = @_;
    
    my $cookie = $self->{request}->get_cookie('SESSION');
    $self->{id} = $cookie->{value} if $cookie;
    
    if ($self->{id}) {
        $self->load();
    }
    else {
        $self->{id} = $self->_generate_id;   
        $self->{response}->set_cookie( 
            {
                name    => 'SESSION',
                value   => $self->{id},
                path    => '/',
                secure  => 0
            }
        );  
    }
}

sub _generate_id {
	my ($self) = @_;
	return substr(md5_hex(time() . md5_hex(time(). {}. rand(). $$)), 0, 16);
}

sub id {
	my ($self) = @_;
	return $self->{id};
}


sub data {
	my ($self, $data) = @_;
	
	if (defined $data) {
	   $self->{data} = $data;
	}
	return $self->{data};
}

sub close() {
	my ($self) = @_;
	
    $self->{data} = {};
	#unlink session file
	
    $self->{response}->set_cookie( 
        {
            name    => 'SESSION',
            expires => 'now',
            value   => $self->{id},
            path    => '/',
            secure  => 0
        }
    );
    $self->{id} = undef;
}


sub is_new() {
	my ($self) = @_;
	return $self->{_new};
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


sub load {
	my ($self) = @_;

	return;
} 


sub save {
	my ($self) = @_;

    return;
}

sub as_string {
	my ($self) = @_;
    
    return Dumper($self->data)
}

1;
