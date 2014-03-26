package MooseX::FunkyAttributes;

use 5.008;
use strict;
use warnings;

BEGIN {
	$MooseX::FunkyAttributes::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::VERSION   = '0.003';
}

use Exporter::Shiny our(@EXPORT) = qw(
	FunkyAttribute
	InsideOutAttribute
	DelegatedAttribute
);

use aliased qw(
	MooseX::FunkyAttributes::Role::Attribute
	FunkyAttribute
);

use aliased qw(
	MooseX::FunkyAttributes::Role::Attribute::InsideOut
	InsideOutAttribute
);

use aliased qw(
	MooseX::FunkyAttributes::Role::Attribute::Delegated
	DelegatedAttribute
);

1;

__END__

=head1 NAME

MooseX::FunkyAttributes - add code smell to your Moose attributes

=head1 SYNOPSIS

   package Circle;
   
   use Moose;
   use MooseX::FunkyAttributes;
   
   has radius => (
      is          => 'rw',
      isa         => 'Num',
      predicate   => 'has_radius',
   );
   
   has diameter => (
      traits      => [ FunkyAttribute ],
      is          => 'rw',
      isa         => 'Num',
      custom_get  => sub { 2 * $_->radius },
      custom_set  => sub { $_->radius( $_[-1] / 2 ) },
      custom_has  => sub { $_->has_radius },
   );

=head1 DESCRIPTION

The MooseX::FunkyAttributes module itself just provides some convenience
functions for the attribute traits that are distributed with it. 

The grand uniting idea behind the traits is that although Moose generally
uses blessed hashrefs for object internals, storing each attribute as an
entry in the hash, sometimes you may want to change that behaviour for
individual attributes. For example, you could use the inside-out technique
for one attribute to suppress it from appearing in L<Data::Dumper> dumps.

The traits bundled with MooseX::FunkyAttributes are as follows. Please
see the documentation for each individual trait for further details.

=over

=item * L<MooseX::FunkyAttributes::Role::Attribute>

Allows you to override the get, set, clear and predicate operations for an
attribute. These are just the raw operations you're overriding; you do not
need to implement type constraint checking, coercians, checking required
attributes, defaults, builders, etc.

With this trait you can create attributes which are calculated on the fly
(as in the SYNOPSIS) or stored somewhere outside the object's blessed
hashref.

=item * L<MooseX::FunkyAttributes::Role::Attribute::InsideOut>

This trait stores the attribute using the inside-out technique. If you want
your whole object to be inside-out, then use L<MooseX::InsideOut>.

=item * L<MooseX::FunkyAttributes::Role::Attribute::Delegated>

This trait delegates the storage of one attribute to another attribute.
For example:

   package Head;
   use Moose;
   has mouth => (
      is           => 'ro',
      isa          => 'Mouth',
   );
   
   package Person;
   use Moose;
   use MooseX::FunkyAttributes;
   has head => (
      is           => 'ro',
      isa          => 'Head',
   );
   has mouth => (
      is           => 'ro',
      isa          => 'Mouth::Human',
      traits       => [ DelegatedAttribute ],
      delegated_to => 'head',
   );

It is not dissimilar to the Moose's idea of "handles" (in the example above,
we could have not defined a C<mouth> attribute as part of the C<Person> class,
and just specified that C<head> handles C<mouth>) however because C<mouth>
is now a proper attribute in the Person class (and will show up via Moose's
introspection API), it can have its own type constraints, coercion, trigger,
predicate, etc.

=back

The MooseX::FunkyAttributes module itself exports some constants (e.g.
C<FunkyAttribute> in the SYNOPSIS) which can be used as abbreviations for
the full trait package names. These constants are:

=over

=item C<FunkyAttribute>

=item C<InsideOutAttribute>

=item C<DelegatedAttribute>

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=MooseX-FunkyAttributes>.

=head1 SEE ALSO

L<MooseX::FunkyAttributes::Role::Attribute>,
L<MooseX::FunkyAttributes::Role::Attribute::InsideOut>,
L<MooseX::FunkyAttributes::Role::Attribute::Delegated>.

These effect storage for whole object instances; not just one attribute:
L<MooseX::GlobRef>,
L<MooseX::InsideOut>,
L<MooseX::ArrayRef>.

L<MooseX::CustomInitArgs> - if you have (as in the SYNOPSIS) one attribute
which is calculated from another (diameter from radius), MooseX::CustomInitArgs
will allow you to accept both attributes in the constructor (i.e. accept a
diameter in the constructor, halve it, and set the radius attribute).

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

