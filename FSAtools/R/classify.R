# Apply a LPS-like bayesian predictor to peaks produced by peaks.fsa()
classify <- function(
		x,
		plot = TRUE
		)
	{
	# Class check
	if(!is(x, "fsa")) stop("'x' must be a 'fsa' object")
	
	# Get and checkattributes
	peaks <- attr(x, "peaks")
	model <- attr(x, "model")
	if(is.null(peaks)) stop("'x' has no 'peaks' attribute, use peaks.fsa() first")
	if(is.null(model)) stop("'x' has no 'model' attribute, use addModel() first")
	
	# Check model genes
	missingGenes <- setdiff(model$geneNames, rownames(peaks))
	if(length(missingGenes) > 0)         stop("Genes required by the model not measured : ", paste(missingGenes, collapse=", "))
	if(any(duplicated(rownames(peaks)))) stop("Duplicated gene names in peak table")
	
	# Cross data
	peaks <- peaks[ model$geneNames ,]
	peaks$T <- model$geneTs
	peaks$M <- model$geneMs
	
	# Compute score
	score <- sum(peaks$T * (peaks$normalized / peaks$M))
	
	# Compute probability
	D1 <- dnorm(score, mean=model$groupMeans[1], sd=model$groupSDs[1])
	D2 <- dnorm(score, mean=model$groupMeans[2], sd=model$groupSDs[2])
	p <- D1 / (D1 + D2)
	p <- c(p, 1 - p[1])
	names(p) <- model$groupNames
	
	# Class
	if(p[1] > model$threshold)        { class <- model$groupNames[1]
	} else if(p[2] > model$threshold) { class <- model$groupNames[2]
	} else                            { class <- as.character(NA)
	}
	
	if(isTRUE(plot)) {
		# Margins
		savePar <- par(mar=c(5,1,5,1))
		on.exit(par(savePar))
		
		# Plot model as a background
		plot(model)
		
		# Add current prediction
		abline(v=score)
		mtext(side=3, at=score, text=signif(score, 3))
		
		# Add probabilities
		if(diff(model$groupMeans) > 0) { lowest <- 1; highest <- 2;	
		} else                         { lowest <- 2; highest <- 1;	
		}
		mtext(side=3, line=2.75, adj=1, at=par("usr")[2], font=2, cex=1.5, col=ifelse(p[lowest]  >= model$threshold, model$groupColors[lowest], "darkgrey"),  text=sprintf("p(%s) = %g", model$groupNames[lowest],  signif(p[lowest], 3)))
		mtext(side=3, line=1.25, adj=1, at=par("usr")[2], font=2, cex=1.5, col=ifelse(p[highest] >= model$threshold, model$groupColors[highest], "darkgrey"), text=sprintf("p(%s) = %g", model$groupNames[highest], signif(p[highest], 3)))
	}
	
	# Store results in object
	tab <- data.frame(
		row.names = "LPS",
		score = score,
		p.1 = p[1],
		p.2 = p[2],
		class = class,
		stringsAsFactors = FALSE
	)
	colnames(tab)[2:3] <- sprintf("p.%s", model$groupNames)
	attr(x, "classification") <- tab
	
	return(x)
}

