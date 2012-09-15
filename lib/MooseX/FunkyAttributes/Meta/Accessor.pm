package MooseX::FunkyAttributes::Meta::Accessor;

BEGIN {
	$MooseX::FunkyAttributes::Meta::Accessor::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::Meta::Accessor::VERSION   = '0.001';
}

use Moose;
use namespace::autoclean;

extends qw(Moose::Meta::Method::Accessor);

override _instance_is_inlinable => sub
{
	my $self = shift;
	return $self->associated_attribute->has_all_inliners;
};

1;
