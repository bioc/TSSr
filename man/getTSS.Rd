% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ImportMethods.R
\name{getTSS}
\alias{getTSS}
\alias{getTSS,TSSr-method}
\title{Precisely identify TSSs from bam files, paired end bam files, bed files,
BigWig files, tss files, or tss tables.}
\usage{
getTSS(object, sequencingQualityThreshold = 10, 
mappingQualityThreshold = 20, softclippingAllowed = FALSE)

\S4method{getTSS}{TSSr}(
  object,
  sequencingQualityThreshold = 10,
  mappingQualityThreshold = 20,
  softclippingAllowed = FALSE
)
}
\arguments{
\item{object}{A TSSr object.}

\item{sequencingQualityThreshold}{Used only if inputFilesType == "bam" or
"bamPairedEnd", otherwise ignored.}

\item{mappingQualityThreshold}{Used only if inputFilesType == "bam" or
"bamPairedEnd", otherwise ignored.}

\item{softclippingAllowed}{Used only if inputFilesType == "bam" or
"bamPairedEnd". Default is FALSE.}
}
\value{
Large List of elements - one element for each sample
}
\description{
getTSS function is used to precisely identify TSSs from multiple
input file formats. The files include users' home-made alignment files (bam format)
or downloaded files from public databases. See inputFilesType for details on
the supported input file formats.
}
\examples{
\donttest{
data(exampleTSSr)
#getTSS(exampleTSSr)
}
}
