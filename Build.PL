use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'XEN::Control',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jozef@kutej.net>',
    dist_version_from   => 'lib/XEN/Control.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'XEN-Control-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
