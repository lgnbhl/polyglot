#' Open the datasets directory
#'
#' This function will open the directory which contains the dataset files.
#'
#' @details
#' This function opens the directory which contain all the dataset files which are
#' loaded into the interactive learning environment of the polyglot package.
#'
#' @param polyglotDirectory A string
#'
#' @examples
#' if(interactive()){
#' learn_dir()
#' }
#'
#' @export

learn_dir <- function(polyglotDirectory = paste0("", system.file("extdata/", package = "polyglot"), "")){
  if (.Platform['OS.type'] == "windows"){
    shell.exec(polyglotDirectory)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), polyglotDirectory))
  }
}
