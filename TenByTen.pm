# Moose based Perl module for BGG API connections
# Version 0.1 
# Copyright 2014 Virre Linwendil Annergård
# Contact: virre.annergard@gmail.com
#
# This libary is released under the GNU GPL Ver 3
#
#  This program is free software: you can redistribut#e it and/or modify it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 o#f the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

{
    package Challenges;
    use Moose;
    use Data::Dumper;

    sub getChallengeLists {
	print "Searching for $_[0]\n";
	my $challengeList = BggList->new();
	return $challengeList->getBggList($_[0]);
    }


    sub getChallengers  {
	my $self = shift;
	my @list = getChallengeLists($_[0]);
	my @keys = keys ($list[0]);
	my %users; 
	foreach (@keys) {
	    if ($list[0]{$_}{'objecttype'} eq 'geeklist') {
		print "Got Challenger: $list[0]{$_}{'username'}\n";
		$users{$list[0]{$_}{'username'}} = $list[0]{$_}{'objectid'};	       
	    } 
	}
	return %users;
    }

    sub getUserChallenge {
	my $self = shift;
	my @list = getChallengeLists($_[0]);
	my %games; 
	foreach (keys ($list[0])) {
	    if ($list[0]{$_}{'subtype'} eq 'boardgame') {
		print "Getting data for $list[0]{$_}{'objectname'}\n";
		$games{$list[0]{$_}{'objectname'}} = {
		    gameName => $list[0]{$_}{'objectname'},
		    gameBodyPlayed => getPlayedAmountBody($list[0]{$_}{'body'}[0]),
		    #gameRegisteredPlayed => getPlayedAmountBGG($list[0]{$_}{'objectid'}, $list[0]{$_}{'username'}),
		    gameId => $list[0]{$_}{'objectid'},
		};
	    }
	}
	return %games;
    }
    
    sub getPlayedAmountBody {
	my $count = 0;
	if ($_[0] =~ /Progress/) {
	    my $data;
	    ($data)  = $_[0] =~ /Progress: (.*)\/10/;
	    $count = int($data);
	    return $count;
	}
	while ($_[0] =~ /:star:/g) { $count++;}
	return $count;
    }


    sub getPlayedAmountBGG {
	return $_[1];
    }
    sub getChallengeGames {
	my $self = shift;
	my $challengeList = $_[0];
	return getUserChallenge($challengeList);
    }
    no Moose;
}

{
    package challengeStatics;
    use Moose;
    use Data::Dumper;

    sub fullProcentDoneGame {
	my $self = shift;
	my $procentage;
	#print Dumper($_[0]);
	#die;
	if ($_[0] ne 0) {
	    $procentage =  $_[0] * 10 % 100;
	} else {
	    $procentage = 0; 
	}
	return $procentage;
    }

    sub currentMonthAsNumber {
	my $now = time;
	(my $sec,my $min,my $hour,my $mday,my $mon) = localtime( $now );
	my $current_month = int(sprintf( "%02d", $mon + 1 ));
	return $current_month;
    }

    sub getMonthlyAvg {
	my $self = shift;
	if ($_[0] eq 0) {
	    return 0; 
	}
	return $_[0]/$self->currentMonthAsNumber(); 
    }

    no Moose;
}

{
    package outputStatics;
    use Moose;
    use Data::Dumper;

    sub bbCode {
	my $self = shift;
	my %allPlayers = %{shift()};
	my %userStatics = %{shift()};
	my $numOfPlayers = int(scalar keys %userStatics);
	my $allPlays = 0; 
	my $totalProgressProcentage = 0; 
	my $output_string = "\n Total number of players: $numOfPlayers\n";
	$output_string .= "Total games players $allPlayers{'totalGamesPlayed'}\n";

	foreach my $user (keys %userStatics) {
	    $allPlays = 0;
	    $output_string .= "[user=$user][/user]\n";
	    foreach my $game (keys $userStatics{$user}) {
		if ($userStatics{$user}{$game}{'totalPlays'} gt 0) {
		    $output_string .= "$game have been played $userStatics{$user}{$game}{'totalPlays'} for a progress of  $userStatics{$user}{$game}{'progressProcent'}% and have a monthly average of $userStatics{$user}{$game}{'monthlyAverage'} plays\n";
		    $allPlays += $userStatics{$user}{$game}{'totalPlays'};
		} else {
		    $output_string .= "$game have not been played\n"; 
		}
	    }
	    if ($allPlays ne 0) {
		$totalProgressProcentage  =  $allPlays % 100;
	    } else {
		$totalProgressProcentage = 0;   
	    }
	    $output_string .= "The total amount of games played for $user is  $allPlays for a total progress of $totalProgressProcentage%\n\n --- \n\n"; 
	}
	$self->writeFile($output_string, 'listsource.txt');
    }


    sub writeFile {
	my $self = shift();
	my $filename = $_[1];
	open (my $fh, '>', $filename) or die("Could not write $filename");
	print $fh $_[0];
	close $fh; 
    }

}

1; 
