package MooseX::FunkyAttributes::Role::Attribute::InsideOut;

BEGIN {
	$MooseX::FunkyAttributes::Role::Attribute::InsideOut::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::Role::Attribute::InsideOut::VERSION   = '0.001';
}

use Hash::FieldHash ();
use Moose::Role;
use namespace::autoclean;

with qw(MooseX::FunkyAttributes::Role::Attribute);

our @_HASHES;

my $i = 0;
before _process_options => sub
{
	my ($class, $name, $options) = @_;
	
	my $hashcount = $i++;
	Hash::FieldHash::fieldhash my %h;
	$_HASHES[$hashcount] = \%h;
	
	$options->{custom_get}           = sub { $h{ $_[1] } };
	$options->{custom_set}           = sub { $h{ $_[1] } = $_[2] };
	$options->{custom_has}           = sub { exists $h{ $_[1] } };
	$options->{custom_clear}         = sub { delete $h{ $_[1] } };
	$options->{custom_inline_get}    = sub { my ($self, $inst) = @_; qq(\$MooseX::FunkyAttributes::Role::Attribute::InsideOut::_HASHES[$hashcount]{$inst};) };
	$options->{custom_inline_set}    = sub { my ($self, $inst, $val) = @_; qq(\$MooseX::FunkyAttributes::Role::Attribute::InsideOut::_HASHES[$hashcount]{$inst} = $val;) };
	$options->{custom_inline_weaken} = sub { my ($self, $inst) = @_; qq(Scalar::Util::weaken \$MooseX::FunkyAttributes::Role::Attribute::InsideOut::_HASHES[$hashcount]{$inst};) };
	$options->{custom_inline_has}    = sub { my ($self, $inst) = @_; qq(exists \$MooseX::FunkyAttributes::Role::Attribute::InsideOut::_HASHES[$hashcount]{$inst};) };
	$options->{custom_inline_clear}  = sub { my ($self, $inst) = @_; qq(delete \$MooseX::FunkyAttributes::Role::Attribute::InsideOut::_HASHES[$hashcount]{$inst};) };
};

1;

