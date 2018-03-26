#' Initialize the interactive environment
#'
#' This function will launch the interactive learning environment.
#'
#' @details
#' This function initializes the interactive environment by proposing to select
#' a CSV file from the inst/extdata/ directory. Once the file selected, the
#' function reads the selected dataset and adds a numeric variable, named
#' Score, if not already existing. It also replaces any existing missing values
#' by 0 from the Score variable. Finally the function returns to the
#' \code{\link{sessionQuestions}} function, or to the \code{\link{sessionExit}}
#' function if 0 is typed.
#' 
#' @note
#' In order to study a new CSV file, simply save it into the inst/extdata/ directory.
#'
#' If you have any problem with the encoding, or if you want to read a dataset with
#' an non-Latin alphabet, please type ?Sys.setlocale() and follow the instructions.
#'
#' @param assign.env An environment
#'
#' @references
#' A blog post describing the package with more development: \url{https://lgnbhl.github.io/learner}
#'
#' @examples
#' if(interactive()){ 
#' learn() 
#' }
#'
#' @export

learn <- function(assign.env = parent.frame(1)) {
  cat("| Welcome to polyglot! \n")
  cat("| Please choose a dataset to study, or type 0 to exit.")
  if(!exists("sessionStartTime")) {
    sessionStartTime <- Sys.time()
    assign("sessionStartTime", sessionStartTime, envir = assign.env)
  }
  datasetPath <- system.file("extdata/", package = "polyglot")
  datasetName <- select.list(list.files(path = paste0("", datasetPath, "")))
  datasetAbsolutePath <- paste0("", datasetPath,"/", datasetName,"")
  assign("datasetAbsolutePath", datasetAbsolutePath, envir = assign.env, inherits = TRUE)
  if (datasetName == "") {
    sessionExit() # 0 selected, exit the learning session
  } else {
    sessionDataset <- read.csv(paste0("", datasetAbsolutePath,""), stringsAsFactors = FALSE)
    assign("sessionDataset", sessionDataset, envir = assign.env)
    # Check if the dataset has at least two colomns
    if (ncol(sessionDataset) < 2) {
      message("| WARNING: Your dataset doesn't have two colomns.")
      message("| polyglot needs two colomns datasets to work correctly.\n")
      return(learn())
    } else {
      sessionDataset[,1] <- as.character(sessionDataset[,1])
      sessionDataset[,2] <- as.character(sessionDataset[,2])
      assign("sessionDataset", sessionDataset, envir = assign.env)
    }
    # Add Score variable if not existing and print message
    if (any(names(sessionDataset) == "Score")) {
      cat(paste("|", datasetName, "selected, with", nrow(sessionDataset),"rows. \n"))
    } else {
      sessionDataset$Score <- rep(as.numeric(0), nrow(sessionDataset))
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
      cat(paste("|", datasetName,"selected, with", nrow(sessionDataset),"rows. \n"))
      cat("| New learning session launched... \n\n")
    }
    # If NAs exist in the Score variable, replace by 0
    sessionDataset$Score[is.na(sessionDataset$Score)] <- 0
    # Add Date variable if not existing and print message
    if (any(names(sessionDataset) == "Date")) {
      cat(paste("|", length(which(sessionDataset$Date <= Sys.Date())),"rows left to learn. \n"))
        if(length(which(sessionDataset$Date <= Sys.Date())) == 1) {
        cat(paste("| 1 row left to learn. \n"))
        }
      } else {
      sessionDataset$Date <- rep(Sys.Date(), nrow(sessionDataset)) # add today date
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    }
    # if NAs exist in the Date variable, replace by today
    sessionDataset$Date[is.na(sessionDataset$Date)] <- Sys.Date()
    assign("sessionDataset", sessionDataset, envir = assign.env)
    write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    return(sessionQuestions())
  }
  invisible()
}
