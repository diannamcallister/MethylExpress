#' Bar Graph showing difference in gene expression of n genes
#'
#' A function that returns a bar graph showing gene expression of n genes
#' with greatest difference of expression between two RNA seq data inputs
#'
#' @param RNAseq1 A dataframe of names of genes and their count values as
#'     expression quantities from a RNAseq experiment
#' @param RNAseq2 A dataframe of names of genes and their count values as
#'     expression quantities from a RNAseq experiment
#' @param n The amount of genes with the largest difference in gene expression
#'     to be displayed in the bar graph. Default value is 1.
#'
#' @returns A bar graph indicating the amount of expression for the two RNAseq
#'     datasets for the n genes of highest differences between the two datasets
#'
#' @examples
#' \dontrun{
#' differencesInGeneExpression(BeforeBariatricSurgery, AfterBariatricSurgery)
#' }
#'
#' @references
#' H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag
#' New York, 2016.
#'
#' @export
#' @import ggplot2

differencesInGeneExpression <- function(RNAseq1, RNAseq2, n=1) {

  if (!is.data.frame(RNAseq1)){
    stop("This is not valid input; it requires a dataframe to be given.")
  }
  if (!is.data.frame(RNAseq2)){
    stop("This is not valid input; it requires a dataframe to be given.")
  }

  if (nrow(RNAseq1) != nrow(RNAseq2)) {
    stop("Both RNAseq dataframes must have the same amount of rows.")
  }

  if (nrow(RNAseq1) < n) {
    stop("The amount of requested genes compared is higher than the amount
         of genes in the RNAseq data. Please choose a smaller n value.")
  }

  highestExpressionChanges <- findDifferenceOfExpression(RNAseq1, RNAseq2, n)
  df <- data.frame(RNAsequence=rep(c("RNAseq1", "RNAseq2"), each=n),
             gene=rep(highestExpressionChanges$GeneNames,2),
             expression=highestExpressionChanges$Expressions)
  ggplot2::ggplot(data=df, aes_string(x="gene", y='expression', fill='RNAsequence')) +
    geom_bar(stat="identity", color="black", position=position_dodge()) +
    theme_minimal() + ggtitle("Differences In Gene Expression")
}

#' Calculate a certain amount of genes with the largest difference in expression.
#'
#' A helper function that returns n genes with the largest difference in expression
#' between two RNAseq datasets
#'
#' This function is an internal function and therefore cannot be used directly
#' when installing this package - it is instead a helper function for
#' differencesInGeneExpression
#'
#' @param RNAseq1 A dataframe of names of genes and their count values as
#'     expression quantities from a RNAseq experiment
#' @param RNAseq2 A dataframe of names of genes and their count values as
#'     expression quantities from a RNAseq experiment
#' @param n The amount of genes with the largest difference in gene expression
#'     to be displayed in the bar graph.
#'
#' @returns A list with gene name and expression of the n genes with largest
#'     difference in gene expression between the two RNAseq datasets.
#' \itemize{
#'     \item GeneNames - The gene names with the highest difference in expression
#'     \item Expressions - The RNAseq expression from each RNAseq dataset for
#'        each gene in GeneNames
#' }
#'
#'

findDifferenceOfExpression <- function(RNAseq1, RNAseq2, n) {
  GeneNames <- c()
  RNAseq1Expression <- c()
  RNAseq2Expression <- c()
  while (length(GeneNames) < n) {
    cur_largest <- list()
    cur_difference <- -1
    for (i in 1:nrow(RNAseq1)) {
      if (RNAseq1[i, 1] != RNAseq2[i, 1]) {
        stop("The same gene names must be the same rows for both RNAseq")
      }
      RNAseq1Exp <- RNAseq1[i, 2]
      RNAseq2Exp <- RNAseq2[i, 2]
      if (abs(RNAseq1Exp - RNAseq2Exp) > cur_difference) {
        cur_largest <- list("gene"=i, "expr1"=i, "expr2"=i)
        cur_difference <- abs(RNAseq1Exp - RNAseq2Exp)
      }
    }
    GeneNames <- c(GeneNames, as.character(RNAseq1[cur_largest$gene, 1]))
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







