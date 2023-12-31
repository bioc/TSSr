% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExportMethods.R
\name{plotCorrelation}
\alias{plotCorrelation}
\alias{plotCorrelation,TSSr-method}
\title{Pairwise scatter plots and correlations of TSS signal}
\usage{
plotCorrelation(object, samples = "all")

\S4method{plotCorrelation}{TSSr}(object, samples = "all")
}
\arguments{
\item{object}{A TSSr object.}

\item{samples}{Specify samples to be plotted. Can be either "all" to plot all samples in the object
or a subset of samples in the object. Default is "all".}
}
\value{
pairwise correlations visualized in a graph
}
\description{
Calculates the pairwise correlation coefficients between samples and
creates a matix showing pairwise scatter plots and correlation coefficients.
}
\examples{
data(exampleTSSr)
#plotCorrelation(exampleTSSr, samples = "all")

}
