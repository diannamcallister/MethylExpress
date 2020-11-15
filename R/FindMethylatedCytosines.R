#' Highlighting all Methylated Cytosines
#'
#' A function that returns a visual output highlighting all methylated cytosines.
#'
#' @param orig A string of nucleotides of the original DNA sequence with no modifications
#' @param bisulfite A string of nucleotides of the DNA sequence after bisulfite conversion
#'
#' @returns A visual output of all nucleotides given, where the methylated cytosines
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
#' Reference 2 - highlight package
#'
#' @export

FindMethylatedCytosines <- function(orig, bisulfite) {

  # make sure that both inputs are strings
  if (!is.character(orig)){
    stop("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
  }
  if (!is.character(bisulfite)){
    stop("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
  }

  # both inputs NEED to have the same length of inputs
  if (nchar(orig) != nchar(bisulfite)) {
    stop("THIS IS NOT VALID INPUT. REQUIRES EQUAL LENGTHS OF INPUTS")
  }

  toHighlight <- findMatchingSections(orig, bisulfite)

}

findMatchingSections <- function(orig, bisulfite) {
  #setup temp file to save the html changes in (locally)
  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "index.html")
  matching <- c()
  start <- 0
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
      }
    }
  }
  if (identical(orig_char, "c") && identical(bisulfite_char, "c")) {
    # the last nucleotide in the string is methylated!
    highlight(htmlFile, substr(orig, start, i), TRUE)
  } else {
    # the last nucleotide in the string is not methylated - do not highlight
    highlight(htmlFile, substr(orig, start, i), FALSE)
  }
  rstudioapi::viewer(htmlFile)
}

