#' Highlighting differences in nucleotides between two DNA Sequences
#'
#' A function that returns a visual output highlighting all differences in
#' nucleotides between two DNA sequences
#'
#' @param strand1 A string of nucleotides of one DNA sequence
#' @param strand2 A string of nucleotides of another DNA sequence
#'
#' @returns The html of the two DNA sequences, as well as a visual output of
#'     the highlighted differences in nucleotides between two DNA sequences, as
#'     well
#'
#' @examples
#' \dontrun{
#' findDifferencesInDNASequence(MethylationObservation$originalDNA,
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

findDifferencesInDNASequence <- function(strand1, strand2) {
  # make sure that both inputs are strings
  if (!is.character(strand1)){
    stop("String1 is not a valid input; it is required to be a string.")
  }
  if (!is.character(strand2)){
    stop("String2 is not a valid input; it is required to be a string.")
  }

  # both inputs NEED to have the same length of inputs
  if (nchar(strand1) != nchar(strand2)) {
    stop("These strands are not valid input; both strands must be the same length.")
  }

  file <- DNASequenceHighlights(strand1, strand2)

  if (shiny::isRunning()) {
    return (file)
  } else {
    rstudioapi::viewer(file)
  }
}


#' Generate a markdown file with differing nucleotides highlighted
#'
#' A function that returns a file that includes highlight html to indicate
#' which nucleotides between two strands differ
#'
#' @param strand1 A string of nucleotides of one DNA sequence
#' @param strand2 A string of nucleotides of another DNA sequence
#'
#' @returns The html of the two DNA sequences (and highlight html)
#'
#' @examples
#' \dontrun{
#' DNASequenceHighlights(BeforeBariatricSurgery, AfterBariatricSurgery)
#' }
#'
#'

DNASequenceHighlights <- function(strand1, strand2) {
  dir <- tempfile()
  dir.create(dir)
  htmlFile1 <- file.path(dir, "strand1.html")
  write("<b style='float: left'>Strand 1:</b><br></br>", htmlFile1, append=TRUE)
  htmlFile2 <- file.path(dir, "strand2.html")
  write("<div style='clear: both'><b><br>Strand 2:</b></div><br>", htmlFile2, append=TRUE)
  start <- 1
  for (i in 1:(nchar(strand1)+1)) {
    strand1Char <- substr(strand1, i, i)
    strand2Char <- substr(strand2, i, i)
    if (!identical(strand1Char, strand2Char)) {
      # we have reached a point where the 2 current nucleotides are different
      #   highlight these nucleotides
      if (!identical(substr(strand1, start, i-1), "")) {
        highlight(htmlFile1, substr(strand1, start, i-1), FALSE)
        highlight(htmlFile2, substr(strand2, start, i-1), FALSE)
        highlight(htmlFile1, substr(strand1, i, i), TRUE)
        highlight(htmlFile2, substr(strand2, i, i), TRUE)
        start <- i + 1
      } else {
        highlight(htmlFile1, substr(strand1, i, i), TRUE)
        highlight(htmlFile2, substr(strand2, i, i), TRUE)
        start <- i + 1
      }
    }
  }
  if (identical(strand1Char, strand2Char) && start!=i) {
    highlight(htmlFile1, substr(strand1, start, i), FALSE)
    highlight(htmlFile2, substr(strand2, start, i), FALSE)
  }
  file2Final <- readLines(htmlFile2)
  write("<br><br>", htmlFile1, append=TRUE)
  write(file2Final, htmlFile1, append=TRUE)

  return(htmlFile1)
}






