# NAME

Dist::Zilla::Plugin::Breaks - Add metadata about potential breakages to your distribution

# VERSION

version 0.002

# SYNOPSIS

In your `dist.ini`:

    [Breaks]
    Foo::Bar = <= 1.0       ; anything at this version or below is out of date
    Foo::Baz = == 2.35      ; just this one exact version is problematic

# DESCRIPTION

This plugin adds distribution metadata regarding other modules and version
that are not compatible with your distribution's release.  It is not quite the
same as the `conflicts` field in prerequisite metadata (see
["Relationships" in CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec#Relationships)), but rather
indicates what modules will likely not work once your distribution is
installed.

This is a not-uncommon problem when modifying a module's API - there are other
existing modules out on the CPAN (or a darkPAN) which use the old API, and will
need to be updated when the new API is removed.  These modules are not
prerequisites -- our distribution does not use those modules, but rather those
modules use __us__. So, it's not valid to list those modules in our
prerequisites -- besides, it would likely be a circular dependency!

The data is added to metadata in the form of the `x_breaks` field, as set out
by the [Lancaster consensus](http://www.dagolden.com/index.php/2098/the-annotated-lancaster-consensus/).
The exact syntax and use may continue to change until it is accepted as an
official part of the meta specification.

Version ranges can and normally should be specified; see
["Version Ranges" in CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec#Version-Ranges). They are
interpreted as for `conflicts` -- version(s) specified indicate the __bad__
versions of modules, not version(s) that must be present for normal operation.
That is, packages should be specified with the version(s) that will __not__
work when your distribution is installed; for example, if all version of
`Foo::Bar` up to and including 1.2 will break, but a release of 1.3 will
work, then specify the breakage as:

    [Breaks]
    Foo::Bar = <= 1.2

or more accurately:

    [Breaks]
    Foo::Bar = < 1.3

A bare version with no operator is interpreted as `>=` -- all versions at
or above the one specified are considered bad -- which is generally not what
you want to say!

The [\[CheckBreaks\]](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::CheckBreaks) plugin can
generate a test for your distribution that will check this field and provide
diagnostic information to the user should any problems be identified.

Additionally, the [\[Conflicts\]](https://metacpan.org/pod/Dist::Zilla::Plugin::Conflicts) plugin can
generate `x_breaks` data, as well as a (non-standard) mechanism for checking for conflicts
from within `Makefile.PL`/`Build.PL`.

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-Breaks)
(or [bug-Dist-Zilla-Plugin-Breaks@rt.cpan.org](mailto:bug-Dist-Zilla-Plugin-Breaks@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# SEE ALSO

- [Annotated Lancaster consensus](http://www.dagolden.com/index.php/2098/the-annotated-lancaster-consensus/).
- ["Relationships" in CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec#Relationships)
- [Dist::Zilla::Plugin::Test::CheckBreaks](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::CheckBreaks)
- [Dist::Zilla::Plugin::Conflicts](https://metacpan.org/pod/Dist::Zilla::Plugin::Conflicts)
- [Dist::CheckConflicts](https://metacpan.org/pod/Dist::CheckConflicts)

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
