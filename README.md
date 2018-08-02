
# Random Chromosome Project
This is the source code to randomize a human chromosome. 
## Required

To run it locally, you will need to install the latest versions of Wget command, gunzip, Perl version 5.18 or later, and you will need at least 6GB of stockage. Perl is a high-level programming language that comes installed by default in Ubuntu.
You can copy/paste the code below: 

```shell
sudo apt-get update
sudo apt-get install wget
sudo apt-get install gzip
```

The script was created and used on [BioLinux](http://environmentalomics.org/bio-linux/), [Ubuntu (version 14.04 LTS & 18.04 LTS)](https://www.ubuntu.com/) and [Debian 9.5](https://www.debian.org/). 

## How to use it

The code can be launched with a command line.  

Download the project: 

```shell
sudo apt install git-all
cd ~
git clone https://github.com/Deguise/RandomChromosomeProject.git
```

You must go to the directory containing the file `RandomSequence.pl` and then, apply a `chmod` to change the permissions of the file, to be able to run it after. 
```shell
cd ~/RandomChromosomeProject 
chmod 751 RandomSequence.pl  
```

Now, you can use `-h` to play the help menu.

```shell
./RandomSequence.pl -h
```

Or, you can try `RandomSequence.pl` without any arguments to have the parameters menu.

```shell
./RandomSequence.pl
```

The command line use 4 parameters. 
1. Human genome version. User can choose between **GRCh37** or **GRCh38**.
2. The chromosome number. User can choose between **1**..**22**.
3. The region to protect against randomization. For example: **gene**, **exon**, **miRNA**, **pseudogene**... 
4. The model for the randomisation. The user can choose between **JustRandomized** (a basic model to randomized the chromosome) or **SameFrequencies** (a complexe model near to the real). 

An example of command line: 
```shell
./RandomSequence.pl GRCh38 22 gene SameFrequencies
```

## Code explanation

The steps of the code: 

1. The script gets the human genome from the NCBI (User can choose between GRCh37 or GRCh38)
2. The script gets the good chromosome from the human genome (User can choose between 1..22)
3. The script gets the GFF file linked the choosen human genome (GFF file => Map for the genome)
4. The script creates the mask from the GFF file. The mask allows us to lock regions, such as genes, exons, pseudogene or miRNA, for the randomization
5.The script randomizes the chromosome (User can choose between two models):
	- Just randomize: Each nucleotide have the same probability of occurence
	- Same frequencies: Each nucleotide has a local probability of occurence. This probability is computed by taking the pourcentage of each nucleotide between the locked regions
6. The script installs all the tools needed by the pipeline (packages, softwares, updates)
7. The script proceeds to a prediction & comparison of the activities of the real chromosome and the random chromosome
	- GeneMark-ES: Gene prediction in eukaryote 
	- ORFfinder: Prediction of ORFs (We do not use it anymore, GeneMark is faster. But, you can uncomment lines 654 to 671 if you wanted to use ORFfinder).
	- FIMO: Protein binding sites prediction (Database Hocomoco v11 Full)
8. The script creates a CSV file to resume all the data
9. The script creates plots with R some graphics to compare real vs random chromosome (boxplot and barplot)

## Help

The user can choose between 2 humans reference genome: GRCh37 or GRCh38.
You are able to change it in the option menu.
  
The user can choose between 22 human chromosomes (excluding X and Y).
You can specify the chromosome studied in the option menu.
  
The script can randomized the chromosome choosen by two different algorithms: JustRandomized or SameFrequencies.
* JustRandomized: Replace nucleotide's sequencies by random nucleotides with an apparition's frequency equal to 1/4 each.
* SameFrequencies: Compute the apparition's frequency for the chromosome studied.
  
The actual code version can lock Y_RNA, transcript, D_loop, primary_transcript, gene, ncRNA, tRNA, exon, sequence_feature, RNase_P_RNA, cDNA_match, CDS, miRNA, vault_RNA, SRP_RNA, RNase_MRP_RNA, snRNA, match, antisense_RNA, snoRNA, mRNA, telomerase_RNA, lnc_RNA and rRNA. 

## Issues

3 errors messages appear when the script is lauched:
```shell
Useless use of private variable in void context at ./RandomSequence.pl line 503.
Useless use of private variable in void context at ./RandomSequence.pl line 536.
Useless use of private variable in void context at ./RandomSequence.pl line 578.
```
**No impact on code operation**

**Statut:** Not solve
