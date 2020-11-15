#' Bar Graph showing difference in gene expression of n genes
#'
#' A function that returns a bar graph showing n genes of greatest difference
#' between two RNA seq data inputs
#'
#' @param RNAseq1 A dataframe of names of genes and their expression quantities
#'     from a RNAseq experiment
#' @param RNAseq2 A dataframe of names of genes and their expression quantities
#'     from a RNAseq experiment
#' @param n The amount of genes with the highest differences to be displayed in
#'     in the bar graph. Default value is 1.
#'
#' @returns A bar graph indicating the amount of expression for the two RNAseq
#'     datasets for the n genes of highest differences between the two datasets
#'
#' @examples
#' \dontrun{
#' DifferencesInGeneExpression(RNAseq1, RNAseq2)
#' }
#'
#' @references
#'
#' Reference 1 - DNA source
#' Reference 2 - highlight package
#'
#' @export
#' @import ggplot2

DifferencesInGeneExpression <- function(RNAseq1, RNAseq2, n=1) {

  highestExpressionChanges <- FindDifferenceOfExpression(RNAseq1, RNAseq2, n)
  df <- data.frame("RNAsequence"=rep(c("RNAseq1", "RNAseq2"), each=n),
             "gene"=rep(highestExpressionChanges$GeneNames,2),
             expression=highestExpressionChanges$Expressions)
  ggplot(data=df, aes_string(x='gene', y='expression', fill='RNAsequence')) +
    geom_bar(stat="identity", color="black", position=position_dodge())+
    theme_minimal()
}


FindDifferenceOfExpression <- function(RNAseq1, RNAseq2, n) {
  GeneNames <- c()
  RNAseq1Expression <- c()
  RNAseq2Expression <- c()
  while (length(GeneNames) < n) {
    cur_largest <- list()
    cur_difference <- -1
    for (i in 1:nrow(RNAseq1)) {
      RNAseq1Exp <- RNAseq1[i, 2]
      RNAseq2Exp <- RNAseq2[i, 2]
      if (abs(RNAseq1Exp - RNAseq2Exp) > cur_difference) {
        cur_largest <- list("gene"=RNAseq1[i, 1],
                            "expr1"=i, "expr2"=i)
        cur_difference <- abs(RNAseq1Exp - RNAseq2Exp)
      }
    }
    GeneNames <- c(GeneNames, cur_largest$gene)
    RNAseq1Expression <- c(RNAseq1Expression, RNAseq1[cur_largest$expr1, 2])
    RNAseq2Expression <- c(RNAseq2Expression, RNAseq2[cur_largest$expr2, 2])
    # remove the largest difference rows from the datasets
    RNAseq1 <- RNAseq1[-cur_largest$expr1, ]
    RNAseq2 <- RNAseq2[-cur_largest$expr2, ]
  }
  returning <- list("GeneNames"=GeneNames,
                    "Expressions"=c(RNAseq1Expression, RNAseq2Expression))
  return(returning)
}







