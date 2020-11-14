#' Highlighting all Nucleotides Except Methylated Cytosines
#'
#' A function that returns a visual output highlighting all nucleotides except
#' the methylated cytosines.
#'
#' @param orig A string of nucleotides of the original DNA sequence with no modifications
#' @param bisulfite A string of nucleotides of the DNA sequence after bisulfite conversion
#'
#' @returns A visual output of highlighted nucleotides that are not methylated.
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
    print("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
    return
  }
  if (!is.character(bisulfite)){
    print("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
    return
  }

  # both inputs NEED to have the same length of inputs
  if (nchar(orig) != nchar(bisulfite)) {
    print("THIS IS NOT VALID INPUT. REQUIRES EQUAL LENGTHS OF INPUTS")
    return
  }

  toHighlight <- findMatchingSections(orig, bisulfite)
  text <- orig
  df <- data.frame(
    feature = c(toHighlight),
    bg_colour = c("yellow"),
    stringsAsFactors = FALSE
  )
  dict <- highlightr::as_dict(df)
  highlightr::highlight(text, dict)
}

findMatchingSections <- function(orig, bisulfite) {

  matching <- c()
  start <- 0
  numChar <- nchar(orig)
  for (i in 1:numChar) {
    orig_char = substr(orig, i, i)
    bisulfite_char = substr(bisulfite, i, i)
    if (identical(orig_char, bisulfite_char)) {
      if ((identical(orig_char, "c")) && (identical(bisulfite_char, "c"))) {
        # this means this nucleotide is methylated!
        matching <- c(matching, substr(orig, start, i-1))
        start <- i + 1
      }
    }
  }
  if (!identical(orig_char, "c") || !identical(orig_char, "c")) {
    matching <- c(matching, substr(orig, start, i))
  }
  return(matching)
}
