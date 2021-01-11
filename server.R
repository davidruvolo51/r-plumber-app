#'////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-01-26
#' MODIFIED: 2021-01-10
#' PURPOSE: backend for app, starts plumber
#' STATUS: in.progress
#' PACKAGES: plumber
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' install
#' install.packages(c("htmltools", "rlang", "plumber"))

#' pkgs
suppressPackageStartupMessages(library(plumber))

#' create app
app <- plumber::plumb("./server/api.R")
app$mount("/", PlumberStatic$new("./client/dist"))

#' @filter cors
cors <- function(req, res) {

  res$setHeader("Access-Control-Allow-Origin", "*")

    if (req$REQUEST_METHOD == "OPTIONS") {
        res$setHeader("Access-Control-Allow-Methods", "*")
        res$setHeader(
            "Access-Control-Allow-Headers",
            req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS
        )
        res$status <- 200
        return(list())
    } else {
        plumber::forward()
    }
}

#' start
app$run(port = 8000)
