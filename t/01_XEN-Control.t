#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 10;
use Test::Exception;
use Test::Differences;
use Test::Environment 'Dump';

use XEN::Domain;

my @xm_output;
my @xm_cmds;

BEGIN {
    use_ok ( 'XEN::Control' ) or exit;
}

exit main();

sub main {
    my $xen = XEN::Control->new();
    isa_ok($xen, 'XEN::Control');
    can_ok($xen, qw( xm ls shutdown ));
    
    @xm_output = qw(3 2 1);
    is_deeply([ $xen->xm('ls') ], [ qw(3 2 1) ], 'test our test stuff');
    is_deeply([ @xm_cmds ], [ 'ls' ], 'test our test stuff');
    
    @xm_output = dump_with_name('01_xm-ls.txt');
    eq_or_diff(
        [ $xen->ls ],
        [
            XEN::Domain->new(
                'name'  => 'Domain-0',
                'id'    => 0,
                'mem'   => 1417,
                'vcpus' => 2,
                'state' => 'r-----',
                'times' => '249.3',        
            ),
            XEN::Domain->new(
                'name'  => 'lenny',
                'id'    => 1,
                'mem'   => 64,
                'vcpus' => 2,
                'state' => '-b----',
                'times' => '13.7',        
            )
        ],
        'test xm("ls")',
    );
    
    
    return 0;
}

no warnings 'redefine';
sub XEN::Control::xm {
    my $self = shift;
    push @xm_cmds, shift;
    return @xm_output;
}
