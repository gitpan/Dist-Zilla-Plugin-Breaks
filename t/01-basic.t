use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::Fatal;
use Test::Deep;
use Test::Deep::JSON;
use Test::DZil;

{
    my $tzil = Builder->from_config(
        { dist_root => 't/does_not_exist' },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    [ GatherDir => ],
                    [ MetaJSON  => ],
                    [ Breaks => {
                            'Foo::Bar' => '<= 1.0',
                            'Foo::Baz' => '== 2.35',
                        }
                    ],
                ),
            },
        },
    );

    $tzil->build;
    my $json = $tzil->slurp_file('build/META.json');

    cmp_deeply(
        $json,
        json(superhashof({
            dynamic_config => 0,
            x_breaks => {
                'Foo::Bar' => '<= 1.0',
                'Foo::Baz' => '== 2.35',
            },
        })),
        'metadata correct when valid breakages are specified',
    );
}

{
    my $tzil = Builder->from_config(
        { dist_root => 't/corpus/dist/DZT' },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    [ GatherDir => ],
                    [ MetaJSON  => ],
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
}

done_testing;
