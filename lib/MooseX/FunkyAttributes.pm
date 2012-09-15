package MooseX::FunkyAttributes;

BEGIN {
	$MooseX::FunkyAttributes::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::FunkyAttributes::VERSION   = '0.001';
}

use 5.008;

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

use Exporter::Everything;

1;

__END__

=head1 NAME

MooseX::FunkyAttributes - add code smell to your Moose attributes

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=MooseX-FunkyAttributes>.

=head1 SEE ALSO

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

