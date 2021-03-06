% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/findMethylatedCytosines.R
\name{findMatchingSections}
\alias{findMatchingSections}
\title{Generate a markdown file with all methylated cytosines highlighted}
\usage{
findMatchingSections(orig, bisulfite)
}
\arguments{
\item{orig}{A string of nucleotides of the original DNA sequence with no
modifications, meaning before bisulfite conversion}

\item{bisulfite}{A string of nucleotides of the DNA sequence after bisulfite
conversion}
}
\value{
A file containing the two input DNA strands, where the methylated
cytosines are highlighted.
}
\description{
A helper function that returns a markdown file of the two input DNA strands,
where each cytosine that was methylated is highlighted
}
\details{
This function is an internal function and therefore cannot be used directly
when installing this package - it is instead a helper function for
findMethylatedCytosines
}
