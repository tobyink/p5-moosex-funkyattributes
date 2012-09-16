BEGIN {
	package Local::Test1;
	use Moose;
	use MooseX::FunkyAttributes;
	use Object::ID;
	use Data::Dumper;
	no thanks;
	
	our %funk_store;
	has funk => (
		traits       => [ FunkyAttribute ],
		is           => 'rw',
		isa          => 'Num',
		custom_get   => sub { $funk_store{ $_[1]->object_id } },
		custom_has   => sub { exists $funk_store{ $_[1]->object_id } },
		custom_clear => sub { delete $funk_store{ $_[1]->object_id } },
		custom_set   => sub { $funk_store{ $_[1]->object_id } = $_[2] },
		clearer      => 'clear_funk',
		custom_inline_set    => sub { my ($self, $inst, $val) = @_; qq(\$Local::Test::funk_store{$inst->object_id} = $val;) },
		custom_inline_get    => sub { my ($self, $inst) = @_; qq(\$Local::Test::funk_store{$inst->object_id};) },
		custom_inline_weaken => sub { my ($self, $inst) = @_; qq(Scalar::Util::weaken \$Local::Test::funk_store{$inst->object_id};) },
		custom_inline_has    => sub { my ($self, $inst) = @_; qq(exists \$Local::Test::funk_store{$inst->object_id};) },
		custom_inline_clear  => sub { my ($self, $inst) = @_; qq(delete \$Local::Test::funk_store{$inst->object_id};) },
	);

	has via => (
		is      => 'ro',
		isa     => 'Object',
		default => sub { Local::Test2->new },
	);

	has delegated => (
		traits             => [ DelegatedAttribute ],
		is                 => 'rw',
		isa                => 'Num',
		delegated_to       => 'via',
		delegated_accessor => 'target',
		clearer            => 'clear_delegated',
	);
	
	has io => (
		traits       => [ InsideOutAttribute ],
		is           => 'rw',
	);

	__PACKAGE__->meta->make_immutable
}

BEGIN {
	package Local::Test2;
	use Moose;
	no thanks;
	has target => (is => 'rw', lazy_build => 1);
}

my $obj = Local::Test1->new(funk => 41);
$obj->funk(42);
print $obj->funk, "\n";
$obj->clear_funk;
print $obj->funk, "\n";
$obj->funk(42);
print $obj->funk, "\n";
$obj->delegated('84');
$obj->io(21);
print $obj->io(21), "\n";
use Data::Dumper;
print Dumper($obj);
