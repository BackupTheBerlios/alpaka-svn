#!/usr/bin/perl

use warnings;
use strict;

use POE;
use POE::Component::Server::HTTP;
use HTTP::Status qw/RC_OK/;
use POSIX;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Alpaka;


my $alpaka;
my $httpd;

if ($ARGV[0] && ($ARGV[0] eq 'start')) {
	print "Starting Alpaka HTTP Server ...\n";
	start();
}
elsif ($ARGV[0] && ($ARGV[0] eq 'stop')) {
	print "Stopping Alpaka HTTP Server ...\n";
    stop();
}
elsif ($ARGV[0] && ($ARGV[0] eq 'restart')) {
	print "Restarting Alpaka HTTP Server ...\n";
    restart();
}
else {
    usage();
}

sub start {
	if (get_pid()) {
		print "Alpaka HTTP Server process already running \n";
		exit;
	}	
	
	my $pid = fork;
	exit if $pid;
	die "Couldn't fork: $!" unless defined($pid);
	POSIX::setsid() or die "Can't start a new session: $!";

	save_pid($pid);
	$SIG{INT} = $SIG{TERM} = $SIG{HUP} = \&signal_handler;
	# trap or ignore $SIG{PIPE}

   	$alpaka = Alpaka->new();
	$httpd = POE::Component::Server::HTTP->new(
		Port => 8000,
		ContentHandler => { "/" => \&alpaka_handler, "/html/" => \&html_handler  },
		Headers => { Server => 'Alpaka Web Server',},
	);
	$poe_kernel->run();	
}

sub stop {
    my $pid = get_pid();
	unlink_pid_file();
    kill 'TERM', $pid if $pid;

}   

sub restart {
	stop();
	start();
}   

sub save_pid {
    my $pid = shift;
    $pid =$$ unless $pid;
    my $file ="alpaka.pid";
    $file = "/tmp/$file";  

    open (FILE,">$file")
        or die "can't open¨ $file";
    print FILE "$pid";
    close FILE;   
} 

sub get_pid {
    my $file ="alpaka.pid";
    $file = "/tmp/$file";  
    
    if (-e $file) {
        open (FILE,"<$file") ;
        my $pid = <FILE>;
        close FILE;
        #unlink $file;
        return $pid;
    }
    return 0;    
} 

sub unlink_pid_file {
    my $file ="alpaka.pid";
    $file = "/tmp/$file";  
    
    if (-e $file) {
        unlink $file;
    } 
} 

sub signal_handler {
    $poe_kernel->call($httpd, "shutdown");
	exit;
}

sub usage {
 print "Usage: alpaka.pl [start|stop|restart]\tstart/stop/restart the htttp server\n"; 
}

sub alpaka_handler {
    my ( $request, $response ) = @_;

	$alpaka->run($request, $response);

    return RC_OK;
}


sub html_handler {
    my ( $request, $response ) = @_;

	undef $/;
	my $filename = $request->uri();
	$filename=~s!http://.*/html/!!;
	open (FILE,"$Bin/../www/html_doc/$filename");
    my $out = <FILE>;


    # Build the response.
    $response->code(RC_OK);
 #   $response->push_header( "Content-Type", "text/html" );
    $response->content("$out");

    # Signal that the request was handled okay.
    return RC_OK;

}