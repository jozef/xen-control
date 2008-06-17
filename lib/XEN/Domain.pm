package XEN::Domain;

=head1 NAME

XEN::Domain - xen domain representing object

=head1 SYNOPSIS

    my $domain = XEN::Domain->new(
        'name'  => 'lenny',
        'id'    => 1,
        'mem'   => 256,
        'vcpus' => 2,
        'state' => '-b----',
        'times' => 11.5,
    );

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use base 'Class::Accessor::Fast';

=head1 PROPERTIES

    name
    id
    mem
    vcpus
    state
    times

=cut

__PACKAGE__->mk_accessors(qw{
    name
    id
    mem
    vcpus
    state
    times
});

=head1 METHODS

=head2 new()

Object constructor.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new({ @_ });
    
    return $self;
}

1;


__END__

=head1 AUTHOR

Jozef Kutej

=cut
