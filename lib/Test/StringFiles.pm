use strict;   # Must declare all variables before using them
package Test::StringFiles;
#ABSTRACT:  Embed files in your script and use them programatically.

use warnings; # Emit helpful warnings
use v5.10;    # Require at least Perl version 5.10, thus enabling "//" and "say"
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. open on nonexistent file)
#=============================================================================

use Test::More;
use File::Temp qw( tempfile );

#=============================================================================
# Exporter settings
use base qw( Exporter );

our @EXPORT = qw(
    delete_temp_file
    create_filename_for
    create_empty_file
    slurp_file 
);
#=============================================================================

sub create_filename_for {
    my $string_id  = shift;
    my $filename   = shift // create_empty_file();

    # get the specified string
    my $string = get_string_for($string_id);

    open( my $fh, '>', $filename );
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub create_empty_file {
    my ( $fh, $filename ) = tempfile();
    close $fh;
    return $filename;
}

sub delete_temp_file {
    my $filename  = shift;
    my $delete_ok = unlink $filename;
    ok( $delete_ok, "deleted temp file '$filename'" );
}

sub slurp_file {
    my $filename = shift;
    local $/ = undef;
    open( my $fh, '<', $filename);
    my $string = readline $fh;
    return $string;
}

1;  #Modules must return a true value

=pod

=head1 DESCRIPTION

Embed files in your script and use them programatically.


=head1 SYNOPSIS

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

=head1 SUBROUTINES

=head2 get_string_for(C<$id>)

This subroutine B<must be> supplied by the user. It is B<absolutely required>
for Test::StringFiles to work. All it has to do is accept an ID and return a
string. In the example in the Synopsis, we implement this using a hash of
heredocs, but it could be accomplished in many different ways.

B<positional parameters>:

=over 1

=item C<$id>: ID for a chosen string.

=back

B<returns>: The string corresponding to the ID.

In addition to creating this subroutine, you B<must> include the following
line near the top of your file:

    *Test::StringFiles::get_string_for = *main::get_string_for;

I hope to find a better way to do this in future versions.

=head2 create_filename_for(C<$id>)

=head2 create_filename_for(C<$id>,C<$filename>)

B<positional parameters>:

=over 1

=item C<$id>: ID for the string chosen to be written to a temp file.

=item C<$filename>: The name of a file to which the chosen string will be
written. If not given, a temporary file will be created.

=back

B<returns>: Name of the filename into which the string was written.

=head2 delete_temp_file(C<$filename>)

B<positional parameter>:

=over 1

=item C<$filename>: Name of a file to be deleted. This runs as a test, with a message indicating the temporary file deleted.

=back

=head2 slurp_file(C<$filename>)

Read a file into a string (without having to load yet another module).

B<positional parameter>:

=over 1

=item C<$filename>: Name of a file whose contents will be read into a string.

=back

B<returns>: Entire contents of the chosen file (as a string).

=head2 create_empty_file

B<returns>: Name for an empty file that has just been created with a random
"temporary" filename (it's not really temporary because you have to delete it
yourself). 

=head1 RATIONALE

I have been using heredocs in S<Perl 6> for my tests in a similar way to how I previously used Data::Section in S<Perl 5> tests. These functions make using heredocs in S<Perl 5> much more amenable to test situations.

=head1 DIAGNOSTICS

Nothing besides normal Perl warnings and errors.

=head1 CONFIGURATION AND ENVIRONMENT

This current implementation B<absolutely> requires that code using this module:

=over 1

=item Have a subroutine named C<get_string_for>

=item Include the line:

    *Test::StringFiles::get_string_for = *main::get_string_for;

=back

=head1 DEPENDENCIES

Perl 5.10 or later.

=head1 INCOMPATIBILITIES

None that the author is aware of, except that the example in the Synopsis
itself requires bash.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to molecules at cpan.org.

Patches are welcome.

=head1 SEE ALSO

=head1 ACKNOWLEDGEMENTS

Thanks to Ricardo SIGNES for L<https://metacpan.org/pod/Data::Section|Data::Section>. C<Test::StringFiles> is built around using heredocs similar to how I've been using C<Data::Section> in tests for many years.

=cut
