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
#' \item{originalDNA}{The DNA sequence before any modifications were made.}
#' \item{bisulfite}{The DNA sequence after bisulfite conversion.}
#' }
#' }
#'
#' @references
#' Hunt, B. G. (2018). GEO Accession viewer. Retrieved November 17, 2020,
#' from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE111611
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
#' @references
#' Poitou C, Perret C, Mathieu F, Truong V et al. Bariatric Surgery Induces
#' Disruption in Inflammatory Signaling Pathways Mediated by Immune Cells in
#' Adipose Tissue: A RNA-Seq Study. PLoS One 2015;10(5):e0125718.
#' PMID: 25938420
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
#' @references
#' Poitou C, Perret C, Mathieu F, Truong V et al. Bariatric Surgery Induces
#' Disruption in Inflammatory Signaling Pathways Mediated by Immune Cells in
#' Adipose Tissue: A RNA-Seq Study. PLoS One 2015;10(5):e0125718.
#' PMID: 25938420
#'
#' @examples
#' \dontrun{
#'  AfterBariatricSurgery
#' }
"AfterBariatricSurgery"
