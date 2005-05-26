# make sure we are in a sane environment.
$ENV{MOD_PERL} or die "not running under mod_perl!";

#modify @INC if needed
use lib qw(/var/www/alpaka/examples/lib);

#load perl modules of your choice here
#this code is interpreted *once* when the server starts
use Alpaka::Application;

#you may define Perl*Handler subroutines here too 

1; #return true value


