

get_scripts <- function(script) {
  gitpath1 <- "https://raw.githubusercontent.com/"
  author <- "edgar-treischl/"
  repository <- "Scripts_PracticeR"
  gitpath2 <- "/main/R/"
  #script <- "chapter2.R"

  #Make url
  git_url <- paste0(gitpath1, author, repository, gitpath2, script)

  #Get content
  response <- httr::GET(git_url)
  response_text <- httr::content(response, as="text")
  txt <- stringr::str_split(response_text, "\n")

  #Write to clipboard
  txt <- purrr::as_vector(txt)
  #clipr::write_clip(txt)

  #paste(txt, collapse = TRUE)


  write(txt,
        file = script,
        append = FALSE)
}

# copy_scripts <- function(search = "all") {
#   #Name of files
#   chapter <- rep("chapter0", 5)
#   numbers <- 2:09
#   ext <- ".R"
#   reste <- c("chapter10.R", "chapter11.R" , "chapter12.R")
#   search <- paste0(chapter, numbers, ext)
#   search <- append(search, reste)
#
#   #Get files
#   purrr::map(search, get_scripts)
#
# }

get_scripts("chapter02.R")

catch_errors <- function(script) {
  warn <- err <- NULL
  value <- withCallingHandlers(
    tryCatch(
      source(script,
             local = new.env()),
      error = function(e) {
        err <<- e
        NULL
      }
    ),
    warning = function(w) {
      warn <<- w
      invokeRestart("muffleWarning")
    }
  )
  list(value = value,
       warning = warn,
       error = err)
}


write_errors <- function(script) {
  error <- catch_errors(script)
  chapter <- script
  errortext <- as.character(error$error)

  if (length(error$error) == 0) {
    message <- paste(chapter, "No Errors", sep =": ")

    time <- Sys.Date()
    filename <- paste0("Run_", time, ".txt")

    write(message,
          file = filename,
          append = TRUE)
    print("fine")
  } else {
    #errortext <- as.character(error$error)
    message <- paste(chapter, errortext, sep = ": ")

    time <- Sys.Date()
    filename <- paste0("Run_", time, ".txt")

    write(message,
          file = filename,
          append = TRUE)

  }
}



errors_pr <- function() {
  files <- "chapter02.R"
  #list.files(pattern = ".R")
  purrr::map(files, write_errors)
  #unlink(files)
}

errors_pr()
