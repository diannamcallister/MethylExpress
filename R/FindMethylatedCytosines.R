#' Highlighting all Methylated Cytosines
#'
#' A function that returns a visual output highlighting all methylated cytosines.
#'
#' @param orig A string of nucleotides of the original DNA sequence with no modifications
#' @param bisulfite A string of nucleotides of the DNA sequence after bisulfite conversion
#'
#' @returns The html of highlighted methylated nucleotides, as well as a visual
#'    output of all nucleotides given, where the methylated cytosines
#'    are highlighted.
#'
#' @examples
#' \dontrun{
#' FindMethylatedCytosines(orig, bisulfite)
#' }
#'
#' @references
#'
#' Reference 1 - DNA source
#'
#' @export
#' @import rstudioapi

FindMethylatedCytosines <- function(orig, bisulfite) {

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
  rstudioapi::viewer(toHighlight)
  return(readLines(toHighlight))
}

#' Generate a markdown file with all methylated cytosines highlighted
#'
#' A function that returns a markkdown file of the two input DNA strands, where
#' each cytosine that was methylated is highlighted
#'
#' @param orig A string of nucleotides of the original DNA sequence with no modifications
#' @param bisulfite A string of nucleotides of the DNA sequence after bisulfite conversion
#'
#' @returns The file containing html of highlighted methylated nucleotides, as
#'    well as a visual output of all nucleotides given, where the methylated
#'    cytosines are highlighted.
#'
#' @examples
#' \dontrun{
#' findMatchingSections(orig, bisulfite)
#' }
#'
#' @references
#'
#' Reference 1 - DNA source
#'
#' @export
#' @import rstudioapi

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

