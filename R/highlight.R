#' Highlighting parts of text
#'
#' A function that returns a visual output highlighting specified letters in
#' a string.
#'
#' @param fileName The name of the file where the markdown will be saved to
#' @param nucleotides A string of nucleotides of a DNA sequence
#' @param highlighting A boolean to say if nucleotides will be highlighted in fileName
#'
#' @returns A visual output of highlighted letters in a string
#'
#' @examples
#' \dontrun{
#' highlight(fileName, nucleotides, TRUE)
#' }
#'

highlight <- function(fileName, nucleotides, highlighting) {
  if (!highlighting) {
    regText <- paste("<span style='float: left'>", nucleotides, "</span>")
    write(regText, fileName, append=TRUE)
  }
  if (highlighting) {
    regText <- paste("<span style='background-color: yellow; float: left'>", nucleotides, "</span>")
    write(regText, fileName, append=TRUE)
  }
}
