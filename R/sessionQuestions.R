#' Ask questions in the interactive environment
#'
#' This function will print questions in the interactive learning environment.
#'
#' @details
#' This function reads the selected dataset and print the first row of its first
#' colomn, i.e. the question. Then it presents to the user a menu, which gives him
#' multiple choices. According to the choice made by the user, the function gives a
#' score point, i.e. Hard = +4 points, Good = +2 points, Easy = +1 point. The menu
#' also proposes to show the answer (the 2nd column of the row), to give a hint/example,
#' or to go back to the main menu. Finally, the function reorders the dataset in order
#' to get the lower points score in its first row and return the function once again.
#'
#' @note
#' In order to quit, simply type 0.
#'
#' @param assign.env An environment
#' 
#' @references
#' A blog post describing the package with more development: \url{https://lgnbhl.github.io/learner}

invisible(if(getRversion() >= "2.15.1") utils::globalVariables(c("sessionStartTime", "sessionDataset", "datasetAbsolutePath")))

sessionQuestions <- function(assign.env = parent.frame(1)) {
  sessionDataset <- read.csv(paste0("", datasetAbsolutePath,""), stringsAsFactors = FALSE)
  
  # check if rows to learn for current session
  if(as.Date(sessionDataset$dueDate[1]) <= as.Date(Sys.Date())) {
    message(paste("| Question:", sessionDataset[1,1],"\n"))
  } else {
    message(paste("| 0 row to learn... Back to menu. \n"))
    return(learn())
  }
  
  # space repetition learning algorithm based on SuperMemo 2. 
  # reference: https://www.supermemo.com/english/ol/sm2.htm
  
  switch(menu(c("Show answer", "Hard", "Good", "Easy", "Hint/Example", "Back to menu")) + 1,
         return(sessionExit()),
         # "Show answer"
         message(paste0("| Answer: ", sessionDataset[1,2], "")),
         # "Hard" (fail and again)
         if(exists("sessionDataset")) {
           sessionDataset$Score[1] <- sessionDataset$Score[1] + 1
           assign("sessionDataset", sessionDataset, envir = assign.env)
           sessionDataset$eFactor[1] <- 2.5 #default eFactor
           assign("sessionDataset", sessionDataset, envir = assign.env)
           sessionDataset$Interval[1] <- as.difftime(0, units = "days") #0 day interval
           assign("sessionDataset", sessionDataset, envir = assign.env)
         },
         # "Good" (again)
         if(exists("sessionDataset")) {
            sessionDataset$Score[1] <- sessionDataset$Score[1] + 2
            assign("sessionDataset", sessionDataset, envir = assign.env)
         },
         # "Easy" (pass)
         if(sessionDataset$Repetition[1] == 0) {
               sessionDataset$Repetition[1] <- sessionDataset$Repetition[1] + 1
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Score[1] <- sessionDataset$Score[1] + 4
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Interval[1] <- as.difftime(1, units = "days") #+1 day
               assign("sessionDataset", sessionDataset, envir = assign.env)
               dueDate_new <- Sys.Date() + sessionDataset$Interval[1]
               assign("dueDate_new", dueDate_new, envir = assign.env)
               sessionDataset$dueDate[1] <- as.character.Date(dueDate_new)
               assign("sessionDataset", sessionDataset, envir = assign.env)
               write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
           } else if (sessionDataset$Repetition[1] == 1) {
               sessionDataset$Repetition[1] <- sessionDataset$Repetition[1] + 1
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Score[1] <- sessionDataset$Score[1] + 4
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Interval[1] <- as.difftime(7, units = "days") #+7 day
               assign("sessionDataset", sessionDataset, envir = assign.env)
               dueDate_new <- Sys.Date() + sessionDataset$Interval[1]
               assign("dueDate_new", dueDate_new, envir = assign.env)
               sessionDataset$dueDate[1] <- as.character.Date(dueDate_new)
               assign("sessionDataset", sessionDataset, envir = assign.env)
               write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
           } else if (sessionDataset$Repetition[1] > 1) {
               sessionDataset$Repetition[1] <- sessionDataset$Repetition[1] + 1
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Score[1] <- sessionDataset$Score[1] + 4 
               # SuperMemo 2 algorithm here:
               sessionDataset$eFactor[1] <- max(1.3, sessionDataset$eFactor[[1]]+(0.1-(5-5)*(0.08+(5-5)*0.02)))
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Interval[1] <- (sessionDataset$Interval[[1]] - 1)*sessionDataset$eFactor[[1]]
               assign("sessionDataset", sessionDataset, envir = assign.env)
               dueDate_new <- Sys.Date() + sessionDataset$Interval[[1]]
               assign("dueDate_new", dueDate_new, envir = assign.env)
               sessionDataset$dueDate[1] <- as.character.Date(dueDate_new)
               assign("sessionDataset", sessionDataset, envir = assign.env)
               write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
           },
         # "Hint/Example"
         if (names(sessionDataset[3]) != "Score") {
           message(paste("| Hint/Example:", sessionDataset[1,3],""))
           } else {
           message(paste("| No Hint/Example in this dataset."))
         },
         return(learn()))
  # reorder dataset by dueDate and Score
  sessionDataset <- sessionDataset[order(sessionDataset$dueDate, sessionDataset$Score), ]
  assign("sessionDataset", sessionDataset, envir = assign.env)
  
  write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
  invisible()
  return(sessionQuestions()) # create loop
}
