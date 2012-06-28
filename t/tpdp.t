#!/usr/bin/env perl

use lib './t/lib';
use Template::Plugin::DataPrinter::TestUtils;

use Test::More;
require Test::NoWarnings;

use Term::ANSIColor qw< color >;

delete $ENV{DATAPRINTERRC}; # make sure user rc doesn't interfere

# Use some custom settings in the header. This lets us test some extra stuff
# 1. we can be sure to expect these type/color combinations
# 2. check that the dp and hfat parameters are honored
my $template_header = <<'EOT';
USE DataPrinter(
    dp   = { color = { string='blue', number='cyan' } },
    hfat = { class_prefix = 'test_' },
);
EOT

my %stash = (
    string => 'a string',
    number => 1234,
);

{
    note 'Testing dump';
    my $template = "[%
        $template_header
        DataPrinter.dump(string, number);
    %]";

    my $ansi = process_ok($template, \%stash, 'dump template processed ok');

    my $blue  = quotemeta(color('blue'));
    my $cyan  = quotemeta(color('cyan'));
    my $reset = quotemeta(color('reset'));
    like($ansi, qr/$blue.*"$stash{string}".*$reset/,
        'output contains blue string');
    like($ansi, qr/$cyan.*$stash{number}.*$reset/,
        'output contains cyan number');
    like($ansi, qr/$stash{string}.*$stash{number}/s,
        'output contains string in number in correct order');
}

{
    note 'Testing dump_html';
    my $template = "[%
        $template_header
        DataPrinter.dump_html(string, number);
    %]";

    my $html = process_ok($template, \%stash,
        'dump_html template processed ok');

    match_count_is($html, qr/<style/, 1, 'css is output only once');

    like($html, qr/test_blue.*$stash{string}/s, 'output contains blue string');
    like($html, qr/test_cyan.*$stash{number}/s, 'output contains cyan number');
    like($html, qr/$stash{string}.*$stash{number}/s,
        'output contains string in number in correct order');
}

Test::NoWarnings::had_no_warnings();
done_testing;
