#' Initialize the interactive environment
#'
#' This function will launch the interactive learning environment.
#'
#' @details
#' This function initializes the interactive environment by proposing to select
#' a CSV file from the directory inst/extdata/. Once the file is selected, the
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
#' @importFrom utils read.csv
#' @importFrom utils select.list
#' @importFrom utils write.csv
#'
#' @export

learn <- function(assign.env = parent.frame(1)) {
  cat("| Welcome to polyglot! \n")
  cat("| Please choose a dataset to study, or type 0 to exit. \n")

  # add sessionStartTime object if not existing
  if(!exists("sessionStartTime")) {
    sessionStartTime <- Sys.time()
    assign("sessionStartTime", sessionStartTime, envir = assign.env)
  }

  # interactive selection of a dataset
  datasetPath <- system.file("extdata/", package = "polyglot")
  datasetName <- select.list(list.files(path = paste0("", datasetPath, "")))
  datasetAbsolutePath <- paste0("", datasetPath,"/", datasetName,"")
  assign("datasetAbsolutePath", datasetAbsolutePath, envir = assign.env, inherits = TRUE)
  if (datasetName == "") {
    sessionExit() # 0 selected, exit the learning session
  } else {
    sessionDataset <- read.csv(paste0("", datasetAbsolutePath,""), stringsAsFactors = FALSE, na.strings = "")
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # Check if the dataset has at least two colomns
    if (ncol(sessionDataset) < 2) {
      message("| WARNING: Your dataset doesn't have two colomns.")
      message("| polyglot needs two colomns datasets to work correctly.\n")
      return(learn())
    } else {
      sessionDataset[,1] <- as.character(sessionDataset[,1])
      assign("sessionDataset", sessionDataset, envir = assign.env)
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
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # Add dueDate variable if not existing and print message
    if (any(names(sessionDataset) == "dueDate")) {
        cat(paste("|", length(which(sessionDataset$dueDate <= as.Date(Sys.Date()))),"rows left to learn. \n\n"))
         if(length(which(sessionDataset$dueDate <= as.Date(Sys.Date()))) == 1) {
            cat(paste("| 1 row left to learn. \n\n"))
         }
    } else {
      sessionDataset$dueDate <- rep(as.Date(Sys.Date()), nrow(sessionDataset)) # add today date
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    }
    # If NAs exist in the dueDate variable, replace by today date
    sessionDataset$dueDate[which(is.na(sessionDataset$dueDate))] <- format(Sys.time(), "%Y-%m-%d")
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # Add numeric Repetition variable if not existing
    if (any(names(sessionDataset) == "Repetition")) {
      # Repetition already exists
    } else {
      sessionDataset$Repetition <- rep(as.numeric(0), nrow(sessionDataset)) # add today date
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    }
    # If NAs exist in the Repetition variable, replace by 0
    sessionDataset$Repetition[is.na(sessionDataset$Repetition)] <- as.numeric(0)
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # Add numeric easiness factor (eFactor) if not existing
    if (any(names(sessionDataset) == "eFactor")) {
      # eFactor already exists
    } else {
      sessionDataset$eFactor <- rep(as.numeric(2.5), nrow(sessionDataset))
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    }
    # If NAs exist in the eFactor variable, replace by 2.5
    sessionDataset$eFactor[is.na(sessionDataset$eFactor)] <- as.numeric(2.5)
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # Add difftime Interval object if not existing
    if (any(names(sessionDataset) == "Interval")) {
      # Interval already exists
    } else {
      sessionDataset$Interval <-rep(as.difftime(0, units = "days"), nrow(sessionDataset))
      assign("sessionDataset", sessionDataset, envir = assign.env)
      write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    }
    # If NAs exist in the Interval variable, replace by 0
    sessionDataset$Interval[is.na(sessionDataset$Interval)] <- as.difftime(0, units = "days")
    assign("sessionDataset", sessionDataset, envir = assign.env)

    # reorder dataset by dueDate and Score
    sessionDataset <- sessionDataset[order(sessionDataset$dueDate, sessionDataset$Score), ]
    assign("sessionDataset", sessionDataset, envir = assign.env)

    write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
    return(sessionQuestions())
  }
  invisible()
}
