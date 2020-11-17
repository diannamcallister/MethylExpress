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
#' differencesInGeneExpression(BeforeBariatricSurgery, AfterBariatricSurgery)
#' }
#'
#' @references
#'
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

  highestExpressionChanges <- FindDifferenceOfExpression(RNAseq1, RNAseq2, n)
  df <- data.frame("RNAsequence"=rep(c("RNAseq1", "RNAseq2"), each=n),
             "gene"=rep(highestExpressionChanges$GeneNames,2),
             expression=highestExpressionChanges$Expressions)
  ggplot(data=df, aes_string(x='gene', y='expression', fill='RNAsequence')) +
    geom_bar(stat="identity", color="black", position=position_dodge())+
    theme_minimal()
}

#' Calculate a certain amount of genes with the largest difference in expression.
#'
#' A function that returns the nth amount of genes with the largest difference
#' in expression between the two RNAseq results.
#'
#' @param RNAseq1 A dataframe of names of genes and their expression quantities
#'     from a RNAseq experiment
#' @param RNAseq2 A dataframe of names of genes and their expression quantities
#'     from a RNAseq experiment
#' @param n The amount of genes with the highest differences to be displayed in
#'     in the bar graph.
#'
#' @returns A list with the Gene name and expression of each RNAseq.
#' \itemize{
#'     \item GeneNames - The gene names with the highest difference in expression
#'     \item Expressions - The RNAseq expressions for each gene in GeneNames
#' }
#'
#' @examples
#' \dontrun{
#' FindDifferenceOfExpression(BeforeBariatricSurgery, AfterBariatricSurgery, 1)
#' }
#'

FindDifferenceOfExpression <- function(RNAseq1, RNAseq2, n) {
  GeneNames <- list()
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
        cur_largest <- list("gene"=RNAseq1[i, 1],
                            "expr1"=i, "expr2"=i)
        cur_difference <- abs(RNAseq1Exp - RNAseq2Exp)
      }
    }
    GeneNames <- c(GeneNames, as.character(cur_largest$gene))
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







