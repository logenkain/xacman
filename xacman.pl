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
	elsif(not $cmd and $action eq '-Ss'){
		return '"" ';
	}
	elsif(not $cmd and $action eq '-Sy', '--refresh'){
	  return $cmd;
	}
	elsif(not $cmd and $action eq '-S', '--sync'){
		usage(); exit 0;}
}
}();				 

given ($action) { 		#Try to keep all xbps commands grouped together
											#Also can't figure out how to have multiple when conditions
											#Such as when('-s' || '--sync')
	when ('-S') 				{$action = "$xbI";} 
	when ('--sync') 		{$action = "$xbI";}
  
	when ('-Su')				{$action = "$xbI -u";}
  when ('-Syu')				{$action = "$xbI -Su";}
  when ('--upgrade')  {$action = "$xbI -u";}

	when ('-Sy')				{$action = "$xbI -S";}
	when ('--refresh')	{$action = "$xbI -S";}
	
	when ('-Ss')				{$action = "$xbQ -Rs";} 
	when ('--search')		{$action = "$xbQ -Rs";} 

	default						 	{ usage();exit 0; }
}


sub xbps{
	exec("@_");
}

xbps($action, $cmd);
