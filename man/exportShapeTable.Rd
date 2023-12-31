% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExportMethods.R
\name{exportShapeTable}
\alias{exportShapeTable}
\alias{exportShapeTable,TSSr-method}
\title{Export core promoter shape score tables}
\usage{
exportShapeTable(object)

\S4method{exportShapeTable}{TSSr}(object)
}
\arguments{
\item{object}{A TSSr object.}
}
\value{
core promoter shape score tables
}
\description{
Exports core promoter shape score tables to text files. Shape score is calculated with
shapeCluster(object) method.
}
\examples{
data(exampleTSSr)
#exportShapeTable(exampleTSSr)
}
