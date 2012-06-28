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

TODO: mention why - colorisation and the nice object output

# METHODS

## dump

Generates an ansi-colorized dump of the data structures passed.

    [% USE Dumper %]
    [% Dumper.dump(myvar) %]
    [% Dumper.dump(myvar, yourvar) %]

## dump\_html

Generates a html-formatted dump of the data structures passed. The html is
generated from the raw ansi-colorized text by [HTML::FromANSI::Tiny](http://search.cpan.org/perldoc?HTML::FromANSI::Tiny).

    [% USE Dumper %]
    [% Dumper.dump_html(myvar) %]
    [% Dumper.dump_html(myvar, yourvar) %]

# CONFIGURATION

    [% USE Dumper(dp = { ... }, hfat => { ... }) %]

TODO:

## Disabling colorization

TODO:

## Using as a drop-in replacement for Template::Plugin::Dumper

TODO:

# AUTHOR

Stephen Thirlwall <sdt@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
