package Alpaka::Validator;

use strict;
use Alpaka::Validator::Checks;
use Alpaka::Error::Validator;


sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);

	my @rules;	
	my @errors;
	$self->{_rules} =\@rules;
	$self->{errors} =\@errors;
	
	
	$self->{_checks_map} = {
		'required' => \&Alpaka::Validator::Checks::required,
		'gt' => \&Alpaka::Validator::Checks::gt,
		'lt' => \&Alpaka::Validator::Checks::lt,
		'eq' => \&Alpaka::Validator::Checks::eq,
		'type' => \&Alpaka::Validator::Checks::type,
		'maxlen' => \&Alpaka::Validator::Checks::maxlen,
		'minlen' => \&Alpaka::Validator::Checks::minlen,
		'eqlen' => \&Alpaka::Validator::Checks::eqlen,
		'code' => \&Alpaka::Validator::Checks::code,
	};

	$self;
}


sub validate {
	my ($self, $request) = @_;


		foreach my $rule (@{$self->{_rules}}) {

			my $param_name = $rule->{param_name} || $rule->{param};
			foreach my $check_name (keys %$rule) {
				next if ($check_name eq "param");
				next if ($check_name eq "param_name");
				next if (!defined($self->{_checks_map}->{$check_name}));	
				my $value = $request->get($rule->{param});
				my $check_value = $rule->{$check_name};
				my $rsub = $self->{_checks_map}->{$check_name};
				my $msg = &$rsub($value, $check_value, $param_name) 
					if (defined($rsub));
				push @{$self->{errors}}, $msg if $msg;
			}
	}
	my $errors = $self->errors();
	throw Alpaka::Error::Validator('-text' => $errors) if @{$self->{errors}};
	return undef;

}


sub map {
	my $self = shift;

	# First use?  Create new _map
	$self->{_checks_map} = {} unless (exists($self->{_checks_map}));
	my $rr_m = $self->{_checks_map};
	# If data is provided, set it!
	if (scalar(@_)) {
		# Is it a hash, or hash-ref?
		if (ref($_[0]) eq 'HASH') {
			# Make a copy, which augments the existing contents (if any)
			%$rr_m = (%$rr_m, %{$_[0]});
		} elsif ((scalar(@_) % 2) == 0) {
			# It appears to be a possible hash (even # of elements)
			%$rr_m = (%$rr_m, @_); # ok
		} else {
			croak("Odd number of elements passed to map().  Not a valid hash");
		}
	}
}

sub rules {
	my ($self, $rules) = @_;
	
	$self->{_rules}=$rules if $rules;
	return $self->{_rules};
}

sub errors {
	my ($self, $errors) = @_;
	
	wantarray ? $self->_errors_as_array() : $self->_errors_as_string();
}

sub _errors_as_array {
	my $self = shift;

	return @{$self->{errors}};
	
}


sub _errors_as_string {
	my $self = shift;

	my $out = "<pre>";
	foreach my $error (@{$self->{errors}}) {
  		$out .="$error\n";
	}
	$out .= "</pre>";
	return $out;
}


sub add_rule {
	my $self = shift;
	
	my $rule;
	if (ref($_[0]) eq 'HASH') {
		%$rule = %{$_[0]};
	} elsif ((scalar(@_) % 2) == 0) {# possible hash (even # of elements)
		%$rule = @_; 
	} else {
		croak("Odd number of elements passed to constructor. Not a valid hash");
	}
	
	push @{$self->{_rules}}, $rule;
	return $rule;

}


1;
