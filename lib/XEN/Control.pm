package XEN::Control;

=head1 NAME

XEN::Control - control and fetch information about xen domains

=head1 SYNOPSIS

    my $xen = XEN::Control->new();
    my @domains = $xen->ls;

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use base 'Class::Accessor::Fast';

our $XM_COMMAND = 'sudo xm';

=head1 PROPERTIES

    xm_cmd

=head2 xm_cmd

Holds the command that is used execute xm command. By default it is `sudo xm`.

=cut

__PACKAGE__->mk_accessors(qw{
    xm_cmd
});

=head1 METHODS

=head2 new()

Object constructor.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new({
        'xm_cmd' => $XM_COMMAND,
        @_
    });
    
    return $self;
}


=head2 ls

Returns an array of L<XEN::Domain> objects representing curently running
XEN machines.

=cut

sub ls {
    my $self = shift;
    
    my @xm_ls = $self->xm('ls');
    shift @xm_ls;
    
    my @domains;
    foreach my $domain_line (@xm_ls) {
        chomp $domain_line;
        if ($domain_line !~ /^([-\w]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([-a-z]+)\s+([0-9.]+)$/) {
            warn 'badly formated domain line - "'.$domain_line.'"';
            next;
        }
        
        push @domains, XEN::Domain->new(
            'name'  => $1,
            'id'    => int($2),
            'mem'   => int($3),
            'vcpus' => int($4),
            'state' => $5,
            'times' => $6,
        );
    }
    
    return @domains;
}


=head2 shutdown($domain_name)

Shutdown domain named $domain_name. If the name is all will shutdown
all domains.

=cut

sub shutdown {
    my $self        = shift;
    my $domain_name = shift;
    
    if ($domain_name eq 'all') {
        foreach my $domain ($self->ls) {
            die 'domain with id '.$domain->id.' has a name "all" which is not allowed'
                if $domain->name eq 'all';
            
            $self->shutdown($domain->name);
        }
        
        return;
    }
    
    $self->xm('shutdown', $domain_name);
    
    return;
}


=head2 xm(@args)

Execute C<< $self->xm_cmd >> with @args and return the output.
Dies if the execution fails.

=cut

sub xm {
    my $self = shift;
    my @args = map { "'".quotemeta($_)."'" } @_;
    
    my $xm_cmd = $self->xm_cmd.' '.join(' ', @args);
    my @output = `$xm_cmd`;
    
    die 'failed to execute "'.$xm_cmd.'"' if (($? >> 8) != 0);
}

1;


__END__

=head1 BUGS

Please report any bugs or feature requests to C<bug-xen-control at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XEN-Control>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc XEN::Control

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XEN-Control>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/XEN-Control>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/XEN-Control>

=item * Search CPAN

L<http://search.cpan.org/dist/XEN-Control>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Jozef Kutej, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of XEN::Control
