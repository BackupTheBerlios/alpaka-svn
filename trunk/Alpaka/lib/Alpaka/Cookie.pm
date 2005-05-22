package Alpaka::Cookie;

use strict;

sub new {
    my $class = shift;
	
    my $self = {
        name    => '',
        value   => '',
        expires => undef,
        domain  => '',
        path    => '/',
        secure  => 0,
        @_
    };

    bless($self, $class);

    return $self;
}

sub name {
	return $_[0]->{name} || '';
}

sub value {
	return $_[0]->{value} || '';
}

sub expires {
	return $_[0]->{expires};
}

sub domain {
	return $_[0]->{domain} || '';
}

sub path {
	return $_[0]->{path} || '/';
}

sub secure {
	return $_[0]->{secure} || 0;
}


1;

