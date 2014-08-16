use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Path::Tiny;
use Test::Deep;
use Test::DZil;

my $tzil = Builder->from_config(
    { dist_root => 't/does_not_exist' },
    {
        add_files => {
            path(qw(source dist.ini)) => simple_ini(
                [ GatherDir => ],
                [ Breaks => {
                        'Foo::Bar' => '<= 1.0',
                        'Foo::Baz' => '== 2.35',
                    }
                ],
            ),
        },
    },
);

$tzil->chrome->logger->set_debug(1);
$tzil->build;

cmp_deeply(
    $tzil->distmeta,
    superhashof({
        dynamic_config => 0,
        x_breaks => {
            'Foo::Bar' => '<= 1.0',
            'Foo::Baz' => '== 2.35',
        },
    }),
    'metadata correct when valid breakages are specified',
)
or diag 'got distmeta: ', explain $tzil->distmeta;

diag 'got log messages: ', explain $tzil->log_messages
    if not Test::Builder->new->is_passing;

done_testing;
