% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/findMethylatedCytosines.R
\name{findMethylatedCytosines}
\alias{findMethylatedCytosines}
\title{Highlighting all Methylated Cytosines}
\usage{
findMethylatedCytosines(orig, bisulfite)
}
\arguments{
\item{orig}{A string of nucleotides of the original DNA sequence with no
modifications, meaning before bisulfite conversion}

\item{bisulfite}{A string of nucleotides of the DNA sequence after
bisulfite conversion}
}
\value{
A visual output of all nucleotides given, where the methylated
cytosines are highlighted.
}
\description{
A function that returns a visual output highlighting all methylated cytosines.
}
\examples{
\dontrun{
findMethylatedCytosines(MethylationObservation$originalDNA,
    MethylationObservation$bisulfite)
}

}
\references{
Kevin Ushey, JJ Allaire, Hadley Wickham and Gary Ritchie (2020). rstudioapi:
Safely Access the RStudio API. R package version 0.13.
https://CRAN.R-project.org/package=rstudioapi
}
