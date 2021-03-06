\name{classify}
\alias{classify}
\title{
  Apply the binary predictor to FSA peaks
}

\description{
  Predict to which class the sample is most likely to belong, using a modified LPS model.
}

\usage{
  classify(x, plot = TRUE)
}

\arguments{
  \item{x}{
    A \code{fsa} object with \code{peaks} and \code{model} attributes.
}
  \item{plot}{
    Single logical value, whether to plot a visual representation of the prediction or not.
}
}

\value{
  Returns a list :
    \item{score}{The raw score used to make the prediction.}
    \item{p}{The probability to belong to each of the two groups.}
    \item{class}{The final prediction, as a group name. May be \code{NA} if no probability passes the model threshold.}
}

\references{
  Radmacher MD, McShane LM, Simon R. \cite{A paradigm for class prediction using gene expression profiles.} J Comput Biol. 2002;9(3):505-11.

  Wright G, Tan B, Rosenwald A, Hurt EH, Wiestner A, Staudt LM. \cite{A gene expression-based method to diagnose clinically distinct subgroups of diffuse large B cell lymphoma.} Proc Natl Acad Sci U S A. 2003 Aug 19;100(17):9991-6.
  
  Bohers E, Mareschal S, Bouzelfen A, Marchand V, Ruminy P, Maingonnat C, Menard AL, Etancelin P, Bertrand P, Dubois S, Alcantara M, Bastard C, Tilly H, Jardin F. \cite{Targetable activating mutations are very frequent in GCB and ABC diffuse large B-cell lymphoma.} Genes Chromosomes Cancer. 2014 Feb;53(2):144-53.  
}

\author{
  Sylvain Mareschal
}

\seealso{
  \code{\link{read.fsa}}, \code{\link{peaks.fsa}}, \code{\link{add.model}}, \code{\link{generic.process}}
}

\examples{
  # Example FSA file provided
  fsa <- read.fsa(system.file("extdata/fsa_GEP/A5918.fsa", package="FSAtools"))
  fsa <- align.fsa(fsa)
  
  # Add model from design file
  design <- designFile(system.file("extdata/design_GEP.conf", package="FSAtools"))
  fsa <- add.model(fsa, model=design$GLOBALS$MODEL)
  
  # Add peak heights
  fsa <- peaks.fsa(fsa, peaks=design$GLOBALS$PEAKS)
  
  # Classify sample
  fsa <- classify(fsa, plot=TRUE)
  print(attr(fsa, "classification"))
}

