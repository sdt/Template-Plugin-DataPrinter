# NAME

Template::Plugin::DataPrinter - Template Toolkit dumper plugin using Data::Printer

# VERSION

version 0.017

# SYNOPSIS

    [% USE DataPrinter %]

    [% DataPrinter.dump(variable) %]
    [% DataPrinter.dump_html(variable) %]

# DESCRIPTION

This is a dumper plugin for [Template::Toolkit](https://metacpan.org/pod/Template%3A%3AToolkit) which uses
[Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter) instead of [Data::Dumper](https://metacpan.org/pod/Data%3A%3ADumper).

[Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter) is a colorised pretty-printer with nicely
human-readable object output.

# METHODS

The provided methods match those of
[Template::Plugin::Dumper](https://metacpan.org/pod/Template%3A%3APlugin%3A%3ADumper).

## dump

Generates an ansi-colorised dump of the data structures passed.

    [% USE DataPrinter %]
    [% DataPrinter.dump(myvar) %]
    [% DataPrinter.dump(myvar, yourvar) %]

## dump\_html

Generates a html-formatted dump of the data structures passed. The ansi
colorisation is converted to html by
[HTML::FromANSI::Tiny](https://metacpan.org/pod/HTML%3A%3AFromANSI%3A%3ATiny).

    [% USE DataPrinter %]
    [% DataPrinter.dump_html(myvar) %]
    [% DataPrinter.dump_html(myvar, yourvar) %]

# CONFIGURATION

This plugin has no configuration of its own, but the underlying
[Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter) and [HTML::FromANSI::Tiny](https://metacpan.org/pod/HTML%3A%3AFromANSI%3A%3ATiny)
modules can be configured using the `dp` and `hfat` parameters.

    [% USE DataPrinter(dp = { ... }, hfat = { ... }) %]

- dp

    A hashref containing the params to be passed to `Data::Printer::import`.

    See the [Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter) documentation for more information.

- hfat

    A hashref containing the params to be passed to `HTML::FromANSI::Tiny->new`.

    See the [HTML::FromANSI::Tiny](https://metacpan.org/pod/HTML%3A%3AFromANSI%3A%3ATiny) documentation for more
    information.

## Disabling colorisation

Colorisation is turned on by default. To turn it off, use
[Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter)'s `colored` parameter:

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

Any unrecognised constructor parameters are silently ignored, so the `Indent`
and `Pad` parameters above will have no effect.

## Using a custom .dataprinter file

A custom [Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter) configuration file can be specified like so:

    [% USE DataPrinter(dp = { rc_file = '/path/to/my/rcfile.conf' }) %]

Beware that setting `colored = 0` in your `.dataprinter` file
_will not work_. This must be specified in the `USE DataPrinter` code.

    [% USE DataPrinter(dp = { rc_file = '...', colored = 0 }) %]

# BUGS

Setting `colored = 0` in the `.dataprinter` file will not work.
The `colored = 0` setting must appear in the `USE DataPrinter` line.

# SEE ALSO

- [Template::Toolkit](https://metacpan.org/pod/Template%3A%3AToolkit)
- [Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter)
- [HTML::FromANSI::Tiny](https://metacpan.org/pod/HTML%3A%3AFromANSI%3A%3ATiny)

# AUTHOR

Stephen Thirlwall <sdt@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
