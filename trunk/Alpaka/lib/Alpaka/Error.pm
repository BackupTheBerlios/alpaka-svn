package Alpaka::Error;
use base qw( Error );
use overload ('""' => 'stringify');

sub new  {
    my $self = shift;

    local $Error::Depth = $Error::Depth + 1;
    local $Error::Debug = 1;  # Enables storing of stacktrace

	$self->SUPER::new(@_);
}

 sub stringify
  {
    my ($self) = @_;
    my $class = ref($self) || $self;
	my $text = $self->text();
	my $line = $self->line();
	my $file = $self->file();
	  
	my $out = "<h1>$class Exception</h1> ";
	$out   .= "<pre>$text</pre>  ";
	$out   .= "<pre>at $file line $line </pre>  ";
	return $out;  

  }
	  
  
1;
