# NAME

Test::StringFiles - Embed files in your script and use them programatically.

# VERSION

version 0.0007

# SYNOPSIS

    # Set up this file to use Test::StringFiles
    use Test::StringFiles;

    # REQUIRED: include user's funciton in module's namespace 
    *Test::StringFiles::get_string_for = *main::get_string_for;
    
    # Create a file containing a specified string
    my $in_file  = create_filename_for('input');
    
    # Create an empty file and do something with it
    my $out_file = create_empty_file();
    system("sort $in_file | uniq -c > $out_file");
    
    # read in a file (like "slurp" from File::Slurp and friends)
    my $result   = slurp_file $out_file;
    
    my $expected = get_string_for('expected');
    
    if ($result eq $expected) {
        print "file correctly created\n";
    }
    else {
        print "'$result' differs from '$expected'\n";
    }
    

    # REQUIRED: user-supplied subroutine named "get_string_for"
    sub get_string_for {
        my $id = shift;
    
        my %string_for = (
    
        # input
        input => <<'END',
    foo
    foo
    bar
    foo
    bar
    END
    
        # expected
        expected => <<'END',
          2 bar
          3 foo
    END
    
        );
        return %string_for{$id};
    }

# DESCRIPTION

Embed files in your script and use them programatically.

# SUBROUTINES

## get\_string\_for(`$id`)

This subroutine **must be** supplied by the user. It is **absolutely required**
for Test::StringFiles to work. All it has to do is accept an ID and return a
string. In the example in the Synopsis, we implement this using a hash of
heredocs, but it could be accomplished in many different ways.

**positional parameters**:

- `$id`: ID for a chosen string.

**returns**: The string corresponding to the ID.

In addition to creating this subroutine, you **must** include the following
line near the top of your file:

    *Test::StringFiles::get_string_for = *main::get_string_for;

I hope to find a better way to do this in future versions.

## create\_filename\_for(`$id`)

## create\_filename\_for(`$id`,`$filename`)

**positional parameters**:

- `$id`: ID for the string chosen to be written to a temp file.
- `$filename`: The name of a file to which the chosen string will be
written. If not given, a temporary file will be created.

**returns**: Name of the filename into which the string was written.

## delete\_temp\_file(`$filename`)

**positional parameter**:

- `$filename`: Name of a file to be deleted. This runs as a test, with a message indicating the temporary file deleted.

## slurp\_file(`$filename`)

Read a file into a string (without having to load yet another module).

**positional parameter**:

- `$filename`: Name of a file whose contents will be read into a string.

**returns**: Entire contents of the chosen file (as a string).

## create\_empty\_file

**returns**: Name for an empty file that has just been created with a random
"temporary" filename (it's not really temporary because you have to delete it
yourself). 

# RATIONALE

I have been using heredocs in Perl 6 for my tests in a similar way to how I previously used Data::Section in Perl 5 tests. These functions make using heredocs in Perl 5 much more amenable to test situations.

# DIAGNOSTICS

Nothing besides normal Perl warnings and errors.

# CONFIGURATION AND ENVIRONMENT

This current implementation **absolutely** requires that code using this module:

- Have a subroutine named `get_string_for`
- Include the line:

        *Test::StringFiles::get_string_for = *main::get_string_for;

# DEPENDENCIES

Perl 5.10 or later.

# INCOMPATIBILITIES

None that the author is aware of, except that the example in the Synopsis
itself requires bash.

# BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to molecules at cpan.org.

Patches are welcome.

# SEE ALSO

# ACKNOWLEDGEMENTS

Thanks to Ricardo SIGNES for [Data::Section](https://metacpan.org/pod/Data::Section). `Test::StringFiles` is built around using heredocs similar to how I've been using `Data::Section` in tests for many years.

# AUTHOR

Christopher Bottoms &lt;molecules &lt;at> cpan &lt;dot> org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Christopher Bottoms.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
