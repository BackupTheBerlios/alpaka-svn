package Alpaka::Session;

use strict;

use CGI qw( :cgi );
use Digest::MD5 qw(md5_hex);
use Storable;
use overload '""'  => \&as_string;

sub new {
	my $class = shift;
	my $request = shift;
	my $self = {};
	bless($self, $class);
	
	$self->{_request} = $request; 
	$self->{_new} = 0;
	$self->{_initialized} = 0;
	#guardar los attributos en eun hash !
	return $self;
}


sub _generate_id {
	my ($self) = @_;
	return substr(md5_hex(time() . md5_hex(time(). {}. rand(). $$)), 0, 16);
}


sub init {
	my ($self) = @_;

	my $id = $self->{_request}->get_cookie('SESSION'); # lo que necesito es: el nro de id
	if ($id) {
		$self->{ID} = $id;
		$self->load();
		$self->{_new} =0;
	}
	else {
		$self->{ID} = $self->_generate_id;
		$self->{_new} =1;
		#nueva entonces enviar, sino no
	}
	$self->{_initialized} = 1;
}


sub id() {
	my ($self) = @_;
	return $self->{ID};
}


sub invalidate() {
	my ($self) = @_;
	
	foreach my $key (keys %$self){
		delete $self->{$key} unless ($key=~m/^_/) ;
	}
	$self->{ID} = $self->_generate_id;
	$self->{_new} =1;
	$self->{_initialized} = 1;
}


sub is_new() {
	my ($self) = @_;
	return $self->{_new};
}


sub is_initialized() {
	my ($self) = @_;
	return $self->{_initialized};
}


sub get {
	my ($self, $key) = @_;
	return $self->{$key};
}


sub set {
	my ($self, $key, $value) = @_;
	
	$self->{$key} = $value;
	return $self->{$key};
}


sub load {
	my ($self) = @_;


} 


sub save {
	my ($self) = @_;


}


sub as_string {
	my ($self) = @_;

    	my $out =  " ";# por que no puedo devolver un nulo?

	if ($self->{_initialized}) {
		$out = "<ul>";
		foreach my $key (keys %$self){
			$out .="<li><strong>$key</strong> = $self->{$key}" unless ($key=~m/^_/) ;
		};
		$out .= "</ul>";
	}

    	return $out; #return $out || $self ?
}

1;
