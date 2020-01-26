#'////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-01-26
#' MODIFIED: 2020-01-26
#' PURPOSE: backend for app, starts plumber
#' STATUS: in.progress
#' PACKAGES: plumber
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' pkgs
library(plumber)

#' create app
app <- plumber::plumb("./server/api.R")
app$mount("/", PlumberStatic$new("./client"))

#' start
app$run(port = 8000)
