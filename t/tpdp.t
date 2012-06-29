#!/usr/bin/env perl

use lib './t/lib';
use Template::Plugin::DataPrinter::TestUtils;

use Test::More;
require Test::NoWarnings;

use HTML::Entities  qw< encode_entities >;
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
    string => 'a <div> string', # include html tag to make sure it gets escaped
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

    my %estash = map { $_ => encode_entities($stash{$_}) } keys %stash;

    like($html, qr/test_blue.*$estash{string}/s, 'output contains blue string');
    like($html, qr/test_cyan.*$estash{number}/s, 'output contains cyan number');
    like($html, qr/$estash{string}.*$estash{number}/s,
        'output contains string in number in correct order');
}

{
    note 'Testing Dumper dropin replacement operation';

    my $template = '[%
        USE Dumper;
        Dumper.dump(string, number);
        Dumper.dump_html(string, number);
    %]';

    my $tt = Template->new(PLUGINS => {
        Dumper => 'Template::Plugin::DataPrinter'
    });
    my $out1 = process_ok($template, \%stash,
        'Dumper template processed ok', $tt);

    $template =~ s/Dumper/DataPrinter/g;
    my $out2 = process_ok($template, \%stash,
        'DataPrinter template processed ok', $tt);

    is($out1, $out2, 'Dumper alias works');

    $template = '[%
        USE dp = DataPrinter;
        dp.dump(string, number);
        dp.dump_html(string, number);
    %]';
    my $out3 = process_ok($template, \%stash,
        'Aliased template processed ok', $tt);

    is($out1, $out3, 'Alias DataPrinter works');
}

Test::NoWarnings::had_no_warnings();
done_testing;
