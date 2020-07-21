# Call alleles from peak sets
genotype.N1.fsa <- function(
		x,
		threshold = 0.1
		)
	{
	# Checks
	if(!is(x, "fsa")) stop("'x' must be a 'fsa' object")
	
	# Peak table, with values
	peaks <- attr(x, "peaks")
	if(!is.data.frame(peaks))      stop("'x' must have been processed with peaks.fsa()")
	if(!"N1" %in% colnames(peaks)) stop("'x' peak table must have a N1 optional columns")
	
	# Loci
	peaks$locus <- sub("_(.+)$", "", rownames(peaks))
	peaks$allele <- sub("^(.+)_", "", rownames(peaks))
	
	# Allele is present
	attr(x, "peaks")$present <- peaks$present <- peaks$normalized >= peaks$N1 * threshold
	
	# Sort alleles
	peaks <- peaks[ order(peaks$locus, peaks$allele) ,]
	
	# Gather present alleles per locus
	peaks[ !peaks$present , "allele" ]  <- ""
	
	# Call per locus
	loci <- as.data.frame(tapply(X=peaks$allele, INDEX=peaks$locus, FUN=paste, collapse=""))
	colnames(loci)[1] <- "call"
	
	# Duplicate single-allele calls
	loci[ nchar(loci$call) == 1L , "call" ] <- paste(loci[ nchar(loci$call) == 1L , "call" ], loci[ nchar(loci$call) == 1L , "call" ], sep="")
	
	# Store in object
	attr(x, "genotypes") <- loci
	attr(x, "calls") <- loci$call
	names(attr(x, "calls")) <- rownames(loci)
	
	return(x)
}
