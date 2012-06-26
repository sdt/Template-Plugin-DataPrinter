#!/usr/bin/env perl

use Test::Most;
use Test::Builder;
use Template;

my $TB = Test::Builder->new;

my $template = <<'EOT';
[%
USE DataPrinter(dp => { color = { array => 'red' } },
                hfat = { no_plain_tags => 0 } );
DataPrinter.dump_html(one, two);
DataPrinter.dump_html(three, four);
%]
EOT

$template = '[% USE DataPrinter; DataPrinter.dump_html(one, two); DataPrinter.dump_html(three, four) %]';

{
    package MyTest;
    sub new { my $class = shift; bless({ @_ }, $class); }
}

my $one   = [ 1 .. 3 ];
my $two   = { a => 1, b => 2, c => 3 };
my $three = 3;
my $four  = MyTest->new(d => 4);

my $stash = {
    one => $one,
    two => $two,
    three => $three,
    four => $four,
};

my $out = process($template, $stash, 'basic template');
use File::Slurp; write_file('out.html', \$out);

done_testing;

#------------------------------------------------------------------------------

sub process {
    my ($template, $stash, $name) = @_;

    my $tt = Template->new;
    my $out;

    my $ok = $tt->process(\$template, $stash, \$out);
    $TB->diag($tt->error) unless $ok;
    $TB->ok($ok, $name);

    return $out;
}
