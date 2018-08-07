#!/usr/bin/perl -w
 
use strict; 
use warnings;
use vars qw($opt_h);
use Getopt::Std;
use Getopt::Long;
GetOptions( "h" => \my $help);
 
#------- HELP ------#
 
if ($help){
    system "clear";
    HelpMenu();
    exit;
}
 
#------------------#
 
sub HelpMenu {
    print "This script required: Wget command, Gunzip, Perl version 5.18.2, and at least 6GB of stockage.
 
# ============================================================================== #
  
# The user can choose between 2 humans reference genome: GRCh37 or GRCh38.
# You are able to change it in the option menu. 
  
# The user can choose between 22 human chromosomes (excluding X and Y).
# You can specify the chromosome studied in the option menu.
  
# The script can randomized the chromosome choosen by two different algorithms: JustRandomized or SameFrequencies.
# JustRandomized: Replace nucleotide's sequencies by random nucleotides with an apparition's frequency equal to 1/4 each.
# SameFrequencies: Compute the apparition's frequency for the chromosome studied.
  
# The actual version fix gene, exon, miRNA, transcript, primary_transcript, pseudogene...
 
# An example of command line: ./RandomSequence.pl GRCh38 3 gene SameFrequencies
  
# ============================================================================== #\n\n\n";
}
 
# Required: Wget, Gunzip, Perl version 5.18.2 and at least 6GB of hard drive space
# The script was created and used with BioLinux (http://environmentalomics.org/bio-linux/)

# Command line example: cd /pathToRandomSequence.pl && chmod 751 *.pl && ./RandomSequence.pl GRCh37 22 gene SameFrequencies

# ============================================================================== #

# if the number of input arguments is lower than 4
# return a message showing the error
 
if ($#ARGV == -1) # If no arguments are passed
{
    print "No arguments passed.\n";
    print "An example of a commande line: ./RandomSequence.pl GRCh37 22 gene SameFrequencies\n";
    print "You can use these parameters:\n";
    print "\tGRCh38 (most recent human genome) or GRCh37\n";
    print "\t1 to 22 (chromosome number, chromosome 22 for example) ";
    print "The region to protect against randomization. \n\tFor example: gene, exon, miRNA, pseudogene... \n";
    print "\tJustRandomized (a basic model to randomized the chromosome) OR SameFrequencies (a complexe model near to the real)\n";
    print "\n\nYou also can use -h to have some help. (./RandomSequence.pl -h)\n";
    sleep(5);
    exit(1);
}
elsif (scalar(@ARGV) < 4) # if the number of input arguments is lower than 4
{
    print "Not enought parameters\n";
    print "An example of a commande line: ./RandomSequence.pl GRCh37 22 gene SameFrequencies\n";
    print "You can use these parameters:\n";
    print "\tGRCh38 (most recent human genome) or GRCh37\n";
    print "\t1 to 22 (chromosome number, chromosome 22 for example) ";
    print "The region to protect against randomization. \n\tFor example: gene, exon, miRNA, pseudogene... \n";
    print "\tJustRandomized (a basic model to randomized the chromosome) OR SameFrequencies (a complexe model near to the real)\n";
    print "\n\nYou also can use -h to have some help. (./RandomSequence.pl -h)\n";
    sleep(5);
    exit(1);
}

# ============================================================================== #

# Validation of the name of the fourth argument passed by the user
# $ARGV[3] could be "SameFrequencies" or "JustRandomized"

my %goodModelJust;
my @goodModelJust = ("JustRandomized", "JUST", "Just_Randomized", "JustRandmized", "JustRandmize", "Just_Randmized", "Just_Randomize", "just", "Randomized", "Randomize", "Just-Randmized", "Just-Randmize", "Justrandmized", "justrandmized", "justRandmized", "just-Randmized", "just_randmize", "just_randmized");

foreach (@goodModelJust) {
	$goodModelJust{$_} = 1;
}

my %goodModelSame;
my @goodModelSame = ("SameFrequencies", "SameFrequencie", "Same-Frequencie", "Same_Frequencie", "same", "samefrequencies", "same-frequencies", "same_frequencies", "Same", "SAME", "same_frquencies", "samefrquencies", "same_frquencies", "samfrquencies", "sam", "Sam", "samefreq", "same-freq", "same_freq", "SameFrequenci", "samefrequenci", "Samefrequenci", "SameFrequency", "SameFrequenciess");

foreach (@goodModelSame) {
	$goodModelSame{$_} = 1;
}

# if the argument is not present in the list then print an error message and exit the program
if (!exists $goodModelJust{$ARGV[3]} && !exists $goodModelSame{$ARGV[3]}) {
 	print "$ARGV[3] is not a good option. You can use:\n";
 	print "\tJustRandomized\n\tSameFrequencies\n";
 	exit(1);
}


# ============================================================================== #

# Validation of the name of the third argument passed by the user
# $ARGV[2] could be "gene" or "transcrit" or "pseudogene" ...

my %goodOption;
my @goodOption = ("region", "Y_RNA", "transcript", "D_loop", "primary_transcript", "gene", "ncRNA", "tRNA", "exon", "sequence_feature", "RNase_P_RNA", "cDNA_match", "CDS", "miRNA", "vault_RNA", "SRP_RNA", "RNase_MRP_RNA", "snRNA", "match", "antisense_RNA", "snoRNA", "mRNA", "telomerase_RNA", "lnc_RNA", "rRNA");

foreach (@goodOption) {
	$goodOption{$_} = 1;
}

# if the argument is not present in the list then print an error message and exit the program
if (!exists $goodOption{$ARGV[2]}) {
 	print "$ARGV[2] is not a good option. You can use:\n";
 	foreach (@goodOption) {
		print "\t$_\n";
	}
 	exit(1);
}


# ============================================================================== #

# Download and decompress the human genome chosen by the user

OUT: 
{
    my $cmd;
    if (lc($ARGV[0]) eq lc("GRCh37")) # User choose GRCh37
    {
        if (-e "GRCh37.fasta")
        {
            print "GRCh37.fasta already present in your hard drive\n";
            last OUT; 
        }
        elsif (-e "GRCh37_latest_genomic.fna")
        {
            print "GRCh37_latest_genomic.fna already present in your hard drive\n";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh37_latest_genomic.fna > GRCh37.fasta);
            system($cmd);
            print "GRCh37.fasta created\n";
            last OUT;   
        }
        elsif (-e "GRCh37_latest_genomic.fna.gz")
        {
            print "GRCh37_latest_genomic.fna.gz already present in your hard drive\n";
            system "gunzip GRCh37_latest_genomic.fna.gz";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh37_latest_genomic.fna > GRCh37.fasta);
            system($cmd);
            print "GRCh37.fasta created\n";
            last OUT;   
        }
        else
        {
            print "Downloading complete human genome GRCh37\n";
            system "wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz";
            print "Unzip the genome...\n";
            system "gunzip GRCh37_latest_genomic.fna.gz";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh37_latest_genomic.fna > GRCh37.fasta);
            system($cmd);
            print "GRCh37.fasta created\n";
            last OUT;
        }
    }
    elsif (lc($ARGV[0]) eq lc("GRCh38")) # User choose GRCh38 
    {
        if (-e "GRCh38.fasta") 
        {
            print "GRCh38.fasta already present in your hard drive\n";
            last OUT; 
        }
        elsif (-e "GRCh38_latest_genomic.fna")
        {
            print "GRCh38_latest_genomic.fna already present in your hard drive\n";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh38_latest_genomic.fna > GRCh38.fasta);
            system($cmd);
            print "GRCh38.fasta created\n";
            last OUT;   
        }
        elsif (-e "GRCh38_latest_genomic.fna.gz")
        {
            print "GRCh38_latest_genomic.fna.gz already present in your hard drive\n";
            system "gunzip GRCh38_latest_genomic.fna.gz";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh38_latest_genomic.fna > GRCh38.fasta);
            system($cmd);
            print "GRCh38.fasta created\n";
            last OUT;   
        }
        else
        {
            print "Downloading complete human genome GRCh38\n";
            system "wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz";
            print "Unzip the genome...\n";
            system "gunzip GRCh38_latest_genomic.fna.gz";
            $cmd = q(awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" }END { printf "%s", n }' GRCh38_latest_genomic.fna > GRCh38.fasta);
            system($cmd);
            print "GRCh38.fasta created\n";
            last OUT;
        }
    }
    else # If the user do not give the good version of the human genome, print an error message and exit the program
    {
        print "You need to give a good human genome reference (GRCh37 or GRCh38)\n";
        exit(1);
    }
}
 
# ============================================================================== #
 
# Search for chromosome choosen by the user 
 
print "\nOpen human genome file\n;";
 
my $completeSequenceName;
my $sequence;
my $fileName;
 
if (0 < $ARGV[1] && $ARGV[1] <= 22) # Check that the chromosome number is between 1 and 22
{
	# We recover the name of the file according to the argument given in parameter by the user
    if (lc($ARGV[0]) eq lc("GRCh37")) 
    {
        $fileName = "GRCh37.fasta";
    }
    elsif(lc($ARGV[0]) eq lc("GRCh38"))
    {
        $fileName = "GRCh38.fasta"; 
    }
    else
    {
        print "You need to give a good human genome reference (GRCh37 or GRCh38)\n";
        exit(1);
    }
    
    # open the human genome file
    open(HUMANGENOME, "< $fileName")||die "impossible to open $fileName\n"; # Open the good file genome
    STOP: 
    {
    	# Read the the human genome until the end of file
        while (<HUMANGENOME>) 
        {
        	# If the line start with ">" take the line
            if (/^>/) 
            {
                $completeSequenceName = $_;
                $sequence = <HUMANGENOME>;
 
 				# if the line is composed by "chromosome $ARGV[1]" ($ARGV[1] is the number of chromosome given by the user in the command line)
                if (/chromosome $ARGV[1]/) 
                {
                    # print "Your sequence name: $completeSequenceName\n";
                    # print "The complete sequence: $sequence\n";
 
                    # We can Stop the process, because the Human genome is sorted. So, the first sequence is the good one. 
                    # The others are only scaffold sequences. 
                    last STOP; # ------------------>
                }                                   #|
            }                                       #|
        }                                           #|
    } # <-------------------------------------------
}
else # if the chromosome number is not between 1 and 22, print an error message
{
    print "You need to give a good number for your chromosome\n";
    exit(1);
}
 
# ============================================================================== #
 
# Add the gff file to know the position of the region choosen by the user (such as "gene" region).
 
OUT: 
{
    print "GFF file searching...\n";
    if (lc($ARGV[0]) eq lc("GRCh37")) # User choose GRCh37
    {
        if (-e "GRCh37_latest_genomic.gff") 
        {
            print "GRCh37_latest_genomic.gff already present in your hard drive\n";
            last OUT; 
        }
        elsif (-e "GRCh37_latest_genomic.gff.gz")
        {
            print "GRCh37_latest_genomic.gff.gz already present in your hard drive\n";
            print "Unzip the gff file...\n";
            system "gunzip GRCh37_latest_genomic.gff.gz";
            last OUT; 
        }
        else
        {
            print "Downloading gff file for GRCh37\n";
            system "wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.gff.gz";
            print "Unzip the gff file...\n";
            system "gunzip GRCh37_latest_genomic.gff.gz";
            last OUT; 
        }
    }
    elsif (lc($ARGV[0]) eq lc("GRCh38")) # User choose GRCh38
    {
        if (-e "GRCh38_latest_genomic.gff") 
        {
            print "GRCh38_latest_genomic.gff already present in your hard drive\n";
            last OUT; 
        }
        elsif (-e "GRCh38_latest_genomic.gff.gz")
        {
            print "GRCh38_latest_genomic.gff.gz already present in your hard drive\n";
            print "Unzip the gff file...\n";
            system "gunzip GRCh38_latest_genomic.gff.gz";
            last OUT; 
        }
        else
        {
            print "Downloading gff file for GRCh38\n";
            system "wget ftp://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.gff.gz";
            print "Unzip the gff file...\n";
            system "gunzip GRCh38_latest_genomic.gff.gz";
            last OUT; 
        }
    }
    else # If the user do not give the good version of the human genome, print an error message and exit the program
    {
        print "You need to give a good human genome reference (GRCh37 or GRCh38)\n";
        exit(1);
    }
}
 
# ============================================================================== #
 
#Creation of the Hash table to know where are the positions of region, like gene, in a specific chromosome. 

my %hash;
 
if (0 < $ARGV[1] && $ARGV[1] <= 22) # Check that the chromosome number is between 1 and 22
{
    # The user sequence name -> $completeSequenceName
    # The user sequence      -> $sequence
    print "Your sequence: $completeSequenceName\n";

    my $gffFileName; #Name of the file gff

    # We recover the name of the file according to the argument given in parameter by the user
    if (lc($ARGV[0]) eq lc("GRCh37")) 
    {
        $gffFileName = "GRCh37_latest_genomic.gff";
    }
    elsif (lc($ARGV[0]) eq lc("GRCh38"))
    {
        $gffFileName = "GRCh38_latest_genomic.gff";
    }
    else
    {
        print "You need to give a good human genome reference (GRCh37 or GRCh38)\n";
        exit(1);
    }

    open(REFGENOME, "< $gffFileName")||die "impossible to open $gffFileName\n"; # Open the gff file
 
 	# We split the complete sequence name recover in the human genome file to be compatible with the one in the GFF file
    my @tmp = split(/ /, $completeSequenceName);
    my $seqName = $tmp[0];
    $seqName = substr($seqName, 1);
    #print "$seqName\n";
 
    while (<REFGENOME>) # Read the gff file until the end of file
    {
    	# if the line start with the pattern below
        if (/^$seqName\t\S+\t$ARGV[2]\t(\d+)\t(\d+)/) 
        {
            # print "$1\t$2\n";
            $hash{$1-1} = $2-1;
        }
    }
}
else # if the chromosome number is not between 1 and 22, print an error message
{
    print "You need to give a good number for your chromosome\n";
    exit(1);
}

# ============================================================================== #

# Randomization of the chromosome

# Creating the output file names
my $sequenceRealChromosomeFile = "chromosome"."$ARGV[1]".".fasta";
my $outfile = "RandomChromosome"."$ARGV[1]".".fasta";

OUT:
{
    my $sequenceRandom = $sequence;
    my @nucleotides = ('A', 'C', 'G', 'T');
    my $total = @nucleotides;

    # If the user chooses the JustRandmized model
    if (exists $goodModelJust{$ARGV[3]}) 
    {
        print "\nLaunch of the randomization with Just Randomized Model\n";
        print "======================================================\n";
 
        for (my $var = 0; $var < length($sequenceRandom); $var++) 
        {
            if (exists($hash{$var})) # if the key $var exist (the key of the hash is the start of the gene)
            {
                my $temp2 = $var;       # save $var
                $var = $hash{$temp2};   # change the value of $var by the value of hash (the value of the hash is the end of the gene)
                delete($hash{$temp2});  # delete the key for a faster script (no need to look in this key already used) 
            }
            else
            {
            	# The nucleotide read is replaced by a new nucleotide selected randomly
                substr($sequenceRandom, $var, 1) = $nucleotides[rand $total];
            }
        }
        print "Randomization end\n";
 
        # Open the output file and print the random chromosome in it
        open(OUTPUT, "> $outfile")||die "impossible to open $outfile\n";
        print OUTPUT $completeSequenceName, "\n", $sequenceRandom, "\n";

        # Open another output file and print the real chromosome in it
        open(CHROMOSOME, "> $sequenceRealChromosomeFile") ||die "impossible to write in the $sequenceRealChromosomeFile file\n"; 
        print CHROMOSOME $completeSequenceName, "\n", $sequence, "\n";
        
        print "Results write in $outfile\n";
        last OUT;
    }

    # If the user chooses the SameFrequencies model
    elsif (exists $goodModelSame{$ARGV[3]})
    {
        print "\nLaunch of the randomization with Same Frequencies Model\n";
        print "===============================================================\n";

        # Create counter for nucleotides
        my $A = 0; 
        my $C = 0; 
        my $G = 0; 
        my $T = 0; 
        my $N = 0; 
        my $totalNucleotides = 0;

        # Initialisation of my variables
        my $temp2; 		# Temporary variable
        my $temp3; 		# Temporary variable
        my $var = 0;	# Variable to browse the nucleotide sequence
        my $rand100;	# Variable for the random number
        my $i = 0;		# Variable to process another loop
        
        # for the lenght of the random sequence
        for ($var; $var < length($sequenceRandom); $var++) 
        {
        	# put the nucleotide in a temporary variable
            $temp3 = substr($sequenceRandom, $var, 1);
            # print $temp3, "\n";
         
            if (exists($hash{$var})) # if the key $var exist (the key of the hash is the start of the gene)
            {
            	# Check that the total number of nucleotides is not 0 to avoid division by 0
                if($totalNucleotides != 0)
                {
                    $A = ($A / $totalNucleotides)*100;
                    # print "$A\n";
                    $T = ($T / $totalNucleotides)*100;
                    # print "$T\n";
                    $C = ($C / $totalNucleotides)*100;
                    # print "$C\n";
                    $G = ($G / $totalNucleotides)*100;
                    # print "$G\n";
                    $N = ($N / $totalNucleotides)*100;
                    # print "$N\n";

                    $i = $var - $totalNucleotides;
                    for ($i; $i < $var; $i++)
                    {
                        $rand100 = rand(100);
                        if ($rand100 <= $A-1)
                        {
                            substr($sequenceRandom, $i, 1) = 'A';
                        }
                        elsif ($rand100 <= ($A+$T)-1)
                        {
                            substr($sequenceRandom, $i, 1) = 'T';
                        }
                        elsif ($rand100 <= ($A+$T+$C)-1)
                        {
                            substr($sequenceRandom, $i, 1) = 'C';
                        }
                        elsif ($rand100 <= ($A+$T+$C+$G)-1)
                        {
                            substr($sequenceRandom, $i, 1) = 'G';
                        }
                        else
                        {
                            substr($sequenceRandom, $i, 1) = 'N';
                        }
                    }
                }
                $temp2 = $var;      	# save $var
                $var = $hash{$temp2};   # change the value of $var by the value of hash (the value of the hash is the end of the gene)
                delete($hash{$temp2});  # delete the key for a faster script (no need to look in this key already used) 
                 
                # reset counters
                $A = 0;
                $G = 0;
                $C = 0;
                $T = 0;
                $N = 0;
                $totalNucleotides = 0;
            }
            else # if the key $var not exist in the hash, then, increment the counters depending of the nucleotide
            {
                if (lc($temp3) eq lc('A')) {
                    $A++;
                }
                elsif (lc($temp3) eq lc('G')) {
                    $G++;
                }
                elsif (lc($temp3) eq lc('C')) {
                    $C++;
                }
                elsif (lc($temp3) eq lc('T')) {
                    $T++;
                }
                else{
                    $N++;
                }
                $totalNucleotides++;
            }
        }

        # At this moment, we traveled all the chromosome until the last lock region. 
        # But, if after the last region there remain nucleotides, these will not be randomize.
        # So, we must lauch another time the randomization for the remain nucleotides.
        if($totalNucleotides != 0)
        {
            $A = ($A / $totalNucleotides)*100;
            # print "$A\n";
            $T = ($T / $totalNucleotides)*100;
            # print "$T\n";
            $C = ($C / $totalNucleotides)*100;
            # print "$C\n";
            $G = ($G / $totalNucleotides)*100;
            # print "$G\n";
            $N = ($N / $totalNucleotides)*100;
            # print "$N\n";

            $i = $var - $totalNucleotides;
            for ($i; $i < $var; $i++)
            {
                $rand100 = rand(100);
                if ($rand100 <= $A-1)
                {
                    substr($sequenceRandom, $i, 1) = 'A';
                }
                elsif ($rand100 <= ($A+$T)-1)
                {
                    substr($sequenceRandom, $i, 1) = 'T';
                }
                elsif ($rand100 <= ($A+$T+$C)-1)
                {
                    substr($sequenceRandom, $i, 1) = 'C';
                }
                elsif ($rand100 <= ($A+$T+$C+$G)-1)
                {
                    substr($sequenceRandom, $i, 1) = 'G';
                }
                else
                {
                    substr($sequenceRandom, $i, 1) = 'N';
                }
            }
        }

        print "Randomization end\n"; 

        # Open the output file and print the random chromosome in it
        open(OUTPUT, "> $outfile")||die "impossible to open $outfile\n";
        print OUTPUT $completeSequenceName, "\n", $sequenceRandom, "\n";

        # Open another output file and print the real chromosome in it
        open(CHROMOSOME, "> $sequenceRealChromosomeFile") ||die "impossible to write in the chromosome.fasta file\n"; 
        print CHROMOSOME $completeSequenceName, "\n", $sequence, "\n";
        
        print "Results write in $outfile\n";
        last OUT;
    }
    else # If the user do not give the good fourth argument
    {
        print "Error in the 4th argument in command line\n";
        print "You should write the good model to randomized\n";
        print "The two choice possible are:\n\tSameFrequencies\n\tJustRandomized\n";
        last OUT;
    }
}


# ============================================================================== #

# Installing the tools if they are not present on the computer. 
# We install ORF Finder, GeneMark, FIMO, as well as all dependancies (python, R, YAML ...)

# Variable contening the path to home 
my $home = `cd && pwd`;
chomp($home);

if (-e "install_tools.pl") # If the file "install_tools.pl" exist 
{
    system "chmod 777 *.pl";
    system "./install_tools.pl";
}
else # If the file "install_tools.pl" not exist 
{
    my $pwd = `pwd`;
    print "You do not have install_tools.pl in $pwd\n";
    print "Drop install_tools.pl in your directory\n\t$pwd\n";
    sleep(5);
    exit(1);
}

# ============================================================================== #

print "\nPrediction & comparison of the activities of the real chromosome $ARGV[1] with the random chromosome $ARGV[1]\n";

# ============================================================================== #

print "\n==============================================================================\n";

print "\nGene prediction in Eukaryotes with GeneMark-ES\n";

# Grab the number of CPUs in the laptop
chomp(my $cpu = `grep -c -P '^processor\\s+:' /proc/cpuinfo`);

print "\tPrediction for real chromosome $ARGV[1]\n";
system "./GeneMark/gmes_petap.pl --ES --sequence $sequenceRealChromosomeFile --cores $cpu";
system "mv ./output ./out_GeneMark_real_chromosome_$ARGV[1]";

print "\tPrediction for random chromosome $ARGV[1]\n";
system "./GeneMark/gmes_petap.pl --ES --sequence $outfile --cores $cpu";
system "mv ./output ./out_GeneMark_random_chromosome_$ARGV[1]";

print "\nEND: Gene prediction in Eukaryotes with GeneMark-ES\n";

# ============================================================================== #

# print "\n==============================================================================\n";

# print "\nORF prediction with ORFfinder\n";

# print "\tPrediction of ORF for real chromosome $ARGV[1]\n";
# system "./ORF_Finder/ORFfinder -in $sequenceRealChromosomeFile -g 2 -out ORFRealChromosome$ARGV[1].fasta";

# chomp(my $numberORFRealChromosome = `grep -c "^>" ORFRealChromosome$ARGV[1].fasta`);
# print "Prediction of ", $numberORFRealChromosome, " ORFs\n";


# print "\tPrediction of ORF for random chromosome $ARGV[1]\n";
# system "./ORF_Finder/ORFfinder -in $outfile -g 2 -out ORFRandomChromosome$ARGV[1].fasta";

# chomp(my $numberORFRandomChromosome = `grep -c "^>" ORFRandomChromosome$ARGV[1].fasta`);
# print "Prediction of ", $numberORFRandomChromosome, " ORFs\n";

# print "\nEND: ORF prediction with ORFfinder\n";

# ============================================================================== #

print "\n==============================================================================\n";

print "\nProtein Binding sites prediction with FIMO\n";

print "\tPrediction of TFBS for real chromosome\n";
system "$home/meme/bin/fimo --oc ./out_fimo_real_chromosome_$ARGV[1] ./Database/HOCOMOCOv11_core_HUMAN_mono_meme_format.meme $sequenceRealChromosomeFile";

print "\tPrediction of TFBS for random chromosome\n";
system "$home/meme/bin/fimo --oc ./out_fimo_random_chromosome_$ARGV[1] ./Database/HOCOMOCOv11_core_HUMAN_mono_meme_format.meme $outfile";

print "\nEND: Protein Binding sites prediction with FIMO\n";

# ============================================================================== #

# Resume data

# Files to write resume table of name and lenght of each genes
open(RESUMEREALCHROMOSOME, "> resumeRealChromosome$ARGV[1].csv") || die "impossible to open resumeRealChromosome$ARGV[1].csv\n";
print RESUMEREALCHROMOSOME "namegene,length\n";

#Command system to know all the files in the directory output/gmhmm/*
my $numberOfFilesReal = `find ./out_GeneMark_real_chromosome_$ARGV[1]/gmhmm/* | wc -l`;
my $counterGeneMarkReal = 0;

for (my $i = 1; $i < $numberOfFilesReal+1; $i++) {
    open(GENEMARRK, "< ./out_GeneMark_real_chromosome_$ARGV[1]/gmhmm/dna.fa_$i.out") || die "impossible to open dna.fa_$i.out\n";
    while (<GENEMARRK>) # Read the gff file
    {
        if (/^>(\S+)/) 
        {
            my @tmp5 = split(/\|/, $1);
            my @tmp6 = split(/\_/, $tmp5[2]);
            print RESUMEREALCHROMOSOME $counterGeneMarkReal, ",", $tmp6[0], "\n";
            $counterGeneMarkReal++;
        }
    }
    close(GENEMARRK);
}

# Files to write resume table of name and lenght of each genes
open(RESUMERANDOMCHROMOSOME, "> resumeRandomChromosome$ARGV[1].csv") || die "impossible to open resumeRandomChromosome$ARGV[1].csv\n";
print RESUMERANDOMCHROMOSOME "namegene,length\n";

#Command system to know all the files in the directory output/gmhmm/*
my $numberOfFilesRandom = `find ./out_GeneMark_random_chromosome_$ARGV[1]/gmhmm/* | wc -l`;
my $counterGeneMarkRandom = 0;

for (my $i = 1; $i < $numberOfFilesRandom+1; $i++) {
    open(GENEMARRK, "< ./out_GeneMark_random_chromosome_$ARGV[1]/gmhmm/dna.fa_$i.out") || die "impossible to open dna.fa_$i.out\n";
    while (<GENEMARRK>) # Read the gff file
    {
        if (/^>(\S+)/) 
        {
            my @tmp5 = split(/\|/, $1);
            my @tmp6 = split(/\_/, $tmp5[2]);
            print RESUMERANDOMCHROMOSOME $counterGeneMarkRandom, ",", $tmp6[0], "\n";
            $counterGeneMarkRandom++;
        }
    }
    close(GENEMARRK);
}

# Print the number of predicted genes
print "Number of predicted genes in real chromosome: \t$counterGeneMarkReal\n";
print "Number of predicted genes in random chromosome: \t$counterGeneMarkRandom\n";

# Create box plot for real & random chromosome
system "Rscript ./boxplotReal.R resumeRealChromosome$ARGV[1].csv $ARGV[1]"; 
system "Rscript ./boxplotRandom.R resumeRandomChromosome$ARGV[1].csv $ARGV[1]"; 

# Create histogram for real & random chromosome
system "Rscript ./barplot.R $counterGeneMarkReal $counterGeneMarkRandom $ARGV[1]";

print "\nEND\n";
