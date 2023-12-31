% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ClusteringMethods.R
\name{clusterTSS}
\alias{clusterTSS}
\alias{clusterTSS,TSSr-method}
\title{Cluster TSSs into tag clusters}
\usage{
clusterTSS(object, method = "peakclu", peakDistance=100,extensionDistance=30
, localThreshold = 0.02,clusterThreshold = 1, useMultiCore=FALSE, numCores=NULL)

\S4method{clusterTSS}{TSSr}(
  object,
  method = "peakclu",
  peakDistance = 100,
  extensionDistance = 30,
  localThreshold = 0.02,
  clusterThreshold = 1,
  useMultiCore = FALSE,
  numCores = NULL
)
}
\arguments{
\item{object}{A TSSr object}

\item{method}{Clustering method to be used for clustering: "peakclu". Default is "peakclu".}

\item{peakDistance}{Minimum distance of two neighboring peaks. Default value = 100.}

\item{extensionDistance}{Maximal distance between peak and its neighboring TSS or two
neighboring TSSs to be grouped in the same cluster. Default value = 30.}

\item{localThreshold}{Ignore downstream TSSs with signal < localThreshold*peak within
clusters, which is used to filter TSS signals brought from possible recapping events,
or sequencing noise. Default value = 0.02.}

\item{clusterThreshold}{Ignore clusters if signal < clusterThreshold. Default value = 1.}

\item{useMultiCore}{Logical indicating whether multiple cores are used (TRUE) or not (FALSE).
Default is FALSE.}

\item{numCores}{Number of cores are used in clustering step. Used only if useMultiCore = TRUE.
Default is NULL.}
}
\value{
Large List of elements - one element for each sample
}
\description{
Clusters TSSs within small genomic regions into tag clusters (TCs)
using "peakclu" method. "peakclu" method is an implementation of peak-based clustering.
The minimum distance of two neighboring peaks can be specified.
}
\examples{
\donttest{
data(exampleTSSr)
clusterTSS(exampleTSSr, method = "peakclu",clusterThreshold = 1,
useMultiCore=FALSE, numCores = NULL)
}

}
