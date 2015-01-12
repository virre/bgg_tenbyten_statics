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
    package Users;
    use Moose;

    sub addUser {
	my $filename = '.users';
	open (my $fh, '>', $filename) or die ('Could not write to file');
	print $fh "$_[0] => $_[1]\n";
    }


    sub getUsers {
	My $self = shift;
	my $Xml_raw = callBggApi('boardgame/', $_[0], $_[1]);
	my $parser = new XML::Simple;
	my $dom = $parser->XMLin($xml_raw, ForceArray => 1);
	my $result = scalar($dom->{boardgame});
	return $result;
    }

    no Moose;
}

1; 
