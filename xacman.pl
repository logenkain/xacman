#!/usr/bin/perl

# todo
# I want all failures to print a command list, not the xbps default


use v5.10.0;
use warnings;
use strict;
use feature qw(switch say); #For given/when since switch is being depricated
no warnings 'experimental::smartmatch';

sub usage{
print STDERR ("Usage: xacman [OPERATION/OPTION] [PACKAGE NAME]\n");
print STDERR ("	EXAMPLE: xacman -Sy tilda; xacman --refresh tilda\n\n");

#Operations
print STDERR ("OPERATIONS:\n");
print STDERR (" -S, --sync		Install [PACKAGE NAME]\n");

#Sync Options
print STDERR ("Sync Options:\n");
print STDERR ("  s, --search   	Search for packages\n");
print STDERR ("  y, --refresh		Refresh package list\n");  
print STDERR ("  u, --upgrade   Update [PACKAGE NAME]\n");


}

my $xbI = 'xbps-install';
my $xbQ = 'xbps-query';

my $action = $ARGV[0]; # Which xbps program to call

if (not $action){ 
	usage(); exit 0;}


my $cmd = #which term to search/remove/install
					#Pass a quotes to -Rs to list all packages
					#Pass usage guide in case of -S 
&{ sub {
	my $cmd = ($ARGV[1]);
	if ($cmd){
		return $cmd;
	}
	if($action eq '-Ss'){
		return '"" ';
	}
	if($action eq '-Sy', '--refresh'){
	  return 1;
	}
}
}();				 
if ($cmd eq undef){
	usage(); exit 0;}
given ($action) { 		#Try to keep all xbps commands grouped together
											#Also can't figure out how to have multiple when conditions
											#Such as when('-s' || '--sync')
	$action = $xbI when					['-S','--sync']; 
  $action = "$xbI -u" when 		['-Su', '--upgrade'];
  $action = "$xbI -Su" when 	['-Syu'];
	
	$action = "$xbI -S" when		['-Sy','--refresh'];
	
  $action = "$xbQ -Rs"	when	['-Ss', '--search'];

	default						 	{ usage();exit 0; }
}


sub xbps{
	exec("@_");
}

xbps($action, $cmd);
