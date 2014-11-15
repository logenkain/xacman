#!/usr/bin/perl

# todo
# I want all failures to print a command list, not the xbps default


use v5.10.0;
use warnings;
use strict;
use feature qw(switch say); #For given/when since switch is being depricated
no warnings 'experimental::smartmatch';

my $xbI = 'xbps-install';
my $xbQ = 'xbps-query';

my $action = $ARGV[0]; # Which xbps program to call

if (not $action){
	say 'call usage guide'; die;}


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
	elsif(not $cmd and $action eq '-S'){
		say 'call usage guide'; die;}
}
}();				 

given ($action) { 		#Try to keep all xbps commands grouped together
	when ('-S') 		{$action = "$xbI";} 
	when ('-Sy')		{$action = "$xbI -S";}
	when ('-Ss')		{$action = "$xbQ -Rs";} 
	default {say 'call usage guide'; die;}
}


sub xbps{
	exec("@_");
}

xbps($action, $cmd);
say('script end');
