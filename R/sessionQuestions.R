#' Ask questions in the interactive environment
#'
#' This function will print the questions in the interactive learning environment.
#'
#' @details
#' This function reads the selected dataset and print the first row of its first
#' colomn, i.e. the question. Then it presents to the user a menu, which gives him
#' multiple choices. According to the choice made by the user, the function gives a
#' score point and will return a due date, inspired by the SuperMemo-2 and Anki algorithms.
#' The menu also proposes to show the answer (the 2nd column of the row), to give a
#' hint/example, or to go back to the main menu. Finally, the function reorders the dataset
#' in order to get the lower points score in its first row and return the function once again.
#'
#' @note
#' In order to quit, simply type 0.
#'
#' @param assign.env An environment
#'
#' @importFrom utils menu read.csv select.list write.csv browseURL
#' @importFrom magick image_read image_scale
#'
#' @source \url{https://www.supermemo.com/english/ol/sm2.htm}{ SuperMemo-2 algorithm}
#' @source \url{https://apps.ankiweb.net/docs/manual.html#what-spaced-repetition-algorithm-does-anki-use}{ Anki algorithm}

sessionQuestions <- function(assign.env = parent.frame(1)) {

  sessionDataset <- read.csv(paste0("", datasetAbsolutePath,""), stringsAsFactors = FALSE)

  # order dataset by dueDate and Score
  #sessionDataset <- sessionDataset[order(sessionDataset$dueDate, sessionDataset$Score), ]
  #assign("sessionDataset", sessionDataset, envir = assign.env)

  # check if rows to learn for current session and print question
  if(as.Date(sessionDataset$dueDate[1]) <= as.Date(Sys.Date())) {

    ## list image extension
    image_ext <- c(".jpg", ".JPG", ".jpeg", ".JPEG", ".png", ".PNG", ".svg", ".SVG", ".gif", ".GIF", ".avi", ".AVI", ".ico", ".ICO", ".icon", ".ICON", ".tiff", ".TIFF")

    if(any(sapply(image_ext, function(x) grepl(x, sessionDataset[1,1], fixed = TRUE)))) {
      message(paste("| Question: [see image]"))
      ## PRINT IMAGE

      image1 <- tryCatch(magick::image_read(sessionDataset[1,1]), error = function(e) paste0("Could not read image at ", sessionDataset[1,1]))
      image1 <- tryCatch(magick::image_scale(image1, "x300"), error = function(e) paste0("Could not read image at ", sessionDataset[1,1]))
      print(image1, info = FALSE)

    } else {
      message(paste("| Question:", sessionDataset[1,1],""))
    }

  } else {
    message(paste("| 0 row to learn... Back to menu. \n"))
    return(learn())
  }

  # menu 1, inspired by Anki app
  # ref: https://apps.ankiweb.net/

  switch(menu(c("Show answer", "Hint", paste0("Back to menu (",length(which(sessionDataset$dueDate <= as.Date(Sys.Date())))," left to learn)"))) + 1,
         return(sessionExit()),
         # "Show answer"
         ## list image extension
         if(any(sapply(c(".jpg", ".JPG", ".jpeg", ".JPEG", ".png", ".PNG", ".svg", ".SVG", ".gif", ".GIF", ".avi", ".AVI", ".ico", ".ICO", ".icon", ".ICON", ".tiff", ".TIFF"), function(x) grepl(x, sessionDataset[1,2], fixed = TRUE)))) {
           message(paste("| Answer: [see image]"))
           ## PRINT IMAGE
           image2 <- tryCatch(magick::image_read(sessionDataset[1,2]), error = function(e) paste0("Could not read image at ", sessionDataset[1,2]))
           image2 <- tryCatch(magick::image_scale(image2, "x300"), error = function(e) paste0("Could not scale image at ", sessionDataset[1,2]))
           print(image2, info = FALSE)
         } else {
           message(paste("| Answer:", sessionDataset[1,2],""))
         },
         # "Hint/Example"
         if (names(sessionDataset[3]) != "Score") {
           if(any(sapply(c(".jpg", ".JPG", ".jpeg", ".JPEG", ".png", ".PNG", ".svg", ".SVG", ".gif", ".GIF", ".avi", ".AVI", ".ico", ".ICO", ".icon", ".ICON", ".tiff", ".TIFF"), function(x) grepl(x, sessionDataset[1,3], fixed = TRUE)))) {
             message(paste("| Hint: [see image]"))
             ## If image, open in default browse
             ## Not in viewer because can overwrite image of Question or Answer
             utils::browseURL(sessionDataset[1,3])
             return(sessionQuestions())
           } else {
             message(paste("| Hint:", sessionDataset[1,3],""))
             return(sessionQuestions())
           }
           } else {
           message(paste("| No Hint in this dataset."))
           return(sessionQuestions())
         },
         return(learn()))

  # space repetition learning algorithm, inspired by SuperMemo 2.
  switch(menu(c("Hard", "Good",
                if(sessionDataset$Repetition[1] == 0){ paste0("Easy (+1 day)")}
                  else if(sessionDataset$Repetition[1] == 1){ paste0("Easy (+4 days)")}
                    else if(sessionDataset$Repetition[1] > 1){paste0("Easy (+", (sessionDataset$Interval[[1]] - 1)*max(1.3, sessionDataset$eFactor[[1]]+(0.1-(5-5)*(0.08+(5-5)*0.02))), " days)")}
                      else{ paste0("Easy")})) + 1,
         return(sessionExit()),
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
               sessionDataset$Interval[1] <- as.difftime(4, units = "days") #+4 days (like Anki)
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
               # SuperMemo 2 algorithm below:
               sessionDataset$eFactor[1] <- max(1.3, sessionDataset$eFactor[[1]]+(0.1-(5-5)*(0.08+(5-5)*0.02)))
               assign("sessionDataset", sessionDataset, envir = assign.env)
               sessionDataset$Interval[1] <- (sessionDataset$Interval[[1]] - 1)*sessionDataset$eFactor[[1]]
               assign("sessionDataset", sessionDataset, envir = assign.env)
               dueDate_new <- Sys.Date() + sessionDataset$Interval[[1]]
               assign("dueDate_new", dueDate_new, envir = assign.env)
               sessionDataset$dueDate[1] <- as.character.Date(dueDate_new)
               assign("sessionDataset", sessionDataset, envir = assign.env)
               write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
           })

  # reorder dataset by dueDate and Score
  sessionDataset <- sessionDataset[order(sessionDataset$dueDate, sessionDataset$Score), ]
  assign("sessionDataset", sessionDataset, envir = assign.env)

  write.csv(sessionDataset, file = paste0("", datasetAbsolutePath, ""), row.names = FALSE)
  invisible()
  return(sessionQuestions()) # create loop
}
