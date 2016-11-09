use strict;   # Must declare all variables before using them
package Test::HereFiles;
#ABSTRACT:  Use "embedded" files in the form of heredocs.

use warnings; # Emit helpful warnings
use v5.10;    # Require at least Perl version 5.10, thus enabling "//" and "say"
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. open on nonexistent file)
#=============================================================================

use Test::More;
use File::Temp qw( tempfile );

#=============================================================================
# Exporter settings
use base qw( Exporter );

our @EXPORT_OK = qw(
    delete_temp_file
    create_filename_for
    create_empty_file
    slurp_file 
);
#=============================================================================

sub create_filename_for {
    my $section  = shift;
    my $filename = shift // create_empty_file();

    # get the heredoc from the test file
    my $string = get_heredoc_for($section);

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

=head1 SYNOPSIS

=head1 DESCRIPTION

Use "embedded" files in the form of heredocs.

This current implementation absolutely requires that code using this module:

1. Have a subroutine named C<get_heredoc_for>
2. Include the line:

    *Test::HereFiles::get_heredoc_for = *main::get_heredoc_for;
        

=head1 SUBROUTINES

=head2 C<create_filename_for($heredoc_name)>

=head2 C<create_filename_for($heredoc_name,$filename)>

positional parameters:

=over 1

=item C<$heredoc_name>: Name of "heredoc" chosen to be written to a temp file.

=item C<$filename>: String. The name of a file to which the content of the heredoc will be
written. If not given, a temporary file will be created.

=back

returns: Name of the filename containing the "heredoc" text.

=head2 C<delete_temp_file($filename)>

positional parameter:

=over 1

=item C<$filename>: Name of a file to be deleted. This runs as a test, with a message indicating the temporary file deleted.

=back

=head2 C<slurp_file($filename)>

positional parameter:

=over 1

=item C<$filename>: Name of a file whose contents will be read into a string.

=item returns: String containing the entire contents of the chosen file.

=back

=head2 C<create_empty_file>

returns:
    Name for an empty file that has just been created with a random
    "temporary" filename (it's not really temporary because you have to
    delete it yourself). 

=head1 RATIONALE

I have been using heredocs in Perl 6 for my tests in a similar way to how I previously used Data::Section in Perl 5 tests. These functions make using heredocs in Perl 5 much more amenable to test situations.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

    Perl 5.10 or later.

=head1 INCOMPATIBILITIES

    None that the author is aware of.

=head1 BUGS AND LIMITATIONS

     There are no known bugs in this module.

     Please report problems to molecules at cpan.org.

     Patches are welcome.

=head1 SEE ALSO

=head1 ACKNOWLEDGEMENTS

    Thanks to Ricardo SIGNES for Data::Section. IRCF::Test is built around using heredocs similar to how I've been using Data::Section in tests for many years.

=cut
