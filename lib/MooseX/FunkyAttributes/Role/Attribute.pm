package MooseX::FunkyAttributes::Role::Attribute;

BEGIN {
	$MooseX::FunkyAttributes::Role::Attribute::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::Role::Attribute::VERSION   = '0.001';
}

use Moose::Role;

use aliased 'MooseX::FunkyAttributes::Meta::Accessor';
use namespace::autoclean;

has custom_get => (
	is         => 'ro',
	isa        => 'CodeRef',
	required   => 1,
);

has custom_set => (
	is         => 'ro',
	isa        => 'CodeRef',
	required   => 1,
);

has custom_has => (
	is         => 'ro',
	isa        => 'CodeRef',
	required   => 1,
);

has custom_clear => (
	is         => 'ro',
	isa        => 'CodeRef',
	predicate  => 'has_custom_clear',
);

has custom_init => (
	is         => 'ro',
	isa        => 'CodeRef',
	predicate  => 'has_custom_init',
);

my @i = qw( set get weaken has clear );
for my $i (@i)
{
	my $custom = "custom_inline_$i";
	has $custom => (
		is        => 'ro',
		isa       => 'CodeRef',
		predicate => "has_$custom",
	);
	next if $i =~ /^(set|weaken)$/;
	around "_inline_${i}_value" => sub
	{
		my ($orig, $self, @args) = @_;
		if ($self->has_all_inliners) {
			return $self->$custom->($self, @args);
		}
		return $self->$orig(@args);
	};
}

around _inline_set_value => sub
{
	my ($orig, $self, @args) = @_;
	my @code = $self->$orig(@args);
	if ($self->has_all_inliners) {
		my $replacement = join qq[\n], $self->custom_inline_set->($self, @args);
		my @new_code;
		while (@code) {
			my $line = shift @code;
			if ($line =~ m{^ \s* \$\S+ \s* = \s* \$\S+ \s* \; \s* $}x)  # poor, very poor :-(
			{
				push @new_code, $replacement;
				next;
			}
			push @new_code, $line;
		}
		return @new_code;
	}
	return @code;
};

around _inline_weaken_value => sub
{
	my ($orig, $self, @args) = @_;
	return unless $self->is_weak_ref;
	if ($self->has_all_inliners) {
		return $self->custom_inline_weaken->($self, @args);
	}
	return $self->$orig(@args);
};

has has_all_inliners => (
	is         => 'ro',
	isa        => 'Bool',
	lazy_build => 1,
);

sub _build_has_all_inliners
{
	my $self = shift;
	for (@i) {
		my $predicate = "has_custom_inline_$_";
		return unless $self->$predicate;
	}
	return 1;
}

after _process_options => sub
{
	my ($class, $name, $options) = @_;
	
	if (defined $options->{clearer}
	and not defined $options->{custom_clear})
	{
		confess "can't set clearer without custom_clear";
	}
};

override accessor_metaclass => sub { Accessor };

override get_raw_value => sub
{
	my ($attr) = @_;
	local $_ = $_[1];
	return $attr->custom_get->(@_);
};

override set_raw_value => sub
{
	my ($attr) = @_;
	local $_ = $_[1];
	return $attr->custom_set->(@_);
};

override has_value => sub
{
	my ($attr) = @_;
	local $_ = $_[1];
	return $attr->custom_has->(@_);
};

override clear_value => sub
{
	my ($attr) = @_;
	local $_ = $_[1];
	return $attr->custom_clear->(@_);
};

override set_initial_value => sub
{
	my ($attr) = @_;
	local $_ = $_[1];
	if ($attr->has_custom_init) {
		return $attr->custom_init->(@_);
	}
	return $attr->custom_set->(@_);
};

1;
