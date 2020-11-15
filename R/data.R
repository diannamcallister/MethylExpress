#' DNA sequence to Check For CpGIslands
#'
#' A string of nucleotides that will be used to check for CpGIslands
#'
#' @source Manually created as test / fabricated data
#'
#' @format a string of lowercase characters that only include 'g', 'c', 't', 'a'
#'
#' @examples
#' \dontrun{
#'  PossibleCpGIslands
#' }
"PossibleCpGIslands"

#' Two DNA sequences to see before and after bisulfite conversion
#'
#' Two DNA sequences. One is the original sequence, the other is the sequence
#'     after bisulfite conversion
#'
#' @source University of Georgia, Hunt BG, Rehan S (2018).
#'
#' @format{
#' Two DNA sequences:
#' \describe{
#' \item{Original DNA Sequence}{The DNA sequence before any modifications were made.}
#' \item{Post-Bisulfite Conversion DNA Sequence}{The DNA sequence after bisulfite conversion.}
#' }
#' }
#'
#' @examples
#' \dontrun{
#'  MethylationObservation
#' }
"MethylationObservation"
