package Alpaka::Error::Validator;
use base qw( Alpaka::Error );
use overload ('""' => 'stringify');

sub new  {
    my $self = shift;

    local $Error::Depth = $Error::Depth + 1;
    local $Error::Debug = 1;  # Enables storing of stacktrace

	$self->SUPER::new(@_);
}
	  

  
1;
