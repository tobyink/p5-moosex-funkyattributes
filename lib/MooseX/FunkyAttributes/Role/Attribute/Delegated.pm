package MooseX::FunkyAttributes::Role::Attribute::Delegated;

BEGIN {
	$MooseX::FunkyAttributes::Role::Attribute::Delegated::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::Role::Attribute::Delegated::VERSION   = '0.001';
}

use Moose::Role;
use namespace::autoclean;

with qw(MooseX::FunkyAttributes::Role::Attribute);

has delegated_to        => (is => 'ro', isa => 'Str', required => 1);
has delegated_accessor  => (is => 'ro', isa => 'Str');
has delegated_has       => (is => 'ro', isa => 'Str');
has delegated_clear     => (is => 'ro', isa => 'Str');

before _process_options => sub
{
	my ($class, $name, $options) = @_;
	
	my $to = $options->{delegated_to}
		or confess "Required option 'delegated_to' missing";
	
	# Meh... we should use Moose's introspection to get the name of accessors, clearers, etc.
	my $accessor  = exists $options->{delegated_accessor} ? $options->{delegated_accessor} : $name;
	my $private   = !!($accessor =~ /^_/);
	my $predicate = exists $options->{delegated_has}   ? $options->{delegated_has}   : ($private ? "_has$accessor"   : "has_$accessor");
	my $clearer   = exists $options->{delegated_clear} ? $options->{delegated_clear} : ($private ? "_clear$accessor" : "clear_$accessor");

	$options->{custom_inline_weaken} ||= sub { q() };  # :-(

	if ($accessor)
	{
		$options->{custom_get} = sub { $_[1]->$to->$accessor };
		$options->{custom_set} = sub { $_[1]->$to->$accessor($_[2]) };
		$options->{custom_inline_get} = sub {
			my ($self, $inst, $val) = @_;
			qq($inst->$to->$accessor();)
		};
		$options->{custom_inline_set} = sub {
			my ($self, $inst, $val) = @_;
			qq($inst->$to->$accessor($val);)
		};
	}
	
	if ($predicate)
	{
		$options->{custom_has} = sub { $_[1]->$to->$predicate };
		$options->{custom_inline_has} = sub {
			my ($self, $inst) = @_;
			qq($inst->$to->$predicate();)
		};
	}
	
	if ($clearer)
	{
		$options->{custom_clear} = sub { $_[1]->$to->$clearer };
		$options->{custom_inline_clear} = sub {
			my ($self, $inst) = @_;
			qq($inst->$to->$clearer();)
		};
	}
};

1;