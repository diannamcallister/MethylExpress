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

FindCpGIslands <- function(nucleotides) {

  # this should take in a string - if anything else is given, it returns an
  #   error message
  if (!is.character(nucleotides)){
    print("THIS IS NOT VALID INPUT. REQUIRES A STRING TO BE GIVEN")
    return
  }

  numIslands <- countCpGIslands(nucleotides)
  sections <- c()
  for (i in 1:numIslands$numIslands) {
    nuc_seq <- numIslands$CpGIslands[[i]]
    sections <- c(sections, substr(nucleotides, nuc_seq[1], nuc_seq[2]))
  }
  df <- data.frame(
    feature = c(sections),
    bg_colour = c("yellow"),
    stringsAsFactors = FALSE
  )
  dict <- highlightr::as_dict(df)
  text <- nucleotides
  highlightr::highlight(text, dict)
}

countCpGIslands <- function(nucleotides) {
  # check that the length of the DNA strand is >= 200 strands. If not, there
  #   is no way that there is any CpG islands
  if (nchar(nucleotides) < 200){
    return(list("numIslands"=0, "CpGIslands"=vector()))
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
    print(constraints$CGRatio)
    print(constraints$OERatio)
    if (constraints$CGRatio >= 0.5 && constraints$OERatio >= 0.6){
      inCpGIsland <- TRUE
      end <- end + 1
    }
    else{
      if (inCpGIsland){
        #meaning at the length right before end, there was a CpG island
        CpGIslands[[curIsland]] <- c(start, end-1)
        curIsland <- curIsland + 1
        # time to look for a brand new CpG island - shift reading frame over
        # by 200 nucleotides
        start <- end
        end <- end + 200
        inCpGIsland <- FALSE
        print("resetting to false")
        print("new start:")
        print(start)
      } else {
        print("not in cpgisland")
        start <- start + 1
        end <- end + 1
      }
    }
  }
  # check if we ended in the middle of a CpG island
  if (inCpGIsland){
    #meaning at the length right before end, there was a CpG island
    CpGIslands[[curIsland]] <- c(start, end-1)
    curIsland <- curIsland + 1
  }
  returning <- list("numIslands"=curIsland-1, "CpGIslands"=CpGIslands)
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
