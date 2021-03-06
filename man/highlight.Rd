% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/findCpGIslands.R
\name{highlight}
\alias{highlight}
\title{Highlighting parts of text}
\usage{
highlight(fileName, nucleotides, highlighting)
}
\arguments{
\item{fileName}{The name of the file where the markdown will be saved to}

\item{nucleotides}{A string of nucleotides of a DNA sequence}

\item{highlighting}{A boolean to say if nucleotides will be highlighted in fileName}
}
\value{
No return value but adds the markup text to the input file
}
\description{
A helper function that writes text to a file, while also adding the markup
for the text to be highlighted if desired
}
\details{
This function is an internal function and therefore cannot be used directly
when installing this package - it is instead a helper function
}
