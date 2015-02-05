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
print STDERR ("EXAMPLE: xacman -Sy tilda; xacman --refresh tilda\n");

#Operations
print STDERR ("OPERATIONS:\n");
print STDERR (" -S, --sync    Install [PACKAGE NAME]\n");
print STDERR (" -R, --remove  Remove  [PACKAGE NAME]\n");

#Sync Options
print STDERR ("Sync Options:\n");
print STDERR ("  s, --search   	Search for packages\n");
print STDERR ("  y, --refresh		Refresh package list\n");  
print STDERR ("  u, --upgrade   Update [PACKAGE NAME]\n");
}


sub xbps{         ## How I execute code
	exec("@_");
}

my $xbI = 'xbps-install';
my $xbQ = 'xbps-query';
my $xbR = 'xbps-remove';

my $action = $ARGV[0]; # Which xbps program to call

if (not $action){ 
	usage(); exit 0;}


my $args = "@ARGV[1..$#ARGV]";
my $cmd = #which term to search/remove/install
					#Pass a quotes to -Rs to list all packages
					#Pass usage guide in case of -S 
&{ sub {

	if ($ARGV[1]){
		return "$args"; #make cmd become a string of the args, quotes add spaces between args 
	}
	elsif($action eq '-Ss'){
		return '"" ';
	}
	elsif($action eq '-Sy'){
	  return "pass";
	}
	elsif($action eq '--refresh'){
		return "pass";
	}
	elsif($action eq '-Su'){
		return "pass";
	}
	elsif($action eq '-Syu'){
		return "pass";
	}
	else{
		return undef;
	}

}
}();

if (not $cmd){ #If cmd is blank, with the exceptions above (the sub) then fail.
	usage(); exit 0;}
#clear the variable so xbps doesn't try to search for it
if ($cmd eq "pass"){
	$cmd = undef;}

given ($action) { 		#Try to keep all xbps commands grouped together $xbI/xbQ/etc
											#Also can't figure out how to have multiple when conditions
											#Such as when('-s' || '--sync')
	#Xbps-install
	$action = $xbI when					['-S','--sync']; 
  $action = "$xbI -u" when 		['-Su', '--upgrade'];
  $action = "$xbI -Su" when 	['-Syu'];
	
	$action = "$xbI -S" when		['-Sy','--refresh'];
	
	#xbps-query	
  $action = "$xbQ -Rs"	when	['-Ss', '--search'];

	#xbps-remove
	$action = $xbR				when	['-R', '--remove']; 

	default						 	{ usage();exit 0; }
}



if ($cmd){
  xbps($action, $cmd);
}
else{
  xbps($action);
}
