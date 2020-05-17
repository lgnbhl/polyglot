#' Get example CSV files
#' 
#' This function gives access to the CSV files given as demonstrations when
#' using the \code{\link{learn}} function.
#' 
#' @examples
#' get_examples()
#' 
#' @importFrom pins board_local_storage
#'
#' @export

get_examples <- function(){
  datasetPath <- system.file("extdata/", package = "polyglot")
  datasetName <- list.files(path = paste0("", datasetPath, ""))
  datasetAbsolutePath <- paste0(datasetPath, datasetName)
  
  file.copy(datasetAbsolutePath, to = paste0(pins::board_local_storage(), "/", datasetName))
}
