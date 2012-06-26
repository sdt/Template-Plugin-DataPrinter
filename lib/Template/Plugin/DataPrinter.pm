package Template::Plugin::DataPrinter;
use strict;
use warnings;
use base 'Template::Plugin';

# ABSTRACT: Template Toolkit dumper plugin for Data::Printer
# VERSION

use HTML::FromANSI::Tiny;
use Hash::Merge::Simple qw< merge >;

sub new {
    my ($class, $context, $params) = @_;

    require Data::Printer;
    my $dp_params = _make_params($params, dp =>
        {
            colored => 1,
            color   => {
                array => 'black',
            },
        });
    Data::Printer->import(%$dp_params);

    my $hfat_params = _make_params($params, hfat =>
        {
            auto_reverse => 1,
            background => 'white',
            foreground => 'black',
        });
    my $self = bless {
        _CONTEXT => $context,
        hfat => HTML::FromANSI::Tiny->new(%$hfat_params),
    }, $class;
}

sub dump {
    my $self = shift;
    my $text = p(@_);
    return $text;
}

sub dump_html {
    my $self = shift;
    my $html;
    if (!$self->{done_css}) {
        $self->{done_css} = 1;
        $html = $self->{hfat}->style_tag;
    }
    my $text = p(@_);
    $html .= '<pre>' . $self->{hfat}->html($text) . '</pre>';
    return $html;
}

sub _make_params {
    # Params are taken in this order:
    # 1. if $params->{$key} is supplied, use that, otherwise $defaults
    # 2. if $params->{+$key} is supplied this is merged over the top
    my ($params, $key, $defaults) = @_;

    my $base      = $params->{$key} || $defaults;
    my $overrides = $params->{'+' . $key} || {};

    return merge($base, $overrides);
}

1;
