args<-commandArgs(TRUE)
png(paste("Barplot_FIMO_", as.numeric(args[3]), ".png", sep=""))
barplot(c(as.numeric(args[1]), as.numeric(args[2])), main=paste("Chromosome",as.numeric(args[3]),sep=" "), beside=TRUE, ylab="Number of TFBS", names.arg=c("Real Chromosome", "Random Chromosome"), col=c("darkblue", "darkred"))
dev.off()