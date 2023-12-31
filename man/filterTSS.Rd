% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilteringMethods.R
\name{filterTSS}
\alias{filterTSS}
\alias{filterTSS,TSSr-method}
\title{Filter raw TSS counts or normalized TSS}
\usage{
filterTSS(object, method = "poisson", normalization = TRUE,
pVal =0.01, tpmLow = 0.1)

\S4method{filterTSS}{TSSr}(
  object,
  method = "poisson",
  normalization = TRUE,
  pVal = 0.01,
  tpmLow = 0.1
)
}
\arguments{
\item{object}{A TSSr object.}

\item{method}{Method to be used for TSS filtering: "poisson" or "TPM". "poisson" can be used
only if the input TSS data in raw number of counts.}

\item{normalization}{Define whether normalization data to TPM.
Used only if method = “poisson”. Default is TRUE.}

\item{pVal}{Used only if method = "poisson". Default value is 0.01.}

\item{tpmLow}{Used only if method = "TPM". Default value is 0.1.}
}
\value{
Large List of elements - one element for each sample
}
\description{
Filters transcriptional or sequencing noise.
}
\examples{
data(exampleTSSr)
filterTSS(exampleTSSr, method = "TPM", tpmLow=0.1)
}
