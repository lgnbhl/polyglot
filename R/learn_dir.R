#' Open the datasets directory
#'
#' This function will open the directory which contains the local datasets files 
#' used in polygot.
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

learn_dir <- function(polyglotDirectory = cache_dir()){
  
  if (.Platform['OS.type'] == "windows"){
    shell.exec(polyglotDirectory)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), polyglotDirectory))
  }
}

cache_dir <- function() {
  cache_path <- rappdirs::user_data_dir("polyglot")
  dir.create(cache_path, recursive = TRUE, showWarnings = FALSE)
  cache_path
}
