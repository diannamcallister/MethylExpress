#' Highlighting all CpG Islands
#'
#' A function that returns a visual output highlighting all CpG islands found
#' in the DNA strand.
#'
#' More details about how the CpG islands are calculated can be found in the
#' README and the vignette, but a quick overview as to how nucleotides are
#' considered part of a CpG islands is:
#' 1. the number of CGs must be > 50% of the part of DNA being looked at
#' 2. the observed number of CGs - to - expected number of CGs ratio must be > 60%
#'
#' @param nucleotides A string of nucleotides of a DNA sequence
#'
#' @returns A visual output of highlighted CpG Islands in the DNA sequence
#'
#' @examples
#' \dontrun{
#' findCpGIslands(PossibleCpGIslands)
#' }
#'
#' @references
#' Kevin Ushey, JJ Allaire, Hadley Wickham and Gary Ritchie (2020). rstudioapi:
#' Safely Access the RStudio API. R package version 0.13.
#' https://CRAN.R-project.org/package=rstudioapi
#'
#' @export
#' @import rstudioapi
#' @import stringr

findCpGIslands <- function(nucleotides) {

  # this should take in a string - if anything else is given, it returns an
  #   error message
  if (!is.character(nucleotides)){
    stop("This is not a valid input. A string must be given as the parameter.")
  }

  islands <- countCpGIslands(nucleotides)
  if (shiny::isRunning()){
    return(islands$file)
  } else {
    rstudioapi::viewer(islands$file)
    return(islands$numIslands)
  }
}

#' Calculates the number of CpG islands in a DNA strand and creates a markdown
#'     file to highlight them
#'
#' A helper function that returns the file who contains markdown of the DNA
#'     strand with the CpG islands highlighted, as well as the number of CpG
#'     islands in the DNA strand
#'
#' This function is an internal function and therefore cannot be used directly
#' when installing this package - it is instead a helper function for
#' findCpGIslands
#'
#' @param nucleotides A string of nucleotides in a DNA strand
#'
#' @returns The number of CpG islands found and a file that shows where the islands are in the DNA strand
#' \itemize{
#'     \item file - A string value for the file where the markdown text can be found
#'     \item numIslands - An integer value for the amount of CpG islands found
#' }
#'
#'

countCpGIslands <- function(nucleotides) {

  #setup temp file to save the html changes in (locally)
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

#' Calculate CG ratio and observed:expected ratio for CpG Islands
#'
#' A helper function that returns the ratio of CG nucleotides to the amount of all
#' nucleotides, and the ratio of observed:expected CpG Islands
#'
#' This function is an internal function and therefore cannot be used directly
#' when installing this package - it is instead a helper function for
#' findCpGIslands
#'
#' @param numC The number of cytosines in a DNA strand
#' @param numG The number of guanines in a DNA strand
#' @param numCpG The number of cytosines followed by a guanine in a DNA strand
#' @param lenNuc The number of nucleotides in a DNA strand
#'
#' @returns A dataframe with the CG ratio and observed:expected ratio of CpG Islands
#' \itemize{
#'     \item CGRatio - A value for the CG ratio in a DNA strand
#'     \item OERatio - A value for the observed:expected CpG Island ratio
#' }
#'
#'

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

#' Highlighting parts of text
#'
#' A helper function that writes text to a file, while also adding the markup
#'     for the text to be highlighted if desired
#'
#' This function is an internal function and therefore cannot be used directly
#' when installing this package - it is instead a helper function
#'
#' @param fileName The name of the file where the markdown will be saved to
#' @param nucleotides A string of nucleotides of a DNA sequence
#' @param highlighting A boolean to say if nucleotides will be highlighted in fileName
#'
#' @returns No return value but adds the markup text to the input file
#'
#'

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
