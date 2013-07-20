#!/usr/bin/perl -w
# Program to rewrite FASTA format protein sequences to have useful names in trees
# Version 1.1.5, by Julia Philip
# Copyright University of Notre Dame
# Version 1.1 edited to deal with sequences which do not have species information
# Version 1.1.5 comments added

# Get the name of the file
print "What is the FASTA sequence file?";

$FASTA_file = <STDIN>;

chomp $FASTA_file;

#Open the file
unless(open(FASTA_FILE, $FASTA_file)){
	print "Cannot open file \"$FASTA_file\"\n\n";
	exit;
}

#Read the file into an array

@FASTA = <FASTA_FILE>;

close FASTA_FILE;

# Print the length of the array so the user can assure that the file has been read in correctly
$length = @FASTA;
print "length of array: $length. \n\n";

#Create an index for the number of sequences in the file
$index = 0;

#Create and open a new file to which the output will be written
$new = '_new.txt';

$place = length $FASTA_file;

# Get the file name before the period
if($FASTA_file =~ /\./){
	while(substr($FASTA_file, $place, 1) ne '.'){
		$place--;
	}
}

$name = substr($FASTA_file, 0, $place);

# Construct a new file name
$new_file = "$name$new";

$printnum = 0;

open(NEW_FASTA, ">$new_file");

#Loop through the provided file to find all header lines
#Then insert species identifiers at the beginning of the headers
foreach $array (@FASTA){
	# Check to see if the line is the first line of a sequence
	if (substr($array, 0, 1) eq  '>'){
		# Check to see if the line has a species name inside []
		if ($array =~ /\[/){
			# Step through the first line looking for the [
			$loc = 0;
			while(substr($array, $loc, 1) ne '['){
				$loc++;
			}
			# Get the first three charachters after the [
			$genus = substr($array, $loc +1, 3);
			# Look for the first space after the [
			while(substr($array, $loc, 1) ne ' ' ){
				$loc++;
			}
			# Get the first three charachters after the space
			$species = substr($array, $loc+1, 3);
			$index++;
			$removecarrot = substr($array, 1);
			# Construct a new line with the species name and index number and print it
			$newline = ">$genus$species$index $removecarrot";
			print NEW_FASTA "$newline";
			$printnum++;
		}
		else{
			# If there is not a species name in [], print only the index number
			$index++;
			$removecarrot = substr($array, 1);
			$newline = ">$index $removecarrot";
			print NEW_FASTA "$newline";
			$printnum++;
		}
	}
	else{
		# If the line is not the first line of a sequence, print it as is
		print NEW_FASTA "$array";
		$printnum++;
	}
}

# Print the number of lines printed so the user can make sure the printing worked
print "$printnum lines printed \n\n";

close NEW_FASTA;

exit;
