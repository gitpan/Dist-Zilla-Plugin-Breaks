use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::Fatal;
use Test::DZil;

my $tzil = Builder->from_config(
    { dist_root => 't/corpus/dist/DZT' },
    {
        add_files => {
            'source/dist.ini' => simple_ini(
                [ GatherDir => ],
                [ Breaks => { 'Foo::Bar' => 'abcd' }
                ],
            ),
        },
    },
);

like(
    exception { $tzil->build },
    qr/Invalid version format/,
    'bad version specifications are caught',
);

done_testing;
