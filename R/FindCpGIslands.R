#' Highlighting all CpG Islands
#'
#' A function that returns a visual output highlighting all CpG islands found
#' in the DNA strand.
#'
#' @param nucleotides A string of nucleotides of a DNA sequence
#'
#' @returns A visual output of highlighted CpG Islands in the DNA sequence
#'
#' @examples
#' \dontrun{
#' FindCpGIslands(nucleotides)
#' }
#'
#' @references
#'
#' Reference 1 - DNA source
#' Reference 2 - highlight package
#'
#' @export
#' @import stringr

FindCpGIslands <- function(nucleotides) {

  # this should take in a string - if anything else is given, it returns an
  #   error message
  if (!is.character(nucleotides)){
    stop("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
  }

  islands <- countCpGIslands(nucleotides)

  rstudioapi::viewer(islands$file)
  return(islands$numIslands)
}

countCpGIslands <- function(nucleotides) {

  dir <- tempfile()
  dir.create(dir)
  htmlFile <- file.path(dir, "index.html")

  # check that the length of the DNA strand is >= 200 strands. If not, there
  #   is no way that there is any CpG islands
  if (nchar(nucleotides) < 200){
    highlight(htmlFile, nucleotides, FALSE)
    return(list("file"=htmlFile, "numIslands"=0))
  }

  # now we can check for CpG islands
  # rules for something to be considered a CpG island:
  # 1. the number of CGs must be > 50% of the part of DNA being looked at
  # 2. the observed-to-expected ration must be > 60%
  #setup temp file to save the html changes in (locally)
  nucleotides <- tolower(nucleotides)
  start = 1
  end = 200
  CpGIslands <- vector(mode = "list", length = 25)
  inCpGIsland <- FALSE
  curIsland <- 1
  while (end <= nchar(nucleotides)){
    cur_nuc <- substr(nucleotides, start, end)
    numC <- stringr::str_count(cur_nuc, "c")
    numG <- stringr::str_count(cur_nuc, "g")
    numCpG <- stringr::str_count(cur_nuc, "cg")

    constraints <- observedAndExpected(numC, numG, numCpG, nchar(cur_nuc))
    if (constraints$CGRatio >= 0.5 && constraints$OERatio >= 0.6){
      # in a CpG island - check if there are more nucleotides part of the
      #   CpG island
      inCpGIsland <- TRUE
      end <- end + 1
    }
    else{
      if (inCpGIsland){
        # meaning at the length right before end, there was a CpG island
        #   but is not continued anymore
        highlight(htmlFile, substr(nucleotides, start, end-1), TRUE)
        curIsland <- curIsland + 1
        # time to look for a brand new CpG island - shift reading frame over
        #   by 200 nucleotides
        start <- end
        end <- end + 200
        inCpGIsland <- FALSE
      } else {
        # the current reading frame is not a CpG island - need to move on
        highlight(htmlFile, substr(nucleotides, start, start + 1), FALSE)
        start <- start + 1
        end <- end + 1
      }
    }
  }
  # check if we ended in the middle of a CpG island
  if (inCpGIsland){
    # meaning at the length right before end, there was a CpG island
    highlight(htmlFile, substr(nucleotides, start, end-1), TRUE)
    curIsland <- curIsland + 1
  } else {
    highlight(htmlFile, substr(nucleotides, start, end-1), FALSE)
  }
  returning <- list("file"=htmlFile, "numIslands"=curIsland-1)
  return(returning)
}

observedAndExpected <- function(numC, numG, numCpG, lenNuc) {

  # calculate the % of CGs relative to the length of the DNA
  CGRatio <- (numC + numG) / lenNuc
  # calculate the observed:expected ratio
  observed <- numCpG
  expected <- (numC * numG) / lenNuc
  OERatio <- observed / expected
  returning <- data.frame("CGRatio"=CGRatio, "OERatio"=OERatio)
  return(returning)
}

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
