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

#' RNAseq gene expression data for patients before Bariatric surgery
#'
#' @source INSERM, Laurence Tiret (2019).
#'
#' @format{
#' RNAseq gene expression:
#' \describe{
#' \item{Gene_Name}{The name of the gene.}
#' \item{Gene_Expression}{The amount of expression of the gene shown.}
#' }
#' }
#'
#' @examples
#' \dontrun{
#'  BeforeBariatricSurgery
#' }
"BeforeBariatricSurgery"

#' RNAseq gene expression data for patients after Bariatric surgery
#'
#' @source INSERM, Laurence Tiret (2019).
#'
#' @format{
#' RNAseq gene expression:
#' \describe{
#' \item{Gene_Name}{The name of the gene.}
#' \item{Gene_Expression}{The amount of expression of the gene shown.}
#' }
#' }
#'
#' @examples
#' \dontrun{
#'  AfterBariatricSurgery
#' }
"AfterBariatricSurgery"
