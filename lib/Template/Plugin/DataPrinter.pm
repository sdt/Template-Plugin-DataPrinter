package Template::Plugin::DataPrinter;
use strict;
use warnings;
use base 'Template::Plugin';

# ABSTRACT: Template Toolkit dumper plugin using Data::Printer
# VERSION

use HTML::FromANSI::Tiny ();
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
    my $text = join('', map { p($_) . "\n" } @_);

    return $text;
}

sub dump_html {
    my $self = shift;

    my $html = $self->_css;
    my $text = $self->dump(@_);
    $html .= "<pre>\n" . $self->{hfat}->html($text) . '</pre>';
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

__END__

=pod

=head1 SYNOPSIS

    [% USE DataPrinter %]

    [% DataPrinter.dump(variable) %]
    [% DataPrinter.dump_html(variable) %]

=head1 DESCRIPTION

This is a dumper plugin for L<Template::Toolkit> which uses L<Data::Printer>
instead of L<Data::Dumper>.

L<Data::Printer> is a colorised pretty-printer with nicely human-readable object
output.

=head1 METHODS

The provided methods match those of L<Template::Plugin::Dumper>.

=head2 dump

Generates an ansi-colorised dump of the data structures passed.

    [% USE DataPrinter %]
    [% DataPrinter.dump(myvar) %]
    [% DataPrinter.dump(myvar, yourvar) %]

=head2 dump_html

Generates a html-formatted dump of the data structures passed. The html is
generated from the raw ansi-colorised text by L<HTML::FromANSI::Tiny>.

    [% USE DataPrinter %]
    [% DataPrinter.dump_html(myvar) %]
    [% DataPrinter.dump_html(myvar, yourvar) %]

=head1 CONFIGURATION

This plugin has no configuration of its own, but the underlying L<Data::Printer>
and L<HTML::FromANSI::Tiny> modules can be configured using the C<dp> and
L<hfat> parameters.

    [% USE DataPrinter(dp = { ... }, hfat = { ... }) %]

=head2 Disabling colorisation

Colorization is turned on by default. To turn it off, use L<Data::Printer>'s
C<colored> parameter:

    [% USE DataPrinter(dp = { colored = 0 }) %]

=head2 Using as a drop-in replacement for Template::Plugin::Dumper

This module can be used more-or-less as a drop-in replacement for the default
Dumper plugin by specifying an explicit plugin mapping to the C<Template>
constructor:

    my $template = Template->new(...,
            PLUGINS => {
                Dumper => 'Template::Plugin::DataPrinter',
            },
        );


Then templates such as this will automatically use the C<DataPrinter> plugin
instead.

    [% USE Dumper(Indent=0, Pad="<br>") %]

    [% Dumper.dump(variable) %]
    [% Dumper.dump_html(variable) %]

Any constructor parameters not recognised by the C<DataPrinter> plugin will
be silently ignored, so the C<Indent> and C<Pad> parameters above will have no
effect.

=cut
