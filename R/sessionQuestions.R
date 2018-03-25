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
  message(paste("| Question:", sessionDataset[1,1],""))
  switch(menu(c("Show answer", "Hard", "Good", "Easy", "Hint/Example", "Back to menu")) + 1,
         return(sessionExit()),
         message(paste0("| Answer: ", sessionDataset[1,2], "\n")),
         sessionDataset$Score[1] <- sessionDataset$Score[1] + 1,
         sessionDataset$Score[1] <- sessionDataset$Score[1] + 2,
         sessionDataset$Score[1] <- sessionDataset$Score[1] + 4,
         if (names(sessionDataset[3]) != "Score") {
           message(paste("| Hint/Example:", sessionDataset[1,3],"\n"))
         } else {
           message(paste("| No Hint/Example in this dataset.\n"))
         },
         return(learn()))
  sessionDataset <- sessionDataset[order(sessionDataset$Score), ] # reorder dataset
  assign("sessionDataset", sessionDataset, envir = assign.env)
  write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
  invisible()
  return(sessionQuestions()) # create loop
}
