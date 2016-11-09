#=============================================================================
# STANDARD MODULES AND PRAGMAS
use v5.10;    # Require at least Perl version 5.10, thus enabling "//" and "say"
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. open on nonexistent file)
#=============================================================================

use Test::More tests => 4;

use lib 'lib';

use Test::HereFiles qw(
                    create_filename_for
                    create_empty_file
                    delete_temp_file
                    slurp_file
               );

*Test::HereFiles::get_heredoc_for = *main::get_heredoc_for;

{   ## 2 tests ##

    # Test
    #   (1) use of "create_filename_for" with return value
    #   (2) "slurp_file"
    my $out_filename = create_filename_for('animals');
    my $result       = slurp_file $out_filename;
    my $expected     = get_heredoc_for('animals');
    is($result, $expected, '"create_filename_for" and "slurp_file" worked');

    # Test delete temp file (it is a test itself), and clean up
    delete_temp_file($out_filename);
}

{   ## 2 tests ##

    # Test that file is created
    my $random_filename = create_empty_file();
    my $file_exists   = -f $random_filename;
    my $file_size     = -s $random_filename;
    my $file_is_empty = $file_size == 0;
    ok($file_exists && $file_is_empty, '"create_empty_file" works'); 

    # Test void context/two argument form of "create_filename_for"
    create_filename_for('plants', $random_filename);
    my $result   = slurp_file $random_filename; 
    my $expected = "Arabidopsis\nBrassica\n";
    is($result, $expected, 'void-context/two-arg from of "create_filename_for__named" works');

    unlink $random_filename;
}

done_testing;

# HEREDOCS DEFINED HERE ==================================
sub get_heredoc_for {
    my $section = shift;
    
# START Heredocs ------------------------------------------
my %heredoc_for = (

    plants => <<'END',
Arabidopsis
Brassica
END

    animals => <<'END',
Bos
Canis
END

);
# END Heredocs --------------------------------------------

    return %heredoc_for{$section};
}
