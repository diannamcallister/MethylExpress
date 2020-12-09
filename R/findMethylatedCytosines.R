#' Highlighting all Methylated Cytosines
#'
#' A function that returns a visual output highlighting all methylated cytosines.
#'
#' @param orig A string of nucleotides of the original DNA sequence with no
#'     modifications, meaning before bisulfite conversion
#' @param bisulfite A string of nucleotides of the DNA sequence after
#'     bisulfite conversion
#'
#' @returns A visual output of all nucleotides given, where the methylated
#'    cytosines are highlighted.
#'
#' @examples
#' \dontrun{
#' findMethylatedCytosines(MethylationObservation$originalDNA,
#'     MethylationObservation$bisulfite)
#' }
#'
#' @references
#' Kevin Ushey, JJ Allaire, Hadley Wickham and Gary Ritchie (2020). rstudioapi:
#' Safely Access the RStudio API. R package version 0.13.
#' https://CRAN.R-project.org/package=rstudioapi
#'
#' @export
#' @import rstudioapi

findMethylatedCytosines <- function(orig, bisulfite) {

  # make sure that both inputs are strings
  if (!is.character(orig)){
    stop("This is not valid input; it requires a string to be given.")
  }
  if (!is.character(bisulfite)){
    stop("This is not valid input; it requires a string to be given.")
  }

  # both inputs NEED to have the same length of inputs
  if (nchar(orig) != nchar(bisulfite)) {
    stop("This is not a valid input; it requires a string to be given.")
  }

  toHighlight <- findMatchingSections(orig, bisulfite)
  if (shiny::isRunning()) {
    return(toHighlight)
  } else {
    rstudioapi::viewer(toHighlight)
  }
}

#' Generate a markdown file with all methylated cytosines highlighted
#'
#' A helper function that returns a markdown file of the two input DNA strands,
#' where each cytosine that was methylated is highlighted
#'
#' This function is an internal function and therefore cannot be used directly
#' when installing this package - it is instead a helper function for
#' findMethylatedCytosines
#'
#' @param orig A string of nucleotides of the original DNA sequence with no
#'     modifications, meaning before bisulfite conversion
#' @param bisulfite A string of nucleotides of the DNA sequence after bisulfite
#'     conversion
#'
#' @returns A file containing the two input DNA strands, where the methylated
#'    cytosines are highlighted.
#'
#'

findMatchingSections <- function(orig, bisulfite) {
  #setup temp file to save the html changes in (locally)
  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "index.html")
  matching <- c()
  start <- 1
  numChar <- nchar(orig)
  for (i in 1:numChar) {
    orig_char = substr(orig, i, i)
    bisulfite_char = substr(bisulfite, i, i)
    if ((identical(orig_char, "c")) && (identical(bisulfite_char, "c"))) {
      # this means this nucleotide is methylated!
      if (!identical(substr(orig, start, i-1), "")){
        highlight(htmlFile, substr(orig, start, i-1), FALSE)
        highlight(htmlFile, substr(orig, i, i), TRUE)
        start <- i + 1
      } else {
        highlight(htmlFile, substr(orig, i, i), TRUE)
        start <- i + 1
      }
    }
  }
  if (!identical(bisulfite_char, "c")) {
    # the last nucleotide in the string is not methylated
    highlight(htmlFile, substr(orig, start, i), FALSE)
  }
  return(htmlFile)
}

