# NAME

Template::Plugin::DataPrinter - Template Toolkit dumper plugin using Data::Printer

# VERSION

version 0.001

# SYNOPSIS

    [% USE DataPrinter %]

    [% DataPrinter.dump(variable) %]
    [% DataPrinter.dump_html(variable) %]

# DESCRIPTION

This is a dumper plugin for [Template::Toolkit](http://search.cpan.org/perldoc?Template::Toolkit) which uses [Data::Printer](http://search.cpan.org/perldoc?Data::Printer)
instead of [Data::Dumper](http://search.cpan.org/perldoc?Data::Dumper).

[Data::Printer](http://search.cpan.org/perldoc?Data::Printer) is a colorised pretty-printer with nicely human-readable object
output.

# METHODS

The provided methods match those of [Template::Plugin::Dumper](http://search.cpan.org/perldoc?Template::Plugin::Dumper).

## dump

Generates an ansi-colorised dump of the data structures passed.

    [% USE DataPrinter %]
    [% DataPrinter.dump(myvar) %]
    [% DataPrinter.dump(myvar, yourvar) %]

## dump\_html

Generates a html-formatted dump of the data structures passed. The html is
generated from the raw ansi-colorised text by [HTML::FromANSI::Tiny](http://search.cpan.org/perldoc?HTML::FromANSI::Tiny).

    [% USE DataPrinter %]
    [% DataPrinter.dump_html(myvar) %]
    [% DataPrinter.dump_html(myvar, yourvar) %]

# CONFIGURATION

This plugin has no configuration of its own, but the underlying [Data::Printer](http://search.cpan.org/perldoc?Data::Printer)
and [HTML::FromANSI::Tiny](http://search.cpan.org/perldoc?HTML::FromANSI::Tiny) modules can be configured using the `dp` and
`hfat` parameters.

    [% USE DataPrinter(dp = { ... }, hfat = { ... }) %]

- dp

A hashref containing the params to be passed to [Data::Printer](http://search.cpan.org/perldoc?Data::Printer)s `import`
function.

See the [Data::Printer](http://search.cpan.org/perldoc?Data::Printer) documentation for more information.

- hfat

A hashref containing the params to be passed to the [HTML::FromANSI::Tiny](http://search.cpan.org/perldoc?HTML::FromANSI::Tiny)
constructor.

See the [HTML::FromANSI::Tiny](http://search.cpan.org/perldoc?HTML::FromANSI::Tiny) documentation for more information.

## Disabling colorisation

Colorization is turned on by default. To turn it off, use [Data::Printer](http://search.cpan.org/perldoc?Data::Printer)'s
`colored` parameter:

    [% USE DataPrinter(dp = { colored = 0 }) %]

## Using as a drop-in replacement for Template::Plugin::Dumper

This module can be used more-or-less as a drop-in replacement for the default
Dumper plugin by specifying an explicit plugin mapping to the `Template`
constructor:

    my $template = Template->new(...,
            PLUGINS => {
                Dumper => 'Template::Plugin::DataPrinter',
            },
        );

Then existing templates such as the one below will automatically use the
`DataPrinter` plugin instead.

    [% USE Dumper(Indent=0, Pad="<br>") %]

    [% Dumper.dump(variable) %]
    [% Dumper.dump_html(variable) %]

Any constructor parameters not recognised by the `DataPrinter` plugin will
be silently ignored, so the `Indent` and `Pad` parameters above will have no
effect.

# AUTHOR

Stephen Thirlwall <sdt@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
