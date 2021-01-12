#' ////////////////////////////////////////////////////////////////////////////
#' FILE: server.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-01-26
#' MODIFIED: 2021-01-10
#' PURPOSE: backend for app, starts plumber
#' STATUS: in.progress
#' PACKAGES: plumber
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

#' install pkgs
#' install.packages(c("htmltools", "rlang", "plumber", "palmerpenguins"))

#' pkgs
library(plumber)

# source utils
source("./server/datatable.R")

#' create app
app <- Plumber$new()

#' mount client
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

        # build html table
        tbl <- as.character(
            datatable(
                data = data,
                id = "starwars_data",
                caption = "Penguins dataset from the `palmerpenguins` pkg"
            )
        )

        # return
        list(html = tbl)
    }
)


#' start
app$run(port = 8000)