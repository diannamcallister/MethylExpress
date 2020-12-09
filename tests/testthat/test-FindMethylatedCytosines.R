library(MethylExpress)

test_that("input of number for orig param throws error", {
  expect_error(findMethylatedCytosines(1, "aacgttt"))
})

test_that("input of number for bisulfite param throws error", {
  expect_error(findMethylatedCytosines("aacg", 1))
})

test_that("parameters have different lengths throws error", {
  expect_error(findMethylatedCytosines("aacg", "aacgttt"))
})

test_that("no cytosines exist", {
  expResult <- "<span style='float: left'> aagg </span>"
  file <- findMatchingSections("aagg", "aagg")
  expect_identical(readLines(file), expResult)
})

test_that("only cytosines in the input - but NONE are methylated", {
  expResult <- "<span style='float: left'> cccc </span>"
  file <- findMatchingSections("cccc", "tttt")
  expect_identical(readLines(file), expResult)
})

test_that("only cytosines in the input - and ALL are methylated", {
  expResult <- c()
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  file <- findMatchingSections("cccc", "cccc")
  expect_identical(readLines(file), expResult)
})

test_that("no cytosines are methylated - nothing is highlighted", {
  expResult <- "<span style='float: left'> aacg </span>"
  file <- findMatchingSections("aacg", "aatg")
  expect_identical(readLines(file), expResult)
})

test_that("one cytosine is methylated - one nucleotide is highlighted", {
  expResult <- c()
  expResult <- c(expResult, "<span style='float: left'> aa </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='float: left'> g </span>")
  file <- findMatchingSections("aacg", "aacg")
  expect_identical(readLines(file), expResult)
})

test_that("one cytosine is methylated, another isn't - one is highlighted", {
  expResult <- c()
  expResult <- c(expResult, "<span style='float: left'> aa </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='float: left'> c </span>")
  file <- findMatchingSections("aacc", "aact")
  expect_identical(readLines(file), expResult)
})

test_that("one cytosine is methylated, another isn't - longer DNA strand", {
  expResult <- c()
  expResult <- c(expResult, "<span style='float: left'> aa </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='float: left'> caaagggagagaga </span>")
  file <- findMatchingSections("aaccaaagggagagaga", "aactaaagggagagaga")
  expect_identical(readLines(file), expResult)
})

test_that("multiple cytosine are methylated, others aren't - longer DNA strand", {
  expResult <- c()
  expResult <- c(expResult, "<span style='float: left'> aa </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='float: left'> caaa </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='background-color: yellow; float: left'> c </span>")
  expResult <- c(expResult, "<span style='float: left'> agccaga </span>")
  file <- findMatchingSections("aaccaaacccagccaga", "aactaaacccagttaga")
  expect_identical(readLines(file), expResult)
})
