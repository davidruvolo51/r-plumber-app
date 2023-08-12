#//////////////////////////////////////////////////////////////////////////////
# FILE: server.R
# AUTHOR: David Ruvolo
# CREATED: 2020-01-26
# MODIFIED: 2023-08-12
# PURPOSE: backend for app, starts plumber
# STATUS: stable
# PACKAGES: **renv**
# COMMENTS: NA
#//////////////////////////////////////////////////////////////////////////////

library(plumber)
source("./server/datatable.R")

app <- Plumber$new()

#' mount client (for frontend development, run `yarn build`)
app$mount("/", PlumberStatic$new("./client/dist"))


#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "*")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  plumber::forward()
}


#' define endpoint: `/html`
app$handle(
  methods = "POST",
  path = "/html",
  handler = function(req, value = 0) {
    val <- as.numeric(value)

    if (val == 999) {
      data <- palmerpenguins::penguins
    } else {
      data <- palmerpenguins::penguins[1:val, ]
    }

    tbl <- as.character(
      datatable(
        data = data,
        id = "palmerpenguins",
        caption = "Penguins dataset from the `palmerpenguins` pkg"
      )
    )

    list(html = tbl)
  }
)

app$run(port = 8000)
