#!/usr/bin/env perl

use Test::Most;
use Template::Plugin::DataPrinter;

my $base    = { a => 1, b => 2, c => [ 1 .. 3 ]                    };
my $default = {         b => 3, c => 4                             };
my $extra   = {         b => 4,                  d => { d => 'd' } };

# Test the parameter hash merging logic

eq_or_diff(
    Template::Plugin::DataPrinter::_make_params(
        {
        },
        test => $default
    ),
    { b => 3, c => 4 },
    'default no overrides'
);

eq_or_diff(
    Template::Plugin::DataPrinter::_make_params(
        {
            '+test' => $extra,
        },
        test => $default
    ),
    { b => 4, c => 4, d => { d => 'd' } },
    'default with overrides'
);

eq_or_diff(
    Template::Plugin::DataPrinter::_make_params(
        {
            test => $base,
        },
        test => $default
    ),
    { a => 1, b => 2, c => [ 1 .. 3 ] },
    'base no overrides'
);

eq_or_diff(
    Template::Plugin::DataPrinter::_make_params(
        {
            test => $base,
            '+test' => $extra,
        },
        test => $default
    ),
    { a => 1, b => 4, c => [ 1 .. 3 ], d => { d => 'd' } },
    'base with overrides'
);

done_testing;
