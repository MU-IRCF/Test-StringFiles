#=============================================================================
# STANDARD MODULES AND PRAGMAS
use v5.10;    # Require at least Perl version 5.10, thus enabling "//" and "say"
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. open on nonexistent file)
#=============================================================================

use Test::More tests => 4;

use lib 'lib';

use Test::StringFiles;
*Test::StringFiles::get_string_for = *main::get_string_for;

{   ## 2 tests ##

    # Test
    #   (1) use of "create_filename_for" with return value
    #   (2) "slurp_file"
    my $out_filename = create_filename_for('animals');
    my $result       = slurp_file $out_filename;
    my $expected     = get_string_for('animals');
    is($result, $expected, '"slurp_file" and one-arg form of "create_filename_for" work');

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
    is($result, $expected, 'two-arg form "create_filename_for" works');

    unlink $random_filename;
}

done_testing;

# HEREDOCS DEFINED HERE ==================================
sub get_string_for {
    my $section = shift;
    
# START Heredocs ------------------------------------------
my %string_for = (

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

    return $string_for{$section};
}
