#!/usr/bin/perl

use strict;
use warnings;
use BoardGameGeek;
use TenByTen;
use Data::Dumper;

my $Challenge = Challenges->new();
my %challengers = $Challenge->getChallengers($ARGV[0]);
my %userGames; 
    #getUserChallenge($_
my $id;
foreach my $key ( keys %challengers )
{
    print "Fetching data for $key\n";
    $id = $challengers{$key};
    $userGames{$key} = {$Challenge->getUserChallenge($id)};
}

my $statics = challengeStatics->new();
my %userStatics;
my %allPlayers; 
my $played;
my $allGames = 0;
my $numOfChallengers = scalar keys %challengers;
$allPlayers{'totalToPlay'} = int($numOfChallengers) * 100;
foreach my $key (keys %challengers) {
    foreach  my $secondKey (keys  $userGames{$key}) {
	$played = $userGames{$key}{$secondKey}{'gameBodyPlayed'};
	$userStatics{$key}{$secondKey} = {
	    progressProcent => $statics->fullProcentDoneGame($played),
	    monthlyAverage => $statics->getMonthlyAvg($played),
	    totalPlays => $played, 
	};
	$allPlayers{'totalGamesPlayed'} += $played; 
    }
}


my $outputStatics = outputStatics->new();
$outputStatics->bbCode(\%allPlayers, \%userStatics);







