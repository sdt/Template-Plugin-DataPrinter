package Template::Plugin::DataPrinter::TestUtils;

use strict;
use warnings;
use Test::Builder;
use base qw< Exporter >;

my $TB = Test::Builder->new;
our @EXPORT = qw< process_ok match_count_is >;

use Template;

sub process_ok {
    my ($template, $stash, $name, $tt) = @_;

    $tt ||= Template->new;
    my $out;

    my $ok = $tt->process(\$template, $stash, \$out);
    $TB->diag($tt->error) unless $ok;
    $TB->ok($ok, $name);

    return $out;
}

sub match_count_is {
    my ($string, $regex, $expected, $message) = @_;

    my $got = 0;
    $got++ while $string =~ /$regex/g;
    $TB->is_num($got, $expected, $message);
}

1;
