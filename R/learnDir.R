#' Open the datasets directory
#'
#' This function will open the directory which contains the dataset files.
#'
#' @details
#' This function opens the directory which contain all the dataset files which are
#' loaded in polyglot.
#'
#' @param polyglotDirectory A string
#'
#' @references
#' A blog post describing the package with more development: \url{https://lgnbhl.github.io/learner}
#'
#' @examples
#' if(interactive()){ 
#' learnDir() 
#' }
#'
#' @export

learnDir <- function(polyglotDirectory = paste0("", system.file("extdata/", package = "polyglot"), "")){
  if (.Platform['OS.type'] == "windows"){
    shell.exec(polyglotDirectory)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), polyglotDirectory))
  }
}
