#' Launch Shiny App for MethylExpress
#'
#' A function that launches the Shiny app for MethylExpress
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' MethylExpress::runMethylExpress()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials.
#'     \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp

runMethylExpress <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "MethylExpress")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
# [END]
