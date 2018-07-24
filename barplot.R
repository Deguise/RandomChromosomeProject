args<-commandArgs(TRUE)
png(paste("Barplot_Chromosome.png", as.numeric(args[3]), sep="_"))
barplot(c(as.numeric(args[1]), as.numeric(args[2])), main=paste("Chromosome",as.numeric(args[3]),sep=" "), beside=TRUE, ylab="Number of Genes", names.arg=c("Real Chromosome", "Random Chromosome"), col=c("darkblue", "darkred"))
dev.off()
