#' Get example CSV files
#' 
#' This function gives access to the CSV files given as demonstrations when
#' using the \code{\link{learn}} function.
#' 
#' @examples
#' get_examples()
#' 
#' @export

get_examples <- function(){
  examples_path <- list.files(path = system.file("extdata/", package = "polyglot"), full.names = TRUE)
  cache_path <- rappdirs::user_data_dir("polyglot")
  if(!dir.exists(cache_path)) {
    cache_path <- rappdirs::user_data_dir("polyglot")
    dir.create(cache_path, recursive = TRUE, showWarnings = FALSE)
    cache_path
  }
  file.copy(from = examples_path, to = cache_path, overwrite = FALSE)
}
