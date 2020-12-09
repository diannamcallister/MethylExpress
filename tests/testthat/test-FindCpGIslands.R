library(MethylExpress)

test_that("input of another type (int) other than string throws an error", {
  expect_error(findCpGIslands(1))
})

test_that("input of another type (vector) other than string throws an error", {
  expect_error(findCpGIslands(vector()))
})

test_that("no CpG islands since DNA strand is < 200 nucleotides", {
  expResult <- "<span style='float: left'> aagg </span>"
  islands <- countCpGIslands("aagg")
  expect_identical(readLines(islands$file), expResult)
  expect_identical(islands$numIslands, 0)
})

test_that("no CpG islands w DNA strand == 200 nucleotides", {
  nucleotides <- "aaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaagga
  aaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaa
  aggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaagga"
  expResult <- paste0("<span style='float: left'> ",
                      str_remove_all(nucleotides, "\n  "), " </span>")
  islands <- countCpGIslands(str_remove_all(nucleotides, "\n  "))
  expect_identical(readLines(islands$file), expResult)
  expect_identical(islands$numIslands, 0)
})

test_that("one CpG islands in DNA strand == 200 nucleotides", {
  nucleotides <- "cgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcg
  cgcgcgcgaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaag
  gaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaagga"
  expResult <- paste0("<span style='background-color: yellow; float: left'> ",
                      str_remove_all(nucleotides, "\n  "), " </span>")
  islands <- countCpGIslands(str_remove_all(nucleotides, "\n  "))
  expect_identical(readLines(islands$file), expResult)
  expect_identical(islands$numIslands, 1)
})

test_that("one CpG islands @ beginning of DNA strand > 200 nucleotides", {
  nucleotides <- "cgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcg
  gaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaag
  gaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaggaaggaaaggaaaggaaaggaaaaaaaaaaaaaaaaaa
  ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt"
  expResult <- c(paste0("<span style='background-color: yellow; float: left'> ",
                      str_remove_all(substr(nucleotides, 1, 223), "\n  "), " </span>"))
  expResult <- c(expResult, paste0("<span style='float: left'> ",
                        str_remove_all(substr(nucleotides, 221, 281), "\n  "), " </span>"))
  islands <- countCpGIslands(str_remove_all(nucleotides, "\n  "))
  expect_identical(readLines(islands$file), expResult)
  expect_identical(islands$numIslands, 1)
})

test_that("CG ratio & OE ratio are both below necessary for CpG Island", {
  actualResult <- observedAndExpected(1, 1, 0, 6)
  expect_identical(actualResult$CGRatio, 1/3)
  expect_identical(actualResult$OERatio, 0)
})

test_that("CG ratio is below & OE ratio is above necessary for CpG Island", {
  actualResult <- observedAndExpected(1, 1, 1, 6)
  expect_identical(actualResult$CGRatio, 1/3)
  expect_identical(actualResult$OERatio, 6)
})

test_that("CG ratio & OE ratio are both above necessary for CpG Island", {
  actualResult <- observedAndExpected(2, 1, 1, 6)
  expect_identical(actualResult$CGRatio, 0.5)
  expect_identical(actualResult$OERatio, 3)
})

test_that("don't highlight something", {
  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "index.html")

  expResult <- "<span style='float: left'> atgc </span>"
  highlight(htmlFile, "atgc", FALSE)
  expect_identical(readLines(htmlFile), expResult)
})

test_that("highlight something", {
  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "index.html")

  expResult <- "<span style='background-color: yellow; float: left'> atgc </span>"
  highlight(htmlFile, "atgc", TRUE)
  expect_identical(readLines(htmlFile), expResult)
})
