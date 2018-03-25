#' Exit the interactive environment
#'
#' This function will quit the interactive learning environment.
#'
#' @details
#' This function calculates the learning session time and print it. Then, it
#' cleans the Global Environment if needed and displays a farewell message.
#' 
#' @param assign.env An environment
#' 

sessionExit <- function(assign.env = parent.frame(1)) {
  sessionEndTime <- Sys.time()
  sessionTimer <- as.numeric(sessionEndTime - sessionStartTime, units = "mins")
  if(round(sessionTimer) <= 1) {
    message(paste("| Learning session time:", round(sessionTimer),"minute."))
  } else {
    message(paste("| Learning session time:", round(sessionTimer),"minutes."))
    }
  message("| Learning score saved. Cleaning parent environment...")
  if(exists("sessionDataset")) {
    rm(sessionDataset, envir = globalenv())
  }
  if(exists("datasetAbsolutePath")) {
    rm(datasetAbsolutePath, envir = globalenv())
  }
  if(exists("sessionStartTime")) {
    rm(sessionStartTime, envir = globalenv())
  }
  message("| Leaving polyglot now. Type learn() to resume.")
  invisible()
}
