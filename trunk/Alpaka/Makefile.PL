use 5.008002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Alpaka',
    VERSION_FROM      => 'lib/Alpaka/Application.pm', # finds $VERSION
    PREREQ_PM         => {	
		'Storable' => 0,
		'Digest::MD5' => 0,
	},
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Alpaka/Application.pm', # retrieve abstract from module
       AUTHOR         => 'Pablo Daniel Cano <canpaniel@soulution.com.ar>') : ()),
);
