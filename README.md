# NAME

Test::HereFiles - Use "embedded" files in the form of heredocs.

# VERSION

version 0.0003

# SYNOPSIS

# DESCRIPTION

Use "embedded" files in the form of heredocs.

This current implementation absolutely requires that code using this module:

1\. Have a subroutine named `get_heredoc_for`
2\. Include the line:

    *Test::HereFiles::get_heredoc_for = *main::get_heredoc_for;

# SUBROUTINES

## `create_filename_for($heredoc_name)`
=head2 `create_filename_for($heredoc_name,$filename)`

positional parameters:
    `$heredoc_name`
        Name of "heredoc" chosen to be written to a temp file.

    C<$filename>
        String. The name of a file to which $content will be written. If
        not given, a temporary file will be created.

returns:
    Name of the filename containing the "heredoc" text.

## `delete_temp_file($filename)`

positional parameter:
    `$filename`
        Name of a file to be deleted.

This runs as a test, with a message indicating the temporary file deleted.

## `slurp_file($filename)`

positional parameter:
    `$filename`
        Name of a file whose contents will be read into a string.

returns:
    String containing the entire contents of the chosen file.

## `create_empty_file`

returns:
    Name for an empty file that has just been created with a random
    "temporary" filename (it's not really temporary because you have to
    delete it yourself). 

# RATIONALE

I have been using heredocs in Perl 6 for my tests in a similar way to how I previously used Data::Section in Perl 5 tests. These functions make using heredocs in Perl 5 much more amenable to test situations.

# DIAGNOSTICS

# CONFIGURATION AND ENVIRONMENT

# DEPENDENCIES

    Perl 5.10 or later.

# INCOMPATIBILITIES

    None that the author is aware of.

# BUGS AND LIMITATIONS

     There are no known bugs in this module.

     Please report problems to molecules at cpan.org.

     Patches are welcome.

# SEE ALSO

# ACKNOWLEDGEMENTS

    Thanks to Ricardo SIGNES for Data::Section. IRCF::Test is built around using heredocs similar to how I've been using Data::Section in tests for many years.

# AUTHOR

Christopher Bottoms &lt;molecules &lt;at> cpan &lt;dot> org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Christopher Bottoms.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
