package Alpaka::Plugin::TT2;
use strict;

use Template;
use Exporter;

use vars qw(@ISA @EXPORT );
@ISA = qw(Exporter);

@EXPORT = qw( config_tt2 tt2 process );

sub config_tt2 {
    my $self = shift;
    
    my $config;
    if (scalar(@_)) {
		# Is it a hash, or hash-ref?
		if (ref($_[0]) eq 'HASH') {
			$config = shift;
		}
		elsif ((scalar(@_) % 2) == 0) {
			# It appears to be a possible hash (even # of elements)
			%$config = ( @_); 
		} else {
			croak("Odd number of elements passed to config_tt2().  Not a valid hash");
		}
	}
	
    $self->{plugins}->{tt2} = {} unless ( exists( $self->{plugins}->{tt2} ) );
    my $tt2_slot = $self->{plugins}->{tt2};
    $tt2_slot->{config} = $config;
}

sub tt2 {
    my $self = shift;
    
    my $tt2_slot = $self->{plugins}->{tt2};
    my $config = $tt2_slot->{config};
    $tt2_slot->{engine} = Template->new( $config ) unless $tt2_slot->{engine};
    return $tt2_slot->{engine} ;
}

sub process {
    my ( $self, $template, $vars ) = @_;

    my $output;
    $self->tt2->process( $template, $vars, \$output );
    $self->response->write( $output );
}

1;