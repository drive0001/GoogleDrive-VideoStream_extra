#!/usr/bin/perl

###
##
## The purpose of this script is to add channel mappings as provided from a TAB containing two columns (map from, map to)
###
use Getopt::Std;		# and the getopt module

use constant USAGE => $0 . ' -s target.m3u8 -t target.m3u8 -c mapping.tab';


use IO::Handle;

my %opt;
die (USAGE) unless (getopts ('s:t:c:i:',\%opt));

# directory to scan
my $source = $opt{'s'};
my $target = $opt{'t'};
my $tab = $opt{'c'};
my $incrementor =  $opt{'i'};


die(USAGE) if ($source eq '' or $target eq '' or $tab eq '');

my %channelMapping;
open (TAB, $tab) or die ("cannot open $tab: " + $!);
while (my $line = <TAB>){
	my ($from,$to) = $line =~ m%^(\S+)\s(\S+)%;
	if ($to ne '-'){
		$channelMapping{$from} = $to;
	}else{
		$channelMapping{$from} = $from;

	}

}

close(TAB);


open (INPUT, $source) or die ("cannot open $source: " + $!);
open (OUTPUT, '> '.$target) or die ("cannot create $target: " + $!);
OUTPUT->autoflush;

while (my $line = <INPUT>){

	 $line =~ s%\r%%;
	if ($line =~ m%^#EXTINF%){
		my $nextLine = <INPUT>;
		my ($channel) = $nextLine =~ m%\/(\d+)\.m3u8%;
		if ($channelMapping{$channel} ne ''){
			$toChannel = $channelMapping{$channel};
		}else{
			$channel = $channel + $incrementor;
			$toChannel = $channel;
		}
		$line =~ s% tvg-id="[^\"]+"%%;
		$line =~ s%\-1%\-1 tvg-id="$toChannel"%;
		print OUTPUT $line;
		print OUTPUT $nextLine;
		print "$line\n";
	}else{
		print OUTPUT $line;
	}


}
close(OUTPUT);
close(INPUT);




1;





