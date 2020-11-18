library(MethylExpress)

test_that("input of another type (int) other than dataframe throws an error", {
  expect_error(differencesInGeneExpression(1, 1))
})

test_that("input of another type (string) other than dataframe throws an error", {
  expect_error(differencesInGeneExpression("str", "str"))
})

test_that("RNAseq1 does not have the same amount of rows as RNAseq2", {
  RNASeq1 <- data.frame("GeneNames"=c("a", "b"), "Expression"=c(1, 2))
  RNASeq2 <- data.frame("GeneNames"=c("a"), "Expression"=c(1))
  expect_error(differencesInGeneExpression(RNASeq1, RNASeq2))
})

test_that("Requested amount of genes to be compared is larger than the
          amount of genes in the dataframes", {
  RNASeq1 <- data.frame("GeneNames"=c("a", "b"), "Expression"=c(1, 2))
  RNASeq2 <- data.frame("GeneNames"=c("a", "b"), "Expression"=c(2, 1))
  expect_error(differencesInGeneExpression(RNASeq1, RNASeq2, 3))
})

test_that("Only one row is given in each dataframe", {
  RNASeq1 <- data.frame("GeneNames"=c("a"),"Expression"=c(1))
  RNASeq2 <- data.frame("GeneNames"=c("a"), "Expression"=c(2))
  actualResult <- FindDifferenceOfExpression(RNASeq1, RNASeq2, 1)
  expect_identical(c("a"), actualResult$GeneNames)
  expect_identical(c(1, 2), actualResult$Expressions)
})

test_that("Two rows are given in each dataframe but only #1 highest is retrieved", {
  RNASeq1 <- data.frame("GeneNames"=c("a", "b"),"Expression"=c(1, 2))
  RNASeq2 <- data.frame("GeneNames"=c("a", "b"), "Expression"=c(2, 1))
  actualResult <- FindDifferenceOfExpression(RNASeq1, RNASeq2, 1)
  expect_identical(c("a"), actualResult$GeneNames)
  expect_identical(c(1, 2), actualResult$Expressions)
})

test_that("Four rows are given in each dataframe and two highest reretrieved", {
  RNASeq1 <- data.frame("GeneNames"=c("a", "b", "c", "d"),"Expression"=c(1, 2, 3, 4))
  RNASeq2 <- data.frame("GeneNames"=c("a", "b", "c", "d"), "Expression"=c(2, 1, 1, 0))
  actualResult <- FindDifferenceOfExpression(RNASeq1, RNASeq2, 2)
  expect_identical(c("d", "c"), actualResult$GeneNames)
  expect_identical(c(4, 3, 0, 1), actualResult$Expressions)
})






