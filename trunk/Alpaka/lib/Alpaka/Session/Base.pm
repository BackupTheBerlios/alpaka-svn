package Alpaka::Session::Base;

use strict;

use Apache::Cookie;
use Digest::MD5 qw(md5_hex);


sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	
	$self->{r} = shift; 
	$self->{_new} = 0; # cambiar new a _send_cookie
	$self->{modified} = 0;
	#mover session data to $self->{data}

	return $self;
}


sub init {
    my ($self, $app) = @_;
    
    my $cookie = Apache::Cookie->fetch->{SESSION};
    my $session_id = $cookie->value if $cookie;
    if ($session_id) {
        $self->{id} = $session_id;
        $self->load();
        $self->{_new} = 0;
    }
    else {
        $self->{id} = $self->_generate_id;
        my $cookie = Apache::Cookie->new($self->{r},
            -name    =>  'SESSION',
            -path    =>  $app->base_path,
            -value   =>  $self->{id},
            -expires =>  '+1Y',
        );
        $cookie->bake;
        $self->{_new} = 1;
    }
}

sub _generate_id {
	my ($self) = @_;
	return substr(md5_hex(time() . md5_hex(time(). {}. rand(). $$)), 0, 16);
}

sub id() {
	my ($self) = @_;
	return $self->{id};
}


sub close() {
	my ($self) = @_;
	
	foreach my $key (keys %$self){
		delete $self->{$key} unless ($key=~m/^_/) ;
	}
	#unlink session file
    $self->{id} = undef;
    my $cookie = Apache::Cookie->new($self->{r},
        -name    =>  'SESSION',
        -value   =>  $self->{id},
    );
    $cookie->bake;
    $self->{_new} = 1;
}


sub is_new() {
	my ($self) = @_;
	return $self->{_new};
}


sub get {
	my ($self, $key) = @_;
	return $self->{$key};
}


sub set {
	my ($self, $key, $value) = @_;
	
	if ( defined $value ) {
	   $self->{$key} = $value;
	   $self->{modified} = 1;
    };
	return $self->{$key};
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
	

}
1;
