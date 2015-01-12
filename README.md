BGG 10x10 statics generator. 
---

This script was made to implement the BoardGameGeek API libary I wrote last year to build
statics for the FTL members that is beeing part of the 2015 10x10 challlenge. 

--
Useage

This script have three parts, a clone of the BGG API perl libary, a TenByTen.pm module and the plays.pl. It will generate a list of total plays, progress etc. To know where to look for those items, it will assume a master list where all items that are GeekLists will be treated as the source for one users list. The acctually command to run this is 

perl plays.pl /LISTID/ 

Right now this will generate a file named listsource.txt which will hold the data gathered and outputed with some BGG bbcode imported. 

Known Issues: 
-----
*Ignores non geeklist items in master-list. 
*Might not be able to handle users with more then one list. 
*Assumes that plays hold the pattern in code, easily fixed by chaning the regexps. 
*My maths might be off, I am more of a lingustical person then a math person.

ToDo
-------
*Fix known issues. 
*Fix output to be selectable.
*Automate upload of data? 
*Better output system? 
*Add amount of total plays. 


 License 
------
 This software is released using the GNU General Public License Version 3. See gpl-3.0.txt for more information. 

 Please note that the content you recive from BoardGameGeek might have other restrictions. 
 