package Alpaka::Validator::Checks; 

use strict;

# mas OO ? o no es necesario?
sub required {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name no existe" unless ($value);
	return undef;
}


sub gt {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value' es menor que $check_value"
		unless ($value > $check_value);
	return undef;
}


sub lt {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value'es mayor que $check_value"
		unless ($value < $check_value);
	return undef;
}


sub eq {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value'  es distinto de $check_value"
		unless ($value eq $check_value);
	return undef;
}



sub type {
	my ($value, $check_value, $field_name) = @_;
	if ($check_value eq 'Number') {
		return "$field_name = '$value' no es del tipo Number"
			unless ($value =~ /^\s*[0-9+-.][0-9.eE]*\s*$/);
	}
	elsif ($check_value eq 'Integer') {
		return "$field_name = '$value' no es del tipo Integer"
			unless ($value =~ /^\s*[0-9+-][0-9]*\s*$/);
	}
	return undef;
}


sub maxlen {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value' es mas largo que $check_value"
		unless (length($value) <= length($check_value));
	return undef;
}


sub minlen {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value' es mas corto que $check_value"
		unless (length($value) >= length($check_value));
	return undef;
}


sub eqlen {
	my ($value, $check_value, $field_name) = @_;
	return "$field_name = '$value' no es igual a $check_value"
		unless (length($value) == length($check_value));
	return undef;
}


sub code {
	my ($value, $check_value, $field_name, $request) = @_;

	if (ref($check_value) eq 'CODE') {
		return "$field_name = '$value' no es valido"
			unless (&$check_value($value, $request));
	}
	return undef;
}


1;
