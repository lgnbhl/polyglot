#' Open the datasets directory
#'
#' This function will open the directory which contains the local datasets files 
#' used in polygot thanks to the pins package.
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
#' @importFrom pins board_local_storage
#'
#' @export

learn_dir <- function(polyglotDirectory = pins::board_local_storage()){
  
  if (.Platform['OS.type'] == "windows"){
    shell.exec(polyglotDirectory)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), polyglotDirectory))
  }
}
