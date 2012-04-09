package MooX::HasEnv;
BEGIN {
  $MooX::HasEnv::AUTHORITY = 'cpan:GETTY';
}
{
  $MooX::HasEnv::VERSION = '0.001';
}
# ABSTRACT: Making attributes based on ENV variables

use strict;
use warnings;
use Package::Stash;

sub import {
	my ( $class ) = @_;
	my $caller = caller;

	eval qq{
		package $caller;
		use Moo;
	};

 	my $stash = Package::Stash->new($caller);

	$stash->add_symbol('&has_env', sub {
		my ( $name, $env_var, $default ) = @_;
		my $builder = '_build_'.$name;
		$stash->add_symbol('&'.$builder, sub {
			my $env_value = $env_var && defined $ENV{$env_var} ? $ENV{$env_var} : undef;
			return defined $env_value ? $env_value : ref $default eq 'CODE' ? $default->($_[0]) : $default;
		});
		$stash->get_symbol("&has")->($name,
			is => 'ro',
			lazy_build => 1,
			builder => $builder,
		);
	});
}

1;

__END__
=pod

=head1 NAME

MooX::HasEnv - Making attributes based on ENV variables

=head1 VERSION

version 0.001

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Torsten Raudssus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

