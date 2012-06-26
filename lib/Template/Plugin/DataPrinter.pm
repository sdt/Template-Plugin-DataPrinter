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
    my $dp_params = merge( {
            colored => 1,
            color   => {
                array => 'black',
            },
            use_prototypes => 0,
        },
        $params->{dp});
    Data::Printer->import(%$dp_params);

    my $hfat_params = merge( {
            auto_reverse => 1,
            background => 'white',
            foreground => 'black',
            class_prefix => 'tpdp_',
            no_plain_tags => 1,
        },
        $params->{hfat});

    my $hfat = HTML::FromANSI::Tiny->new(%$hfat_params);
    my $self = bless {
        _CONTEXT => $context,
        hfat => $hfat,
    }, $class;

    return $self;
}

sub dump {
    my $self = shift;

    # p(@_) only seems to print out the first element
    my $text = join("\n", map { p($_) } @_);

    return $text;
}

sub dump_html {
    my $self = shift;

    my $html = $self->_css;
    my $text = $self->dump(@_);
    $html .= "<pre>\n" . $self->{hfat}->html($text) . "\n</pre>";
    return $html;
}

sub _css {
    # Short of a better plan, emit the css on-demand before the first dump_html
    my $self = shift;
    return '' if $self->{done_css};

    $self->{done_css} = 1;
    return $self->{hfat}->style_tag . "\n";
}

1;
