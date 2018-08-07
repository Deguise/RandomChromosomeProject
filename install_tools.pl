#!/usr/bin/perl
use strict;

my ($verif_GeneMark, $verif_gmKey, $verif_ORFfinder, $verif_FIMO);
my ($verif_FIMO_doc, $verif_FIMO_etc, $verif_FIMO_meme, $verif_FIMO_scripts, $verif_FIMO_src, $verif_FIMO_tests, $verif_DB);
my ($verif_python, $verif_zlib, $verif_ghost, $verif_gcc, $verif_R);
my ($error, $noError, $localError) = 0;

my $home=`cd && pwd`;
chomp $home;


while ($noError != 1){

	if ($error >= 1){
		print "[INSTALLATION] Data verification running...\n";
	}

	###################################### PACKAGE #######################################

	$verif_python=`dpkg -s python`;
	if ($verif_python){
		print "[PYTHON] Python package is already installed\n";
	}

	else{
		system "sudo apt-get install Python";
		$localError ++;
	}

	$verif_zlib=`dpkg -s zlib1g`;
	if ($verif_zlib){
		print "[ZLIB] Zlib package is already installed\n";
	}

	else{
		system "sudo apt-get install zlib";
		$localError ++;
	}

	$verif_ghost=`dpkg -s ghostscript`;
	if ($verif_ghost){
		print "[GHOSTSCRIPT] Ghostscript package is already installed\n";
	}

	else{
		system "sudo apt-get install ghostscript";
		$localError ++;
	}

	$verif_gcc=`dpkg -s gcc`;
	if ($verif_gcc){
		print "[GNU_COMPILER] GCC package is already installed\n";
	}

	else{
		system "sudo apt-get install gcc";
		$localError ++;
	}

	$verif_R=`dpkg -s r-base`;
	if ($verif_R) {
		print "[R] R-Base package is already installed\n";
	}
	else {
		system "sudo apt-get install r-base";
		$localError ++;
	}

	######################################################################################

	###################################### GENEMARK ######################################

	INSTALL_GENEMARK:
	if (-d "GeneMark") {
		$verif_GeneMark = `find GeneMark/* | wc -l`;
		if ($verif_GeneMark == 78) {
			print "[GeneMark INSTALLATION] GeneMark Software is already installed\n";
		}
		else {
			print "[GeneMark] Bad installation of GeneMark Software\n";
			print "[GeneMark] GeneMark Software is repairing\n";
			system "sleep 2";
			system "rm -R GeneMark";
			genemark_installation();
		}
	}
	else {
		system "mkdir GeneMark";
		genemark_installation();
	}

	$verif_gmKey=`find $home/.gm_key | wc -l`;
	if ($verif_gmKey != 1) {
		print "[GeneMark] Bad installation of GeneMark Software\n";
			print "[GeneMark] GeneMark Software is repairing\n";
			system "sleep 2";
			system "rm -R GeneMark";
			genemark_installation();
	}
	else {
		print "[GeneMark] gm_key location verification\n";
	}

	sub genemark_installation {
		$localError ++;
		print "\n[GeneMark INSTALLATION] GeneMark software is downloading\n";
		system "wget -P GeneMark/ https://www.dropbox.com/s/yxhbqpz820tbi49/gm_et_linux_64.tar.gz";
		print "\n[GeneMark INSTALLATION] GeneMark software is installing\n";
		system "tar -zxf GeneMark/gm_et_linux_64.tar.gz";
		system "rm GeneMark/gm_et_linux_64.tar.gz";
		system "cp -R gm_et_linux_64/gmes_petap/* GeneMark";
		system "mv GeneMark/gm_key $home/.gm_key";
		system "cp $home/.gm_key GeneMark/ && mv GeneMark/.gm_key GeneMark/gm_key";
		system "rm -R gm_et_linux_64";
		system "chmod -R 755 GeneMark/*";
		print "\n[GeneMark INSTALLATION] Installation done\n";
	}

	system "sudo cpan YAML Hash::Merge Logger::Simple Parallel::ForkManager";

	######################################################################################

	##################################### ORF FINDER #####################################

	# INSTALL_ORF:
	# if (-d "ORF_Finder") {
	# 	$verif_ORFfinder=`find ORF_Finder/ORFfinder | wc -l`;
	# 	if ($verif_ORFfinder == 1) {
	# 		print "[ORF_Find INSTALLATION] ORF_Finder Software is already installed\n";
	# 	}
	# 	else {
	# 		print "[ORF_Find] Bad installation of ORF_Finder Software\n";
	# 		print "[ORF_Find] ORF_Finder Software is reparing\n";
	# 		system "sleep 2";
	# 		system "rm -R ORF_Finder";
	# 		orffinder_installation();
	# 	}
	# }

	# else {
	# 	system "mkdir ORF_Finder";
	# 	orffinder_installation();
	# }

	# sub orffinder_installation {
	# 	print "\n[ORF_Find INSTALLATION] ORF_Finder software is Downloading\n";
	# 	system "wget -P ORF_Finder/ ftp://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/ORFfinder.gz";
	# 	print "\n[ORF_Find INSTALLATION] ORF_Finder software is installing\n";
	# 	system "gunzip ORF_Finder/ORFfinder.gz";
	# 	system "chmod -R 755 ORF_Finder/*";
	# 	print "\n[ORF_Find INSTALLATION] Installation done\n";
	# }

	######################################################################################

	######################################## FIMO ########################################

	INSTALL_FIMO:
	if (-d "$home/meme") {
		$verif_FIMO=`find $home/meme/* | wc -l`;
		if ($verif_FIMO == 684) {
			$verif_FIMO_doc=`find doc/* | wc -l`;
			$verif_FIMO_etc=`find etc/* | wc -l`;
			$verif_FIMO_meme=`find meme-5.0.1/* | wc -l`;
			$verif_FIMO_scripts=`find scripts/* | wc -l`;
			$verif_FIMO_src=`find src/* | wc -l`;
			$verif_FIMO_tests=`find tests/* | wc -l`;
			if (!-d "doc" || $verif_FIMO_doc != 16) {
				fimo_error();
			}
			elsif (!-d "etc" || $verif_FIMO_etc != 10) {
				fimo_error();
			}
			elsif (!-d "meme-5.0.1" || $verif_FIMO_meme != 2391) {
				fimo_error();
			}
			elsif (!-d "scripts" || $verif_FIMO_scripts != 54) {
				fimo_error();
			}
			elsif (!-d "src" || $verif_FIMO_src != 732) {
				fimo_error();
			}
			elsif (!-d "tests" || $verif_FIMO_tests != 64) {
				fimo_error();
			}
			elsif (!-e "build.xml"){
				fimo_error();
			}
			elsif (!-e "config.h"){
				fimo_error();
			}
			elsif (!-e "config.log"){
				fimo_error();
			}
			elsif (!-e "config.status"){
				fimo_error();
			}
			elsif (!-e "libtool"){
				fimo_error();
			}
			elsif (!-e "Makefile"){
				fimo_error();
			}
			elsif (!-e "MemeSuite.properties"){
				fimo_error();
			}
			elsif (!-e "stamp-h1"){
				fimo_error();
			}
			else {
				print "[FIMO INSTALLATION] FIMO Software is already installed\n";
			}
		}
		else {
			print "[FIMO] Meme/bin directory is corrupted\n";
			fimo_error();
		}
	}
	else {
		fimo_installation();
	}

	$verif_DB=`find Database/* | wc -l`;
	if (!-d "Database" || $verif_DB != 1) {
		fimo_database();
	}
	else {
		print "[FIMO DATABASE] Hocomoco v11 database is aleady downloaded\n";
	}

	sub fimo_installation {
		$localError ++;
		print "[FIMO INSTALLATION] FIMO software is downloading\n";
		system "wget https://www.dropbox.com/s/ip30mwr53wis8iz/meme_5.0.1.tar.gz";
		print "[FIMO INSTALLATION] FIMO software is installing\n";
		system "tar -zxf meme_5.0.1.tar.gz";
		system "rm meme_5.0.1.tar.gz";
		system "chmod -R 755 *";
		print "[FIMO INSTALLATION] Configuration\n";
		system "./meme-5.0.1/configure --prefix=$home/meme --with-url='http://meme-suite.org'";
		system "make";
		system "make test";
		system "make install";
		print "[FIMO INSTALLATION] Done\n\n";
	}

	sub fimo_database {
		$localError ++;
		print "[FIMO DATABASE] Hocomoco v11 database is downloading";
		system "wget -P Database/ https://www.dropbox.com/s/biin6nyhomnrgi9/HOCOMOCOv11_core_HUMAN_mono_meme_format.meme";
		print "[FIMO DATABASE] Hocomoco v11 database downloaded\n";
	}

	sub fimo_error {
		$localError ++;
		print "[FIMO] Bad installation of FIMO Software\n";
		print "[FIMO] FIMO Software is repairing\n";
		system "sleep 2";
		system "rm -R FIMO";
		fimo_installation();
	}


	#######################################################################################

	########################################## R ##########################################

	print "[RScript] RScript verification\n";

	if (!-e "barplot.R"){
		download_RScript();
		system "wget https://raw.githubusercontent.com/Deguise/RandomChromosomeProject/master/barplot.R";
	}
	if (!-e "boxplotRandom.R"){
		download_RScript();
		system "wget https://raw.githubusercontent.com/Deguise/RandomChromosomeProject/master/boxplotRandom.R";
	}
	if (!-e "boxplotReal.R"){
		download_RScript();
		system "wget https://raw.githubusercontent.com/Deguise/RandomChromosomeProject/master/boxplotReal.R";
	}
	if (!-e "barplotFIMO.R"){
		download_RScript();
		system "wget https://raw.githubusercontent.com/Deguise/RandomChromosomeProject/master/barplotFIMO.R";
	}

	print "[RScript] Installation done\n";

	sub download_RScript {
		$localError ++;
		print "[RScript] RScript is downloading";
	}

	if ($error >= 3){
		print "\n\n[ERROR] Pipeline can't be installed.\n[ERROR] Try later with a better internet connexion.\n\n";
		exit(1);
	}

	if ($localError != 0){
		$noError = 0;
		$error++;
		$localError = 0;
	}
	else {
		$noError = 1;
	}
}
